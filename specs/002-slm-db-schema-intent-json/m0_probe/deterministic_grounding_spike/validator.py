"""Schema validator — dev-only spike component (T009d).

Defense-in-depth safety net: even though the ranker only ever constructs
candidates from real schema/lookup data, the validator independently
re-checks every table, column, FK relationship, and lookup value against the
SchemaGraph before a result is accepted. Anything that doesn't exist is
rejected — this is what "reject invented value" / "reject invalid
table/column/value" means in practice.

Also rejects raw SQL fragments appearing anywhere in a string value, per the
spec's Intent JSON contract validator rules (US3).
"""

from __future__ import annotations

import re
from dataclasses import dataclass, field

from ranker import GroundingResult
from schema_graph import SchemaGraph

_SQL_FRAGMENT_RE = re.compile(
    r"\b(select|insert|update|delete|drop|union|--|;--|/\*)\b", re.IGNORECASE
)


@dataclass
class ValidationError:
    code: str
    reference: str
    message: str


@dataclass
class ValidationResult:
    valid: bool
    errors: list[ValidationError] = field(default_factory=list)


def _check_sql_fragment(value: str) -> ValidationError | None:
    if _SQL_FRAGMENT_RE.search(value or ""):
        return ValidationError("sql_fragment_detected", value, "value contains a raw SQL fragment")
    return None


def validate(result: GroundingResult, graph: SchemaGraph) -> ValidationResult:
    errors: list[ValidationError] = []

    if result.root_table is not None and not graph.has_table(result.root_table):
        errors.append(ValidationError("unknown_table", result.root_table, "root_table not present in SchemaGraph"))

    for table in result.candidate_tables:
        if not graph.has_table(table):
            errors.append(ValidationError("unknown_table", table, f"table '{table}' not present in SchemaGraph"))

    for f in result.candidate_filters:
        sql_err = _check_sql_fragment(f.value) or _check_sql_fragment(f.column) or _check_sql_fragment(f.table)
        if sql_err:
            errors.append(sql_err)
            continue
        if not graph.has_table(f.table):
            errors.append(ValidationError("unknown_table", f.table, f"filter table '{f.table}' unknown"))
            continue
        if not graph.has_column(f.table, f.column):
            errors.append(ValidationError("unknown_column", f"{f.table}.{f.column}", "filter column unknown"))
            continue
        if f.operator == "eq" and graph.lookup_values_for(f.table, f.column) is not None:
            if not graph.lookup_has_value(f.table, f.column, f.value):
                errors.append(
                    ValidationError(
                        "invented_lookup_value",
                        f"{f.table}.{f.column}={f.value!r}",
                        "value is not present in the enumerated lookup list — rejected, not invented",
                    )
                )

    for rel in result.relationship_path:
        if "->" not in rel:
            continue
        from_t, to_t = rel.split("->", 1)
        if graph.fk_path(from_t, to_t) is None:
            errors.append(ValidationError("missing_fk_path", rel, f"no FK path from {from_t} to {to_t}"))

    return ValidationResult(valid=not errors, errors=errors)
