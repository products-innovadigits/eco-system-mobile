"""Simple candidate ranker — dev-only spike component (T009d).

Combines: lexicon hits (lexicon.py) + lookup-value matching (lookup_matcher.py)
+ FK-path existence (schema_graph.py) into a ranked shortlist of
(table, column, value, relationship) candidates, a confidence score, and an
ambiguity/clarification flag. This is the "deterministic grounding" arm.

Pure function of (question, SchemaGraph) -> no model call.
"""

from __future__ import annotations

import re
from dataclasses import dataclass, field

from lexicon import (
    CONCEPTS_BY_ID,
    GROUP_BY_MARKERS,
    SIZE_AMBIGUOUS_TERMS,
    STATUS_AMBIGUOUS_TERMS,
    UNSUPPORTED_TERMS,
    VAGUE_REFERENCE_TERMS,
)
from lookup_matcher import best_lookup_match, build_level_candidate, detect_level
from normalizer import normalize_question
from schema_graph import SchemaGraph

_COUNT_WORDS = ("كم عدد", "كم ", "count", "how many")
_COMPARE_WORDS = ("قارن", "compare", "vs", " بال")
_SUMMARIZE_WORDS = ("ملخص", "summarize", "حسب", "by department", "group", "average", "إجمالي", "top")
_DETAIL_WORDS = ("من هو", "who is", "get_detail")

_NAME_RE = re.compile(r"\b[A-Z][a-z]+\b")


@dataclass
class Filter:
    table: str
    column: str
    operator: str
    value: str

    def as_str(self) -> str:
        return f"{self.table}.{self.column} {self.operator} {self.value!r}"


@dataclass
class GroundingResult:
    question: str
    normalized: str
    language: str
    matched_concepts: list[str] = field(default_factory=list)
    root_table: str | None = None
    candidate_tables: list[str] = field(default_factory=list)
    candidate_filters: list[Filter] = field(default_factory=list)
    matched_lookup_values: list[str] = field(default_factory=list)
    relationship_path: list[str] = field(default_factory=list)
    intent: str = "unknown"
    confidence: float = 0.0
    needs_clarification: bool = False
    clarification_reason: str | None = None
    status: str = "ok"
    unsupported_reason: str | None = None


def _guess_intent(normalized: str) -> str:
    if any(w in normalized for w in _COUNT_WORDS):
        return "count"
    if any(w in normalized for w in _COMPARE_WORDS):
        return "compare"
    if any(w in normalized for w in _DETAIL_WORDS):
        return "get_detail"
    if any(w in normalized for w in _SUMMARIZE_WORDS):
        return "summarize"
    return "list"


def _match_strong_ambiguous(normalized: str) -> tuple[list[str], list[str]]:
    strong, ambiguous = [], []
    for concept in CONCEPTS_BY_ID.values():
        if any(term in normalized for term in concept.strong_terms):
            strong.append(concept.id)
        elif any(term in normalized for term in concept.ambiguous_terms):
            ambiguous.append(concept.id)
    return strong, ambiguous


def _ground_lookup_concept(concept_id: str, graph: SchemaGraph, root: str, normalized: str, result: GroundingResult) -> None:
    concept = CONCEPTS_BY_ID[concept_id]
    path = graph.fk_path(root, concept.table)
    if path is None:
        return  # never invent a relationship that doesn't exist
    level = detect_level(normalized)
    if level is None:
        # concept mentioned but no level word -> grouping/summarize reference,
        # no filter value invented.
        result.candidate_tables.append(concept.table)
        result.relationship_path.append(f"{root}->{concept.table}")
        return
    candidate_phrase = build_level_candidate(concept.value_prefix, level)
    allowed_values = graph.lookup_values_for(concept.table, "Name") or []
    value, score = best_lookup_match(candidate_phrase, allowed_values)
    result.candidate_tables.append(concept.table)
    result.relationship_path.append(f"{root}->{concept.table}")
    if value is not None:
        result.candidate_filters.append(Filter(concept.table, "Name", "eq", value))
        result.matched_lookup_values.append(value)
    else:
        result.needs_clarification = True
        result.clarification_reason = (
            f"'{candidate_phrase}' did not match any enumerated {concept.table}.Name value "
            f"(best score {score:.2f}); refusing to invent a value"
        )


def _ground_delayed(graph: SchemaGraph, root: str, result: GroundingResult) -> None:
    if graph.has_column(root, "EndDate"):
        result.candidate_filters.append(Filter(root, "EndDate", "lt", "today"))


def _ground_budget(graph: SchemaGraph, root: str, normalized: str, result: GroundingResult) -> None:
    if not graph.has_column(root, "Budget"):
        return
    amount_match = re.search(r"(\d[\d,]*)", normalized)
    if "top" in normalized or "أعلى" in normalized:
        result.candidate_filters.append(Filter(root, "Budget", "sort_desc", "-"))
    elif amount_match:
        op = "lt" if ("تقل" in normalized or "under" in normalized or "less" in normalized) else "gt"
        result.candidate_filters.append(Filter(root, "Budget", op, amount_match.group(1)))
    else:
        result.candidate_filters.append(Filter(root, "Budget", "agg", "sum_or_avg"))


def _ground_dates(graph: SchemaGraph, root: str, normalized: str, result: GroundingResult) -> None:
    col = "StartDate" if "start" in normalized or "starting" in normalized or "يبدا" in normalized else "EndDate"
    if graph.has_column(root, col):
        result.candidate_filters.append(Filter(root, col, "date_range", "relative"))


def _has_vague_reference(normalized: str) -> bool:
    return any(term in normalized for term in VAGUE_REFERENCE_TERMS)


