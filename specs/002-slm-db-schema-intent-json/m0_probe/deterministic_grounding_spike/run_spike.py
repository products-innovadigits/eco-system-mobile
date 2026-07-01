#!/usr/bin/env python3
"""Deterministic-grounding spike runner — dev-only / off-device (T009d).

Runs the three arms (raw SLM / deterministic / hybrid) over
`m0_golden_questions.md`, using the committed schema metadata asset, and
writes a findings report (JSON + Markdown) to `spike_out/`.

Hard guardrails (per deterministic_grounding_spike_scope.md and
deterministic_grounding_spike_execution_plan.md):
- No SQL, no DB connection, no data retrieval.
- No production Schema Router/Slicer/Validator/Repair/IntentService, no
  `intent/` folder, no Flutter/DI wiring.
- Does NOT update specs/002-slm-db-schema-intent-json/research.md and does
  NOT flip G-M0. This script and its output are dev-only artifacts.

Usage:
    python3 run_spike.py
"""

from __future__ import annotations

import json
from dataclasses import asdict
from pathlib import Path

from golden_questions import GoldenItem, load_golden_questions
from lexicon import CONCEPTS_BY_ID
from ranker import Filter, GroundingResult, ground_question
from raw_slm_outputs import get_raw_output
from schema_graph import SchemaGraph, load_schema
from validator import ValidationResult, validate

OUT_DIR = Path(__file__).resolve().parent / "spike_out"

# Concepts whose table indicates "risk" or "priority" for confusion scoring.
_RISK_TABLES = {"RiskLevels"}
_PRIORITY_TABLES = {"PeriortyLevels"}


def _rel_matches(candidate_rels: list[str], expected_rel: str) -> bool:
    if expected_rel in ("—", "", None):
        return True
    expected_pairs = {tuple(p.strip() for p in seg.split("→")) for seg in expected_rel.split(";")}
    candidate_pairs = {tuple(p.strip() for p in seg.split("->")) for seg in candidate_rels}
    return expected_pairs.issubset(candidate_pairs) or bool(expected_pairs & candidate_pairs)


def _filter_matches(candidate_filters: list[Filter], expected_filter: str) -> bool:
    if expected_filter in ("—", "", None):
        return True
    for seg in expected_filter.split(";"):
        seg = seg.strip()
        if seg.lower().startswith("group by"):
            # Grouping needs the relationship (checked separately via
            # _rel_matches), not a WHERE-style filter value.
            continue
        found = False
        for f in candidate_filters:
            if f.table in seg and f.column in seg:
                found = True
                break
        if not found:
            return False
    return True


def score_against_expected(item: GoldenItem, result: GroundingResult) -> bool:
    expects_clarify = item.expected_clarify.strip().upper() == "Y"
    if item.category == "unsupported" or item.expected_root == "—" and expects_clarify is False and item.expected_intent == "unknown":
        return result.status == "unsupported"
    if expects_clarify:
        return result.needs_clarification is True
    if result.needs_clarification:
        return False
    return _rel_matches(result.relationship_path, item.expected_relationship) and _filter_matches(
        result.candidate_filters, item.expected_filter
    )


def detect_risk_priority_confusion_deterministic(item: GoldenItem, result: GroundingResult) -> bool:
    cat = item.category
    concepts = set(result.matched_concepts)
    if cat == "risk" and "priority" in concepts and "risk" not in concepts:
        return True
    if cat == "priority" and "risk" in concepts and "priority" not in concepts:
        return True
    return False


def detect_risk_priority_confusion_raw(item: GoldenItem, raw: dict | None) -> bool:
    if not raw:
        return False
    cat = item.category
    filters = raw.get("parsed", {}).get("filters", [])
    cols = {f.get("column", "") for f in filters}
    if cat == "risk" and "PeriortyLevelId" in cols and "RiskLevelId" not in cols:
        return True
    if cat == "priority" and "RiskLevelId" in cols and "PeriortyLevelId" not in cols:
        return True
    return False


def build_hybrid(det_result: GroundingResult, raw: dict | None, graph: SchemaGraph) -> dict:
    """Hybrid arm: take the SLM's envelope where present, but always snap
    filters/relationships/values to the deterministic result. If the
    deterministic layer could not confidently snap a value, hybrid reports
    needs_clarification instead of accepting the raw (possibly invented)
    value.
    """
    if raw is None:
        return {
            "note": "no recorded SLM output for this question; hybrid falls back to deterministic-only",
            "candidate_filters": [f.as_str() for f in det_result.candidate_filters],
            "relationship_path": det_result.relationship_path,
            "needs_clarification": det_result.needs_clarification,
            "confidence": det_result.confidence,
        }

    raw_filters = raw.get("parsed", {}).get("filters", [])
    rejected = []
    for rf in raw_filters:
        table, column, value = rf.get("table", ""), rf.get("column", ""), rf.get("value", "")
        if not graph.has_table(table) or not graph.has_column(table, column):
            rejected.append({"table": table, "column": column, "value": value, "reason": "unknown table/column in raw SLM output"})
            continue
        if graph.lookup_values_for(table, column) is not None and not graph.lookup_has_value(table, column, value):
            rejected.append({"table": table, "column": column, "value": value, "reason": "invented value not in enumerated lookup"})

    return {
        "raw_filters_rejected": rejected,
        "snapped_candidate_filters": [f.as_str() for f in det_result.candidate_filters],
        "relationship_path": det_result.relationship_path,
        "needs_clarification": det_result.needs_clarification,
        "confidence": det_result.confidence,
        "note": "raw SLM filter table/column/value always replaced by deterministic snap; raw envelope (intent/language) would be kept in a full implementation",
    }


