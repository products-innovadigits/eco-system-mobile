"""Lightweight tests for the deterministic-grounding spike (T009d).

Dev-only, off-device. Run with:
    python3 -m unittest discover -s tests -v
(from inside deterministic_grounding_spike/)

These are not production Flutter/Dart tests and are not part of the
project's CI-safe test set; they only guard the spike harness itself.
"""

from __future__ import annotations

import sys
import unittest
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parents[1]))

from golden_questions import load_golden_questions  # noqa: E402
from lookup_matcher import best_lookup_match, detect_level  # noqa: E402
from normalizer import normalize_question  # noqa: E402
from ranker import Filter, ground_question  # noqa: E402
from schema_graph import load_schema  # noqa: E402
from validator import validate  # noqa: E402


class TestNormalizer(unittest.TestCase):
    def test_strips_tashkeel_and_collapses_letters(self):
        result = normalize_question("مُشَاريع عالِية الخُطورة")
        self.assertNotIn("ُ", result["normalized"])
        self.assertIn("خطوره", result["normalized"])  # ة -> ه

    def test_detects_language(self):
        self.assertEqual(normalize_question("مشاريع عالية الخطورة")["language"], "ar")
        self.assertEqual(normalize_question("show high risk projects")["language"], "en")
        self.assertEqual(normalize_question("show المشاريع high risk")["language"], "mixed")


class TestLookupMatcher(unittest.TestCase):
    def test_exact_and_fuzzy_match_returns_verbatim_value(self):
        values = ["مخاطر عالية", "مخاطر متوسطة", "مخاطر منخفضة"]
        value, score = best_lookup_match("مخاطر عاليه", values)  # ta-marbuta variant
        self.assertEqual(value, "مخاطر عالية")
        self.assertGreaterEqual(score, 0.9)

    def test_invented_value_is_rejected(self):
        values = ["مخاطر عالية", "مخاطر متوسطة", "مخاطر منخفضة"]
        value, score = best_lookup_match("الهامة", values)
        self.assertIsNone(value)

    def test_detect_level(self):
        self.assertEqual(detect_level("مشاريع عاليه الخطوره"), "high")
        self.assertEqual(detect_level("projects with low priority"), "low")
        self.assertIsNone(detect_level("مشاريع بلا وصف"))


class TestSchemaGraph(unittest.TestCase):
    def setUp(self):
        self.graph = load_schema()

    def test_loads_real_schema(self):
        self.assertTrue(self.graph.has_table("Projects"))
        self.assertTrue(self.graph.has_table("RiskLevels"))
        self.assertGreater(len(self.graph.tables), 50)

    def test_fk_path_exists_for_known_relationships(self):
        self.assertIsNotNone(self.graph.fk_path("Projects", "RiskLevels"))
        self.assertIsNotNone(self.graph.fk_path("Projects", "PeriortyLevels"))
        self.assertIsNotNone(self.graph.fk_path("Projects", "AspNetUsers"))

    def test_fk_path_is_none_for_nonexistent_relationship(self):
        self.assertIsNone(self.graph.fk_path("Projects", "NotARealTable"))

    def test_lookup_values_are_verbatim_from_schema(self):
        values = self.graph.lookup_values_for("RiskLevels", "Name")
        self.assertEqual(values, ["مخاطر عالية", "مخاطر متوسطة", "مخاطر منخفضة"])


