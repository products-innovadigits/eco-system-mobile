#!/usr/bin/env python3
"""M0 device-run log parser + auto-scorer — dev-only, off-device (T009b/T009c).

Reads a captured `adb logcat` file from an S22 Ultra M0 probe run (the
already-committed dev-only probe emits `[AiAssistant]` + `[AI_INTENT_PROBE]`
lines), extracts one record per question, maps each to its golden id, and
auto-scores the raw SLM output using the SAME schema graph + golden
expectations as the deterministic-grounding spike — so the raw-SLM arm is
directly comparable to the deterministic/hybrid arms.

Hard guardrails (M0 gate): off-device only. No app code, no SQL, no DB, no
retrieval. Does NOT update research.md and does NOT flip G-M0.

Usage:
    python3 parse_probe_logs.py <logcat_file> [--config-label depth0@1024]
    # writes out/device_run_results.<label>.json and .md
"""

from __future__ import annotations

import argparse
import json
import re
import sys
from dataclasses import asdict, dataclass, field
from pathlib import Path

# Reuse the deterministic spike's schema graph + golden loader + normalizer so
# scoring is identical across arms (single source of truth).
SPIKE_DIR = Path(__file__).resolve().parents[1] / "deterministic_grounding_spike"
sys.path.insert(0, str(SPIKE_DIR))

from golden_questions import GoldenItem, load_golden_questions  # noqa: E402
from normalizer import normalize_question  # noqa: E402
from schema_graph import SchemaGraph, load_schema  # noqa: E402

OUT_DIR = Path(__file__).resolve().parent / "out"

_AI = "[AiAssistant]"
_PROBE = "[AI_INTENT_PROBE]"
_BANNER = "AI CHAT"

# Leading `adb logcat -v time` prefix: "MM-DD HH:MM:SS.mmm  PID  TID L TAG: "
_LOGCAT_PREFIX_RE = re.compile(
    r"^\d{2}-\d{2}\s+\d{2}:\d{2}:\d{2}\.\d+\s+\d+\s+\d+\s+\w\s+[^:]*:\s?"
)

_KV_RE = re.compile(r"(\w+)=([^\s]+)")
_DEPTH_MODE_RE = re.compile(r"INTENT JSON PROBE \(depth=(\d+)\)")
_VARIANT_DEPTH_RE = re.compile(r"variant=depth-(\d+)")
_LATENCY_RE = re.compile(r"latency=(\d+)ms")


def _strip_prefix(line: str, marker: str) -> str | None:
    """Return the substring of `line` starting after `marker`, or None if the
    marker is absent. Tolerates logcat timestamp/pid prefixes before it."""
    idx = line.find(marker)
    if idx < 0:
        return None
    return line[idx + len(marker):].strip()


def _line_kind(line: str) -> str | None:
    if _AI in line:
        return "ai"
    if _PROBE in line:
        return "probe"
    return None


@dataclass
class ProbeRecord:
    question_id: str | None = None
    question_text: str = ""
    depth: int | None = None
    context_tokens: int | None = None
    prompt_len: int | None = None
    est_prompt_tokens: int | None = None
    budget_tokens: int | None = None
    latency_ms: int | None = None
    raw_output: str = ""
    guard_blocked: bool = False
    status: str = ""
    # auto-scored:
    valid_json: bool | None = None
    schema_grounded: bool | None = None
    invented_value: bool | None = None
    relationship_correct: bool | None = None
    clarification_correct: bool | None = None
    risk_priority_confusion: bool | None = None
    parsed_output: dict | None = None
    notes: list[str] = field(default_factory=list)


# ---------------------------------------------------------------------------
# Parsing
# ---------------------------------------------------------------------------