def _is_group_by_phrasing(normalized: str) -> bool:
    return any(marker in normalized for marker in GROUP_BY_MARKERS)


def _ground_free_text_concept(concept_id: str, graph: SchemaGraph, root: str, normalized: str, question: str, result: GroundingResult) -> None:
    concept = CONCEPTS_BY_ID[concept_id]
    path = graph.fk_path(root, concept.table)
    if path is None:
        return
    result.candidate_tables.append(concept.table)
    result.relationship_path.append(f"{root}->{concept.table}")

    group_by = _is_group_by_phrasing(normalized)

    if concept_id == "manager":
        names = _NAME_RE.findall(question)
        if names:
            result.candidate_filters.append(Filter("AspNetUsers", "FullName", "eq", names[0]))
        elif not group_by and _has_vague_reference(normalized):
            result.needs_clarification = True
            result.clarification_reason = "manager/project reference is implied but not stated (e.g. 'this project', 'a certain manager')"
        # else: keyword-only manager reference (group-by / detail) -> no invented value
        return

    if group_by:
        # e.g. "المشاريع حسب الإدارة" / "projects by lifecycle stage" ->
        # summarize/group-by; surface the relationship only, invent no value.
        return

    # A specific (but not-yet-resolved) value of this concept was likely
    # named -> try to resolve it against the enumerated lookup; if it can't
    # be resolved, clarify rather than invent it.
    allowed = graph.lookup_values_for(concept.table, "Name") or graph.lookup_values_for(concept.table, "Title") or []
    lookup_column = "Name" if graph.lookup_values_for(concept.table, "Name") is not None else "Title"
    value, _score = best_lookup_match(normalized, allowed, threshold=0.55)
    if value is None:
        for tok in _NAME_RE.findall(question):
            value, _score = best_lookup_match(tok, allowed, threshold=0.6)
            if value:
                break
    if value is not None:
        result.candidate_filters.append(Filter(concept.table, lookup_column, "eq", value))
        result.matched_lookup_values.append(value)
    else:
        result.needs_clarification = True
        result.clarification_reason = (
            f"a specific {concept.table} value appears to be referenced but did not match any "
            f"enumerated {concept.table}.{lookup_column} value"
        )


def ground_question(question: str, graph: SchemaGraph) -> GroundingResult:
    norm = normalize_question(question)
    result = GroundingResult(
        question=question,
        normalized=norm["normalized"],
        language=norm["language"],
        root_table=graph.root_table,
        intent=_guess_intent(norm["normalized"]),
    )

    if any(term in norm["normalized"] for term in UNSUPPORTED_TERMS):
        result.status = "unsupported"
        result.intent = "unknown"
        result.unsupported_reason = "question matches an out-of-scope / disallowed signal (no writes, no schema introspection, no unrelated topics, no sensitive data)"
        result.root_table = None
        return result

    strong, ambiguous = _match_strong_ambiguous(norm["normalized"])
    result.matched_concepts = strong

    if any(term in norm["normalized"] for term in STATUS_AMBIGUOUS_TERMS) and not strong:
        result.needs_clarification = True
        result.status = "needs_clarification"
        result.intent = "unknown"
        result.clarification_reason = "question implies a project status concept, but this schema has no status column on Projects"
        result.confidence = 0.2
        return result

    if not strong and ambiguous:
        # e.g. "المهمة" / "الهامة" / "critical": genuinely ambiguous between
        # priority and (loosely) risk -> clarify, never guess.
        result.needs_clarification = True
        result.status = "needs_clarification"
        result.candidate_tables = ["PeriortyLevels", "RiskLevels"]
        result.clarification_reason = (
            "ambiguous importance wording ('important'/'المهمة'/'الهامة'-class term) "
            "could mean priority or risk; refusing to guess"
        )
        result.confidence = 0.35
        return result

    if not strong and any(term in norm["normalized"] for term in SIZE_AMBIGUOUS_TERMS):
        # e.g. "المشاريع الكبيرة" ("the big projects") — vague scale wording
        # with no single schema target (budget? output count? team size?).
        result.needs_clarification = True
        result.status = "needs_clarification"
        result.candidate_tables = ["Projects"]
        result.clarification_reason = "vague size/scale wording ('big'/'large'/'كبيرة') has no single schema target; refusing to guess"
        result.confidence = 0.3
        return result

    if not strong:
        # No business concept matched at all. This is correct and common for
        # plain whole-set queries ("list all projects", "كم عدد المشاريع؟")
        # and must NOT be forced into a clarification.
        result.confidence = 0.5
        return result

    root = result.root_table
    scores: list[float] = []
    for concept_id in strong:
        concept = CONCEPTS_BY_ID[concept_id]
        before_filters = len(result.candidate_filters)
        if concept.table is not None and concept.value_prefix is not None:
            _ground_lookup_concept(concept_id, graph, root, norm["normalized"], result)
        elif concept_id == "delayed":
            _ground_delayed(graph, root, result)
        elif concept_id == "budget":
            _ground_budget(graph, root, norm["normalized"], result)
        elif concept_id == "dates":
            _ground_dates(graph, root, norm["normalized"], result)
        elif concept.table is not None:
            _ground_free_text_concept(concept_id, graph, root, norm["normalized"], question, result)
        if len(result.candidate_filters) > before_filters:
            scores.append(0.9)
        else:
            scores.append(0.6)

    if result.needs_clarification:
        result.status = "needs_clarification"
        result.confidence = 0.4
    else:
        result.confidence = round(sum(scores) / len(scores), 2) if scores else 0.5

    result.candidate_tables = sorted(set(result.candidate_tables))
    result.relationship_path = sorted(set(result.relationship_path))
    return result