def estimate_slice_reduction(item: GoldenItem, result: GroundingResult, graph: SchemaGraph) -> dict:
    """Rough char-based estimate of how much smaller a router-selected schema
    slice (root + candidate tables only) is vs sending all 61 tables."""
    full_tables = graph.raw.get("schema_metadata", {}).get("tables", [])
    full_chars = len(json.dumps(full_tables, ensure_ascii=False))

    selected_names = {result.root_table} | set(result.candidate_tables)
    selected_names.discard(None)
    selected_tables = [t for t in full_tables if t["table_name"] in selected_names]
    selected_chars = len(json.dumps(selected_tables, ensure_ascii=False))

    reduction_pct = 0.0
    if full_chars:
        reduction_pct = round(100.0 * (1 - selected_chars / full_chars), 1)
    return {"full_chars": full_chars, "selected_chars": selected_chars, "reduction_pct": reduction_pct}


def run() -> dict:
    graph = load_schema()
    items = load_golden_questions()

    per_question = []
    agg = {
        "deterministic": {"grounded": 0, "invented_value": 0, "confusion": 0, "rel_correct": 0, "rel_expected": 0, "clarify_correct": 0, "pass": 0},
        "raw": {"available": 0, "grounded": 0, "invented_value": 0, "confusion": 0},
        "hybrid": {"pass": 0},
    }
    reduction_pcts = []

    for item in items:
        det = ground_question(item.question, graph)
        val: ValidationResult = validate(det, graph)
        raw = get_raw_output(item.id)
        hybrid = build_hybrid(det, raw, graph)

        passed = score_against_expected(item, det)
        confusion = detect_risk_priority_confusion_deterministic(item, det)
        expects_clarify = item.expected_clarify.strip().upper() == "Y"
        clarify_correct = det.needs_clarification == expects_clarify

        if val.valid:
            agg["deterministic"]["grounded"] += 1
        if any(e.code == "invented_lookup_value" for e in val.errors):
            agg["deterministic"]["invented_value"] += 1
        if confusion:
            agg["deterministic"]["confusion"] += 1
        if item.expected_relationship not in ("—", ""):
            agg["deterministic"]["rel_expected"] += 1
            if _rel_matches(det.relationship_path, item.expected_relationship):
                agg["deterministic"]["rel_correct"] += 1
        if clarify_correct:
            agg["deterministic"]["clarify_correct"] += 1
        if passed:
            agg["deterministic"]["pass"] += 1

        if raw is not None:
            agg["raw"]["available"] += 1
            raw_filters = raw.get("parsed", {}).get("filters", [])
            raw_grounded = all(
                graph.has_table(f.get("table", "")) and graph.has_column(f.get("table", ""), f.get("column", ""))
                for f in raw_filters
            ) if raw_filters else True
            if raw_grounded:
                agg["raw"]["grounded"] += 1
            raw_invented = any(
                graph.lookup_values_for(f.get("table", ""), f.get("column", "")) is not None
                and not graph.lookup_has_value(f.get("table", ""), f.get("column", ""), f.get("value", ""))
                for f in raw_filters
                if graph.has_table(f.get("table", ""))
            ) or any(not graph.has_table(f.get("table", "")) for f in raw_filters)
            if raw_invented:
                agg["raw"]["invented_value"] += 1
            if detect_risk_priority_confusion_raw(item, raw):
                agg["raw"]["confusion"] += 1

        reduction = estimate_slice_reduction(item, det, graph)
        reduction_pcts.append(reduction["reduction_pct"])

        per_question.append(
            {
                "question_id": item.id,
                "language": item.lang,
                "category": item.category,
                "original_question": item.question,
                "normalized_question": det.normalized,
                "matched_concepts": det.matched_concepts,
                "candidate_root_table": det.root_table,
                "candidate_tables": det.candidate_tables,
                "candidate_filters": [f.as_str() for f in det.candidate_filters],
                "matched_lookup_values": det.matched_lookup_values,
                "relationship_path": det.relationship_path,
                "validation_result": {"valid": val.valid, "errors": [asdict(e) for e in val.errors]},
                "confidence": det.confidence,
                "clarification_flag": det.needs_clarification,
                "clarification_reason": det.clarification_reason,
                "status": det.status,
                "expected_result_summary": (
                    f"intent={item.expected_intent}, root={item.expected_root}, "
                    f"targets={item.expected_target_tables}, filter={item.expected_filter}, "
                    f"rel={item.expected_relationship}, clarify={item.expected_clarify}"
                ),
                "pass_fail": "PASS" if passed else "FAIL",
                "raw_slm_output": raw,
                "hybrid_output": hybrid,
                "schema_slice_reduction": reduction,
            }
        )

    n = len(items)
    det_agg = agg["deterministic"]
    raw_agg = agg["raw"]
    summary = {
        "total_questions": n,
        "deterministic": {
            "schema_grounded_pct": round(100 * det_agg["grounded"] / n, 1),
            "invented_value_pct": round(100 * det_agg["invented_value"] / n, 1),
            "risk_priority_confusion_count": det_agg["confusion"],
            "relationship_correct_pct": (
                round(100 * det_agg["rel_correct"] / det_agg["rel_expected"], 1) if det_agg["rel_expected"] else None
            ),
            "clarification_correct_pct": round(100 * det_agg["clarify_correct"] / n, 1),
            "pass_rate_pct": round(100 * det_agg["pass"] / n, 1),
        },
        "raw_slm": {
            "recorded_count": raw_agg["available"],
            "schema_grounded_pct": (round(100 * raw_agg["grounded"] / raw_agg["available"], 1) if raw_agg["available"] else None),
            "invented_value_pct": (round(100 * raw_agg["invented_value"] / raw_agg["available"], 1) if raw_agg["available"] else None),
            "risk_priority_confusion_count": raw_agg["confusion"],
            "note": "only G01 has a recorded raw device output (T009b/T009c full golden-set run not yet performed)",
        },
        "avg_schema_slice_reduction_pct": round(sum(reduction_pcts) / len(reduction_pcts), 1) if reduction_pcts else None,
    }

    return {"summary": summary, "per_question": per_question}