def parse_logcat(text: str) -> list[ProbeRecord]:
    lines = text.splitlines()
    records: list[ProbeRecord] = []
    current: ProbeRecord | None = None
    capturing_raw = False

    def flush():
        nonlocal current
        if current is not None and (current.question_text or current.raw_output or current.guard_blocked):
            current.raw_output = current.raw_output.strip()
            records.append(current)
        current = None

    for line in lines:
        kind = _line_kind(line)

        # A new AI CHAT banner starts a new record.
        if kind == "ai" and _BANNER in line:
            flush()
            current = ProbeRecord()
            capturing_raw = False
            continue

        if current is None:
            # tolerate a run that begins straight at a probe line (no banner)
            if kind == "probe":
                current = ProbeRecord()
            else:
                continue

        if kind == "ai":
            capturing_raw = False
            body = _strip_prefix(line, _AI) or ""
            if "Question :" in body:
                current.question_text = body.split("Question :", 1)[1].strip()
            elif "MODE" in body:
                m = _DEPTH_MODE_RE.search(body)
                if m:
                    current.depth = int(m.group(1))
            elif "Status" in body:
                current.status = body.split("Status", 1)[1].lstrip(" :").strip()
            continue

        if kind == "probe":
            body = _strip_prefix(line, _PROBE) or ""
            if body.startswith("raw_output="):
                current.raw_output = body[len("raw_output="):]
                capturing_raw = True
                continue
            capturing_raw = False
            if "prompt_too_large" in body and "native_call=BLOCKED" in body:
                current.guard_blocked = True
            lat = _LATENCY_RE.search(body)
            if lat:
                current.latency_ms = int(lat.group(1))
            vd = _VARIANT_DEPTH_RE.search(body)
            if vd and current.depth is None:
                current.depth = int(vd.group(1))
            kvs = dict(_KV_RE.findall(body))
            if "context_tokens" in kvs:
                current.context_tokens = _to_int(kvs["context_tokens"])
            if "prompt_len" in kvs:
                current.prompt_len = _to_int(kvs["prompt_len"])
            if "est_prompt_tokens" in kvs:
                current.est_prompt_tokens = _to_int(kvs["est_prompt_tokens"])
            if "budget_tokens" in kvs:
                current.budget_tokens = _to_int(kvs["budget_tokens"])
            continue

        # An unrecognized line while capturing a raw_output that spilled across
        # newlines (multi-line JSON) → append it to raw_output, stripping any
        # leading logcat timestamp/pid/tag prefix so the captured output is the
        # model's text only.
        if capturing_raw and current is not None:
            current.raw_output += "\n" + _LOGCAT_PREFIX_RE.sub("", line)

    flush()
    return records


def _to_int(value: str) -> int | None:
    m = re.match(r"(\d+)", value)
    return int(m.group(1)) if m else None


# ---------------------------------------------------------------------------
# Golden-id mapping
# ---------------------------------------------------------------------------

def build_question_index(items: list[GoldenItem]) -> dict[str, GoldenItem]:
    index = {}
    for it in items:
        index[normalize_question(it.question)["normalized"]] = it
    return index


def map_to_golden(records: list[ProbeRecord], items: list[GoldenItem]) -> None:
    index = build_question_index(items)
    ordered = list(items)
    positional = 0
    for rec in records:
        key = normalize_question(rec.question_text)["normalized"] if rec.question_text else ""
        item = index.get(key)
        if item is None and positional < len(ordered):
            # positional fallback (tester typed G01..G50 in order)
            item = ordered[positional]
            rec.notes.append("mapped positionally (question text did not exact-match a golden question)")
        if item is not None:
            rec.question_id = item.id
            positional = max(positional, ordered.index(item) + 1)


# ---------------------------------------------------------------------------
# Scoring (parity with the deterministic spike's raw-SLM arm)
# ---------------------------------------------------------------------------

def _strip_fences(text: str) -> str:
    t = text.strip()
    if t.startswith("```"):
        t = re.sub(r"^```[a-zA-Z]*\n?", "", t)
        t = re.sub(r"\n?```$", "", t.strip())
    return t.strip()


def _first_balanced_object(text: str) -> str | None:
    start = text.find("{")
    if start < 0:
        return None
    depth = 0
    for i in range(start, len(text)):
        if text[i] == "{":
            depth += 1
        elif text[i] == "}":
            depth -= 1
            if depth == 0:
                return text[start:i + 1]
    return None


def try_parse_json(raw: str) -> dict | None:
    if not raw:
        return None
    candidate = _first_balanced_object(_strip_fences(raw))
    if candidate is None:
        return None
    try:
        obj = json.loads(candidate)
        return obj if isinstance(obj, dict) else None
    except (json.JSONDecodeError, ValueError):
        return None


def _filters_of(obj: dict) -> list[dict]:
    filters = obj.get("filters", [])
    return [f for f in filters if isinstance(f, dict)]


