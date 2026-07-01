"""Schema / FK graph matcher — dev-only spike component (T009d).

Loads the committed schema metadata asset
(`systems/project_management/assets/ai/schema/projects_db_metadata_schema.json`)
and builds an in-memory adjacency graph so candidate tables/columns/relationship
paths can be resolved and validated against the *real* schema — never invented.

No DB connection, no SQL, no network. Read-only JSON parsing only.
"""

from __future__ import annotations

import json
from collections import deque
from dataclasses import dataclass, field
from pathlib import Path

REPO_ROOT = Path(__file__).resolve().parents[4]
DEFAULT_SCHEMA_PATH = (
    REPO_ROOT
    / "systems"
    / "project_management"
    / "assets"
    / "ai"
    / "schema"
    / "projects_db_metadata_schema.json"
)

_NUMERIC_TYPES = {
    "int", "bigint", "smallint", "tinyint", "decimal", "numeric",
    "float", "real", "money", "smallmoney",
}
_DATE_TYPES = {"date", "datetime", "datetime2", "smalldatetime", "datetimeoffset", "time"}
_TEXT_TYPES = {"nvarchar", "varchar", "nchar", "char", "text", "ntext"}

# Operators the ranker/validator may propose; per column-type family.
_OPERATORS_BY_FAMILY = {
    "numeric": {"eq", "ne", "gt", "gte", "lt", "lte"},
    "date": {"eq", "ne", "gt", "gte", "lt", "lte", "between"},
    "text": {"eq", "ne", "contains"},
    "bool": {"eq", "ne"},
}


@dataclass
class ColumnInfo:
    name: str
    data_type: str
    is_primary_key: bool
    is_foreign_key: bool

    @property
    def type_family(self) -> str:
        t = self.data_type.lower()
        if t in _NUMERIC_TYPES:
            return "numeric"
        if t in _DATE_TYPES:
            return "date"
        if t in ("bit",):
            return "bool"
        return "text"


@dataclass
class TableInfo:
    name: str
    schema: str
    columns: dict[str, ColumnInfo] = field(default_factory=dict)


@dataclass
class FkEdge:
    fk_name: str
    from_table: str
    from_column: str
    to_table: str
    to_column: str


class SchemaGraph:
    """In-memory schema graph: tables, columns, FK adjacency, lookup values."""

    def __init__(self, raw: dict):
        self.raw = raw
        self.root_table: str = raw.get("root_table", "Projects")
        self.tables: dict[str, TableInfo] = {}
        self.edges: list[FkEdge] = []
        self._adjacency: dict[str, list[FkEdge]] = {}
        self.lookup_values: dict[tuple[str, str], list[str]] = {}

        for t in raw.get("schema_metadata", {}).get("tables", []):
            table = TableInfo(name=t["table_name"], schema=t.get("table_schema", "dbo"))
            for c in t.get("columns", []):
                table.columns[c["column_name"]] = ColumnInfo(
                    name=c["column_name"],
                    data_type=c.get("data_type", ""),
                    is_primary_key=bool(c.get("is_primary_key")),
                    is_foreign_key=bool(c.get("is_foreign_key")),
                )
            self.tables[table.name] = table

        for r in raw.get("schema_metadata", {}).get("relationships", []):
            edge = FkEdge(
                fk_name=r["fk_name"],
                from_table=r["from_table"],
                from_column=r["from_column"],
                to_table=r["to_table"],
                to_column=r["to_column"],
            )
            self.edges.append(edge)
            self._adjacency.setdefault(edge.from_table, []).append(edge)

        for lv in raw.get("lookup_values", []):
            key = (lv["table_name"], lv["column_name"])
            self.lookup_values[key] = list(lv.get("values", []))

    # ---- table / column existence -------------------------------------------------

    def has_table(self, table: str) -> bool:
        return bool(table) and table in self.tables

    def has_column(self, table: str, column: str) -> bool:
        return self.has_table(table) and column in self.tables[table].columns

    def column_info(self, table: str, column: str) -> ColumnInfo | None:
        if not self.has_column(table, column):
            return None
        return self.tables[table].columns[column]

    def operator_allowed(self, table: str, column: str, operator: str) -> bool:
        col = self.column_info(table, column)
        if col is None:
            return False
        allowed = _OPERATORS_BY_FAMILY.get(col.type_family, set())
        return operator in allowed

    # ---- lookup values --------------------------------------------------------------

    def lookup_values_for(self, table: str, column: str = "Name") -> list[str] | None:
        return self.lookup_values.get((table, column))

    def lookup_has_value(self, table: str, column: str, value: str) -> bool:
        values = self.lookup_values_for(table, column)
        return bool(values) and value in values

    # ---- FK path resolution ----------------------------------------------------------

    def fk_path(self, from_table: str, to_table: str, max_depth: int = 2) -> list[FkEdge] | None:
        """BFS shortest FK path from `from_table` to `to_table`, depth-bounded.

        Returns the list of edges forming the path, or None if no path exists
        within `max_depth` hops (never invents a relationship).
        """
        if from_table == to_table:
            return []
        if not self.has_table(from_table) or not self.has_table(to_table):
            return None

        start: tuple[str, list[FkEdge]] = (from_table, [])
        queue: deque = deque([start])
        visited = {from_table}
        while queue:
            current, path = queue.popleft()
            if len(path) >= max_depth:
                continue
            for edge in self._adjacency.get(current, []):
                if edge.to_table in visited:
                    continue
                new_path = path + [edge]
                if edge.to_table == to_table:
                    return new_path
                visited.add(edge.to_table)
                queue.append((edge.to_table, new_path))
        return None

    def neighbors(self, table: str, depth: int = 2) -> set[str]:
        seen = {table}
        frontier = {table}
        for _ in range(depth):
            nxt = set()
            for t in frontier:
                for edge in self._adjacency.get(t, []):
                    if edge.to_table not in seen:
                        nxt.add(edge.to_table)
                        seen.add(edge.to_table)
            frontier = nxt
        seen.discard(table)
        return seen


def load_schema(path: Path | str = DEFAULT_SCHEMA_PATH) -> SchemaGraph:
    with open(path, encoding="utf-8") as f:
        raw = json.load(f)
    return SchemaGraph(raw)
