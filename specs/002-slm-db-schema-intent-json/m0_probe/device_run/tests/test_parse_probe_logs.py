"""Lightweight tests for the M0 device-run log parser (T009b/T009c).

Dev-only, off-device. Run with:
    python3 -m unittest discover -s tests -v
(from inside device_run/)

Not part of the project's Dart/Flutter CI-safe test set — guards the parser only.
"""

from __future__ import annotations

import sys
import unittest
from pathlib import Path

DEVICE_RUN_DIR = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(DEVICE_RUN_DIR))

from parse_probe_logs import (  # noqa: E402
    parse_logcat,
    map_to_golden,
    score_record,
    try_parse_json,
)
from golden_questions import load_golden_questions  # noqa: E402
from schema_graph import load_schema  # noqa: E402

SAMPLE = (DEVICE_RUN_DIR / "sample_logcat.txt").read_text(encoding="utf-8")


class TestParsing(unittest.TestCase):
    def setUp(self):
        self.records = parse_logcat(SAMPLE)

    def test_extracts_three_blocks(self):
        self.assertEqual(len(self.records), 3)

    def test_extracts_question_and_depth(self):
        r0 = self.records[0]
        self.assertEqual(r0.question_text, "مشاريع عالية الخطورة")
        self.assertEqual(r0.depth, 0)

    def test_extracts_probe_fields(self):
        r0 = self.records[0]
        self.assertEqual(r0.context_tokens, 1024)
        self.assertEqual(r0.prompt_len, 1420)
        self.assertEqual(r0.est_prompt_tokens, 406)
        self.assertEqual(r0.budget_tokens, 768)
        self.assertEqual(r0.latency_ms, 8350)

    def test_captures_single_line_raw_output(self):
        r0 = self.records[0]
        self.assertIn("PeriortyLevelId", r0.raw_output)
        self.assertIn("الهامة", r0.raw_output)

    def test_captures_multiline_fenced_raw_output(self):
        r1 = self.records[1]
        self.assertIn("RiskLevels", r1.raw_output)
        self.assertIn("مخاطر عالية", r1.raw_output)

    def test_detects_guard_block(self):
        r2 = self.records[2]
        self.assertTrue(r2.guard_blocked)
        self.assertEqual(r2.depth, 2)


BRIEF_FORMAT = """
I/flutter (32054): [AiAssistant] ╔══════════════ AI CHAT ══════════════
I/flutter (32054): [AiAssistant] ║ Question : show high risk projects
I/flutter (32054): [AiAssistant] ║ MODE     : INTENT JSON PROBE (depth=0)
I/flutter (32054): [AI_INTENT_PROBE] variant=depth-0 mode=one_shot_fresh_session prompt_len=1362 est_prompt_tokens=390(estimated) context_tokens=1024 budget_tokens=768
I/flutter (32054): [AI_INTENT_PROBE] latency=14661ms
I/flutter (32054): [AI_INTENT_PROBE] raw_output=```json
I/flutter (32054): {
I/flutter (32054):   "status": "ok",
I/flutter (32054):   "filters": [{"table":"RiskLevels","column":"Name","operator":"eq","value":"مخاطر عالية"}]
I/flutter (32054): }
I/flutter (32054): ```
I/flutter (32054): [AiAssistant] ║ Status   : ✅ SUCCESS (14666 ms)
"""


class TestBriefFormat(unittest.TestCase):
    """`adb logcat` default/brief format (I/flutter ( PID): ...) as emitted
    on the real S22 Ultra — continuation lines carry a brief prefix that must
    be stripped so multi-line JSON reconstructs and parses."""

    def test_brief_format_multiline_json_parses(self):
        records = parse_logcat(BRIEF_FORMAT)
        self.assertEqual(len(records), 1)
        obj = try_parse_json(records[0].raw_output)
        self.assertIsNotNone(obj)
        self.assertEqual(obj["status"], "ok")
        self.assertEqual(obj["filters"][0]["table"], "RiskLevels")


class TestGoldenMapping(unittest.TestCase):
    def test_maps_questions_to_ids(self):
        records = parse_logcat(SAMPLE)
        items = load_golden_questions()
        map_to_golden(records, items)
        self.assertEqual(records[0].question_id, "G01")
        self.assertEqual(records[1].question_id, "G02")
        self.assertEqual(records[2].question_id, "G08")


class TestJsonParsing(unittest.TestCase):
    def test_strips_fences_and_extracts_object(self):
        obj = try_parse_json('```json\n{"a":1}\n```')
        self.assertEqual(obj, {"a": 1})

    def test_extracts_first_balanced_object_from_prose(self):
        obj = try_parse_json('here is the result {"status":"ok"} thanks')
        self.assertEqual(obj, {"status": "ok"})

    def test_returns_none_on_garbage(self):
        self.assertIsNone(try_parse_json("no json here"))


class TestScoring(unittest.TestCase):
    def setUp(self):
        self.graph = load_schema()
        self.items = {it.id: it for it in load_golden_questions()}
        self.records = parse_logcat(SAMPLE)
        map_to_golden(self.records, list(self.items.values()))
        for r in self.records:
            score_record(r, self.items.get(r.question_id), self.graph)

    def test_g01_raw_is_invented_and_ungrounded(self):
        r0 = self.records[0]  # G01 — the known failure output
        self.assertTrue(r0.valid_json)
        self.assertFalse(r0.schema_grounded)
        self.assertTrue(r0.invented_value)
        self.assertTrue(r0.risk_priority_confusion)

    def test_g02_grounded_output_scores_clean(self):
        r1 = self.records[1]  # G02 — a correct grounded output
        self.assertTrue(r1.valid_json)
        self.assertTrue(r1.schema_grounded)
        self.assertFalse(r1.invented_value)
        self.assertTrue(r1.relationship_correct)

    def test_guard_blocked_record_is_not_scored(self):
        r2 = self.records[2]
        self.assertTrue(r2.guard_blocked)
        self.assertIsNone(r2.valid_json)


if __name__ == "__main__":
    unittest.main()