def score_record(rec: ProbeRecord, item: GoldenItem | None, graph: SchemaGraph) -> None:
    if rec.guard_blocked:
        rec.notes.append("guard-blocked: prompt exceeded budget, native engine not called")
        return
    obj = try_parse_json(rec.raw_output)
    rec.parsed_output = obj
    rec.valid_json = obj is not None
    if obj is None:
        return

    filters = _filters_of(obj)

    # schema-grounded / invented: mirror the deterministic spike's raw-SLM arm
    # convention (run_spike.py) exactly, so the arms are directly comparable.
    # A filter with a missing/unknown table is NOT grounded and counts as an
    # invented reference (the model failed to bind it to a real table).
    grounded = True
    invented = False
    for f in filters:
        table, column, value = f.get("table", ""), f.get("column", ""), f.get("value", "")
        if not graph.has_table(table) or not graph.has_column(table, column):
            grounded = False
            invented = True
            continue
        # lookup-value check where the column is an enumerated lookup
        if graph.lookup_values_for(table, column) is not None:
            if not graph.lookup_has_value(table, column, value):
                invented = True
    rec.schema_grounded = grounded
    rec.invented_value = invented

    if item is not None:
        rec.risk_priority_confusion = _detect_confusion(item, filters)
        rec.relationship_correct = _relationship_correct(item, obj, graph)
        rec.clarification_correct = _clarification_correct(item, obj)


def _detect_confusion(item: GoldenItem, filters: list[dict]) -> bool:
    cols = {f.get("column", "") for f in filters}
    cat = item.category
    if cat == "risk" and "PeriortyLevelId" in cols and "RiskLevelId" not in cols:
        return True
    if cat == "priority" and "RiskLevelId" in cols and "PeriortyLevelId" not in cols:
        return True
    return False


def _relationship_correct(item: GoldenItem, obj: dict, graph: SchemaGraph) -> bool:
    expected = item.expected_relationship
    if expected in ("—", "", None):
        return True
    expected_pairs = {
        tuple(p.strip() for p in seg.split("→"))
        for seg in expected.split(";")
        if "→" in seg
    }
    rels = obj.get("relationships", [])
    got_pairs = set()
    for r in rels:
        if isinstance(r, dict):
            a = r.get("from_table") or r.get("fromTable") or r.get("from") or ""
            b = r.get("to_table") or r.get("toTable") or r.get("to") or ""
            if a and b:
                got_pairs.add((a, b))
    return bool(expected_pairs & got_pairs)


def _clarification_correct(item: GoldenItem, obj: dict) -> bool:
    expects = item.expected_clarify.strip().upper() == "Y"
    got = bool(obj.get("needs_clarification", False)) or obj.get("status") in (
        "needs_clarification", "unsupported",
    )
    return got == expects


# ---------------------------------------------------------------------------
# Reporting
# ---------------------------------------------------------------------------