class TestWorkedCaseG01(unittest.TestCase):
    """The spec's required worked case: 'مشاريع عالية الخطورة'."""

    def setUp(self):
        self.graph = load_schema()
        self.result = ground_question("مشاريع عالية الخطورة", self.graph)

    def test_root_table_is_projects(self):
        self.assertEqual(self.result.root_table, "Projects")

    def test_filter_is_risklevels_not_priority(self):
        self.assertIn("RiskLevels", self.result.candidate_tables)
        self.assertNotIn("PeriortyLevels", self.result.matched_concepts)
        filters_str = [f.as_str() for f in self.result.candidate_filters]
        self.assertTrue(any("RiskLevels.Name" in s and "مخاطر عالية" in s for s in filters_str))

    def test_relationship_is_projects_to_risklevels(self):
        self.assertIn("Projects->RiskLevels", self.result.relationship_path)

    def test_does_not_reference_priority_level_id(self):
        for f in self.result.candidate_filters:
            self.assertNotEqual(f.column, "PeriortyLevelId")

    def test_invented_value_is_not_present(self):
        for f in self.result.candidate_filters:
            self.assertNotEqual(f.value, "الهامة")

    def test_passes_validation(self):
        val = validate(self.result, self.graph)
        self.assertTrue(val.valid, msg=val.errors)


class TestValidatorRejectsBadReferences(unittest.TestCase):
    def setUp(self):
        self.graph = load_schema()

    def test_rejects_unknown_table(self):
        from ranker import GroundingResult

        bad = GroundingResult(
            question="x", normalized="x", language="en",
            root_table="Projects", candidate_tables=["NotATable"],
        )
        val = validate(bad, self.graph)
        self.assertFalse(val.valid)
        self.assertTrue(any(e.code == "unknown_table" for e in val.errors))

    def test_rejects_unknown_column(self):
        from ranker import GroundingResult

        bad = GroundingResult(
            question="x", normalized="x", language="en",
            root_table="Projects",
            candidate_filters=[Filter("Projects", "NotAColumn", "eq", "1")],
        )
        val = validate(bad, self.graph)
        self.assertFalse(val.valid)
        self.assertTrue(any(e.code == "unknown_column" for e in val.errors))

    def test_rejects_invented_lookup_value(self):
        from ranker import GroundingResult

        bad = GroundingResult(
            question="x", normalized="x", language="en",
            root_table="Projects",
            candidate_filters=[Filter("RiskLevels", "Name", "eq", "الهامة")],
        )
        val = validate(bad, self.graph)
        self.assertFalse(val.valid)
        self.assertTrue(any(e.code == "invented_lookup_value" for e in val.errors))

    def test_rejects_sql_fragment(self):
        from ranker import GroundingResult

        bad = GroundingResult(
            question="x", normalized="x", language="en",
            root_table="Projects",
            candidate_filters=[Filter("Projects", "Name", "eq", "x'; DROP TABLE Projects;--")],
        )
        val = validate(bad, self.graph)
        self.assertFalse(val.valid)
        self.assertTrue(any(e.code == "sql_fragment_detected" for e in val.errors))

    def test_rejects_missing_fk_path(self):
        from ranker import GroundingResult

        bad = GroundingResult(
            question="x", normalized="x", language="en",
            root_table="Projects", relationship_path=["Projects->ChallengeStatuses"],
        )
        val = validate(bad, self.graph)
        self.assertFalse(val.valid)
        self.assertTrue(any(e.code == "missing_fk_path" for e in val.errors))


class TestAmbiguousQuestionsClarify(unittest.TestCase):
    def setUp(self):
        self.graph = load_schema()

    def test_al_hamma_importance_wording_clarifies(self):
        result = ground_question("اعرض المشاريع المهمة", self.graph)
        self.assertTrue(result.needs_clarification)
        self.assertEqual(result.status, "needs_clarification")

    def test_critical_clarifies(self):
        result = ground_question("show critical projects", self.graph)
        self.assertTrue(result.needs_clarification)

    def test_status_wording_with_no_status_column_clarifies(self):
        result = ground_question("المشاريع المكتملة", self.graph)
        self.assertTrue(result.needs_clarification)

    def test_unsupported_question(self):
        result = ground_question("what is the weather today?", self.graph)
        self.assertEqual(result.status, "unsupported")


class TestGoldenQuestionsLoader(unittest.TestCase):
    def test_loads_fifty_questions(self):
        items = load_golden_questions()
        self.assertEqual(len(items), 50)
        self.assertEqual(items[0].id, "G01")
        self.assertEqual(items[-1].id, "G50")


if __name__ == "__main__":
    unittest.main()