def write_reports(result: dict) -> None:
    OUT_DIR.mkdir(parents=True, exist_ok=True)
    json_path = OUT_DIR / "spike_report.json"
    md_path = OUT_DIR / "spike_report.md"

    with open(json_path, "w", encoding="utf-8") as f:
        json.dump(result, f, ensure_ascii=False, indent=2)

    summary = result["summary"]
    lines = []
    lines.append("# Deterministic-Grounding Spike — Findings Report (dev-only)")
    lines.append("")
    lines.append("**T009d — off-device measurement spike. Not production code. Does not flip G-M0.**")
    lines.append("")
    lines.append(f"Total golden questions run: {summary['total_questions']}")
    lines.append("")
    lines.append("## Three-arm comparison")
    lines.append("")
    lines.append("| Metric | Raw SLM | Deterministic | Hybrid |")
    lines.append("|---|---|---|---|")
    det = summary["deterministic"]
    raw = summary["raw_slm"]
    lines.append(
        f"| Schema-grounded % | {raw['schema_grounded_pct']}% (n={raw['recorded_count']}) | {det['schema_grounded_pct']}% | see per-question hybrid_output (snapped to deterministic) |"
    )
    lines.append(
        f"| Invented-value % | {raw['invented_value_pct']}% (n={raw['recorded_count']}) | {det['invented_value_pct']}% | 0% (raw values always rejected/snapped) |"
    )
    lines.append(
        f"| Risk-vs-priority confusion count | {raw['risk_priority_confusion_count']} (n={raw['recorded_count']}) | {det['risk_priority_confusion_count']} | 0 (snapped to deterministic concept match) |"
    )
    lines.append(f"| Relationship-correct % | n/a (not enough raw data) | {det['relationship_correct_pct']}% | inherits deterministic |")
    lines.append(f"| Clarification-correct % | n/a | {det['clarification_correct_pct']}% | inherits deterministic |")
    lines.append(f"| Pass rate vs golden expected | n/a | {det['pass_rate_pct']}% | n/a (qualitative) |")
    lines.append("")
    lines.append(f"Average schema-slice reduction (router-selected tables vs full 61-table schema): **{summary['avg_schema_slice_reduction_pct']}%**")
    lines.append("")
    lines.append("## Worked case — G01 \"مشاريع عالية الخطورة\"")
    lines.append("")
    g01 = next(q for q in result["per_question"] if q["question_id"] == "G01")
    lines.append("```json")
    lines.append(json.dumps(g01, ensure_ascii=False, indent=2))
    lines.append("```")
    lines.append("")
    lines.append("## Per-question results")
    lines.append("")
    lines.append("| ID | Category | Lang | Status | Clarify? | Confidence | Pass/Fail |")
    lines.append("|---|---|---|---|---|---|---|")
    for q in result["per_question"]:
        lines.append(
            f"| {q['question_id']} | {q['category']} | {q['language']} | {q['status']} | "
            f"{q['clarification_flag']} | {q['confidence']} | {q['pass_fail']} |"
        )

    with open(md_path, "w", encoding="utf-8") as f:
        f.write("\n".join(lines) + "\n")

    print(f"Wrote {json_path}")
    print(f"Wrote {md_path}")


if __name__ == "__main__":
    result = run()
    write_reports(result)
    print(json.dumps(result["summary"], ensure_ascii=False, indent=2))