def summarize(records: list[ProbeRecord]) -> dict:
    scored = [r for r in records if not r.guard_blocked]
    n = len(scored)

    def pct(pred) -> float | None:
        vals = [pred(r) for r in scored if pred(r) is not None]
        return round(100 * sum(1 for v in vals if v) / len(vals), 1) if vals else None

    latencies = sorted(r.latency_ms for r in records if r.latency_ms is not None)
    return {
        "total_records": len(records),
        "guard_blocked": sum(1 for r in records if r.guard_blocked),
        "scored_records": n,
        "valid_json_pct": pct(lambda r: r.valid_json),
        "schema_grounded_pct": pct(lambda r: r.schema_grounded),
        "invented_value_pct": pct(lambda r: r.invented_value),
        "risk_priority_confusion_count": sum(1 for r in scored if r.risk_priority_confusion),
        "relationship_correct_pct": pct(lambda r: r.relationship_correct),
        "clarification_correct_pct": pct(lambda r: r.clarification_correct),
        "latency_ms_p50": latencies[len(latencies) // 2] if latencies else None,
        "latency_ms_p90": latencies[int(len(latencies) * 0.9)] if latencies else None,
        "note": "raw-SLM arm scored with the same schema graph + golden expectations as the deterministic spike",
    }


def raw_slm_outputs_snippet(records: list[ProbeRecord]) -> str:
    """Emit a ready-to-paste dict for the spike's raw_slm_outputs.py so the
    real device outputs feed the spike's true three-arm comparison."""
    lines = ["RAW_SLM_OUTPUTS = {"]
    for r in records:
        if r.question_id is None or r.guard_blocked or r.parsed_output is None:
            continue
        raw_text = r.raw_output.replace("\\", "\\\\").replace('"', '\\"').replace("\n", " ")
        lines.append(f'    "{r.question_id}": {{')
        lines.append(f'        "raw_text": "{raw_text}",')
        lines.append(f'        "parsed": {json.dumps(r.parsed_output, ensure_ascii=False)},')
        lines.append('        "source": "S22 Ultra M0 device run (parse_probe_logs.py)",')
        lines.append("    },")
    lines.append("}")
    return "\n".join(lines)


def write_reports(records: list[ProbeRecord], summary: dict, label: str) -> tuple[Path, Path]:
    OUT_DIR.mkdir(parents=True, exist_ok=True)
    safe = re.sub(r"[^\w.-]", "_", label)
    json_path = OUT_DIR / f"device_run_results.{safe}.json"
    md_path = OUT_DIR / f"device_run_results.{safe}.md"

    payload = {
        "config_label": label,
        "summary": summary,
        "records": [asdict(r) for r in records],
        "raw_slm_outputs_snippet": raw_slm_outputs_snippet(records),
    }
    with open(json_path, "w", encoding="utf-8") as f:
        json.dump(payload, f, ensure_ascii=False, indent=2)

    lines = [
        f"# M0 Device-Run Results — `{label}` (dev-only)",
        "",
        "**T009b/T009c — real-device raw-SLM measurement. Auto-scored off-device. Does not flip G-M0.**",
        "",
        "## Summary",
        "",
        "| Metric | Value |",
        "|---|---|",
    ]
    for k, v in summary.items():
        lines.append(f"| {k} | {v} |")
    lines += [
        "",
        "## Per-question records",
        "",
        "| QID | depth | ctx | prompt_len | est_tok | latency_ms | guard | valid_json | grounded | invented | rel_ok | clarify_ok | confusion |",
        "|---|---|---|---|---|---|---|---|---|---|---|---|---|",
    ]
    for r in records:
        lines.append(
            f"| {r.question_id} | {r.depth} | {r.context_tokens} | {r.prompt_len} | "
            f"{r.est_prompt_tokens} | {r.latency_ms} | {r.guard_blocked} | {r.valid_json} | "
            f"{r.schema_grounded} | {r.invented_value} | {r.relationship_correct} | "
            f"{r.clarification_correct} | {r.risk_priority_confusion} |"
        )
    lines += [
        "",
        "## Raw outputs (verbatim)",
        "",
    ]
    for r in records:
        lines.append(f"**{r.question_id}** — `{r.question_text}`")
        lines.append("```")
        lines.append(r.raw_output if not r.guard_blocked else "[guard-blocked: prompt_too_large, native call skipped]")
        lines.append("```")
        lines.append("")
    lines += [
        "## Paste into deterministic_grounding_spike/raw_slm_outputs.py for the 3-arm comparison",
        "",
        "```python",
        raw_slm_outputs_snippet(records),
        "```",
    ]
    with open(md_path, "w", encoding="utf-8") as f:
        f.write("\n".join(lines) + "\n")

    return json_path, md_path


def run(logcat_path: Path, label: str) -> dict:
    text = Path(logcat_path).read_text(encoding="utf-8", errors="replace")
    records = parse_logcat(text)
    items = load_golden_questions()
    graph = load_schema()
    map_to_golden(records, items)
    by_id = {it.id: it for it in items}
    for rec in records:
        score_record(rec, by_id.get(rec.question_id), graph)
    summary = summarize(records)
    json_path, md_path = write_reports(records, summary, label)
    return {"summary": summary, "json": str(json_path), "md": str(md_path), "count": len(records)}


def main() -> None:
    ap = argparse.ArgumentParser(description="Parse + auto-score M0 device-run logcat (dev-only).")
    ap.add_argument("logcat", type=Path, help="captured logcat file")
    ap.add_argument("--config-label", default="run", help="label for the config, e.g. depth0@1024")
    args = ap.parse_args()

    if not args.logcat.exists():
        ap.error(f"logcat file not found: {args.logcat}")
    result = run(args.logcat, args.config_label)
    print(f"Parsed {result['count']} record(s).")
    print(f"Wrote {result['json']}")
    print(f"Wrote {result['md']}")
    print(json.dumps(result["summary"], ensure_ascii=False, indent=2))


if __name__ == "__main__":
    main()
