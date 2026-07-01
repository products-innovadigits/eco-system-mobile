# Deterministic-Grounding Spike — Findings Report (dev-only)

**T009d — off-device measurement spike. Not production code. Does not flip G-M0.**

Total golden questions run: 50

## Three-arm comparison

| Metric | Raw SLM | Deterministic | Hybrid |
|---|---|---|---|
| Schema-grounded % | 0.0% (n=1) | 100.0% | see per-question hybrid_output (snapped to deterministic) |
| Invented-value % | 100.0% (n=1) | 0.0% | 0% (raw values always rejected/snapped) |
| Risk-vs-priority confusion count | 1 (n=1) | 0 | 0 (snapped to deterministic concept match) |
| Relationship-correct % | n/a (not enough raw data) | 96.3% | inherits deterministic |
| Clarification-correct % | n/a | 100.0% | inherits deterministic |
| Pass rate vs golden expected | n/a | 100.0% | n/a (qualitative) |

Average schema-slice reduction (router-selected tables vs full 61-table schema): **95.8%**

## Worked case — G01 "مشاريع عالية الخطورة"

```json
{
  "question_id": "G01",
  "language": "AR",
  "category": "risk",
  "original_question": "مشاريع عالية الخطورة",
  "normalized_question": "مشاريع عاليه الخطوره",
  "matched_concepts": [
    "risk"
  ],
  "candidate_root_table": "Projects",
  "candidate_tables": [
    "RiskLevels"
  ],
  "candidate_filters": [
    "RiskLevels.Name eq 'مخاطر عالية'"
  ],
  "matched_lookup_values": [
    "مخاطر عالية"
  ],
  "relationship_path": [
    "Projects->RiskLevels"
  ],
  "validation_result": {
    "valid": true,
    "errors": []
  },
  "confidence": 0.9,
  "clarification_flag": false,
  "clarification_reason": null,
  "status": "ok",
  "expected_result_summary": "intent=list, root=Projects, targets=RiskLevels, filter=RiskLevels.Name eq \"مخاطر عالية\", rel=Projects→RiskLevels, clarify=N",
  "pass_fail": "PASS",
  "raw_slm_output": {
    "raw_text": "{\"filters\":[{\"table\":\"\",\"column\":\"PeriortyLevelId\",\"value\":\"الهامة\"}],\"relationships\":[],\"confidence\":1.0}",
    "parsed": {
      "filters": [
        {
          "table": "",
          "column": "PeriortyLevelId",
          "value": "الهامة"
        }
      ],
      "relationships": [],
      "confidence": 1.0
    },
    "source": "deterministic_grounding_spike_execution_plan.md §0 (3x identical greedy on-device runs)"
  },
  "hybrid_output": {
    "raw_filters_rejected": [
      {
        "table": "",
        "column": "PeriortyLevelId",
        "value": "الهامة",
        "reason": "unknown table/column in raw SLM output"
      }
    ],
    "snapped_candidate_filters": [
      "RiskLevels.Name eq 'مخاطر عالية'"
    ],
    "relationship_path": [
      "Projects->RiskLevels"
    ],
    "needs_clarification": false,
    "confidence": 0.9,
    "note": "raw SLM filter table/column/value always replaced by deterministic snap; raw envelope (intent/language) would be kept in a full implementation"
  },
  "schema_slice_reduction": {
    "full_chars": 160612,
    "selected_chars": 7942,
    "reduction_pct": 95.1
  }
}
```

## Per-question results

| ID | Category | Lang | Status | Clarify? | Confidence | Pass/Fail |
|---|---|---|---|---|---|---|
| G01 | risk | AR | ok | False | 0.9 | PASS |
| G02 | risk | EN | ok | False | 0.9 | PASS |
| G03 | risk | AR | ok | False | 0.9 | PASS |
| G04 | risk | mixed | ok | False | 0.9 | PASS |
| G05 | priority | AR | ok | False | 0.9 | PASS |
| G06 | priority | EN | ok | False | 0.9 | PASS |
| G07 | risk-vs-priority | AR | ok | False | 0.9 | PASS |
| G08 | delayed | AR | ok | False | 0.9 | PASS |
| G09 | delayed | EN | ok | False | 0.9 | PASS |
| G10 | delayed | AR | ok | False | 0.9 | PASS |
| G11 | due-soon | EN | ok | False | 0.9 | PASS |
| G12 | dates | AR | ok | False | 0.9 | PASS |
| G13 | manager | AR | needs_clarification | True | 0.4 | PASS |
| G14 | manager | EN | ok | False | 0.6 | PASS |
| G15 | manager | AR | needs_clarification | True | 0.4 | PASS |
| G16 | manager | EN | ok | False | 0.9 | PASS |
| G17 | department | AR | ok | False | 0.6 | PASS |
| G18 | department | EN | needs_clarification | True | 0.4 | PASS |
| G19 | department | AR | needs_clarification | True | 0.4 | PASS |
| G20 | lifecycle | EN | ok | False | 0.6 | PASS |
| G21 | lifecycle | AR | needs_clarification | True | 0.4 | PASS |
| G22 | category | EN | ok | False | 0.6 | PASS |
| G23 | budget | AR | ok | False | 0.9 | PASS |
| G24 | budget | EN | ok | False | 0.9 | PASS |
| G25 | budget | AR | ok | False | 0.9 | PASS |
| G26 | budget | EN | ok | False | 0.75 | PASS |
| G27 | count | AR | ok | False | 0.5 | PASS |
| G28 | list | EN | ok | False | 0.5 | PASS |
| G29 | compare | EN | ok | False | 0.9 | PASS |
| G30 | summary | AR | ok | False | 0.6 | PASS |
| G31 | summary | EN | ok | False | 0.6 | PASS |
| G32 | summary | AR | ok | False | 0.6 | PASS |
| G33 | ambiguous-status | AR | needs_clarification | True | 0.2 | PASS |
| G34 | ambiguous-status | EN | needs_clarification | True | 0.2 | PASS |
| G35 | ambiguous-status | AR | needs_clarification | True | 0.2 | PASS |
| G36 | unsupported | EN | unsupported | False | 0.0 | PASS |
| G37 | unsupported | AR | unsupported | False | 0.0 | PASS |
| G38 | unsupported | EN | unsupported | False | 0.0 | PASS |
| G39 | unsupported | AR | unsupported | False | 0.0 | PASS |
| G40 | unsupported | EN | unsupported | False | 0.0 | PASS |
| G41 | ambiguous | AR | needs_clarification | True | 0.35 | PASS |
| G42 | ambiguous | EN | needs_clarification | True | 0.35 | PASS |
| G43 | ambiguous | AR | needs_clarification | True | 0.3 | PASS |
| G44 | risk | mixed | ok | False | 0.9 | PASS |
| G45 | priority | mixed | ok | False | 0.9 | PASS |
| G46 | delayed | mixed | ok | False | 0.9 | PASS |
| G47 | multi-filter | EN | needs_clarification | True | 0.4 | PASS |
| G48 | multi-filter | AR | ok | False | 0.9 | PASS |
| G49 | dates | EN | ok | False | 0.9 | PASS |
| G50 | manager+risk | AR | ok | False | 0.75 | PASS |
