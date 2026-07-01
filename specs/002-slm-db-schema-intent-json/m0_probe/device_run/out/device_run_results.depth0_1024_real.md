# M0 Device-Run Results — `depth0@1024_real` (dev-only)

**T009b/T009c — real-device raw-SLM measurement. Auto-scored off-device. Does not flip G-M0.**

## Summary

| Metric | Value |
|---|---|
| total_records | 3 |
| guard_blocked | 0 |
| scored_records | 3 |
| valid_json_pct | 100.0 |
| schema_grounded_pct | 0.0 |
| invented_value_pct | 100.0 |
| risk_priority_confusion_count | 1 |
| relationship_correct_pct | 0.0 |
| clarification_correct_pct | 100.0 |
| latency_ms_p50 | 15392 |
| latency_ms_p90 | 16182 |
| note | raw-SLM arm scored with the same schema graph + golden expectations as the deterministic spike |

## Per-question records

| QID | depth | ctx | prompt_len | est_tok | latency_ms | guard | valid_json | grounded | invented | rel_ok | clarify_ok | confusion |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| G01 | 0 | 1024 | 1359 | 389 | 16182 | False | True | False | True | False | True | False |
| G02 | 0 | 1024 | 1362 | 390 | 14661 | False | True | False | True | False | True | False |
| G03 | 0 | 1024 | 1370 | 392 | 15392 | False | True | False | True | False | True | True |

## Raw outputs (verbatim)

**G01** — `مشاريع عالية الخطورة`
```
```json
{
  "schema_version": "0.1.0",
  "status": "ok",
  "language": "ar",
  "intent": "list_records",
  "root_table": "Projects",
  "target_tables": [],
  "selected_fields": [],
  "filters": [
    {
      "table": "",
      "column": "",
      "operator": "eq",
      "value": "مخاطر عالية"
    }
  ],
  "relationships": [],
  "aggregations": [],
  "date_range": null,
  "sort": [],
  "limit": null,
  "confidence": 0.0,
  "needs_clarification": false,
  "clarification_question": null,
  "clarification_options": [],
  "unsupported_reason": null,
  "validation_errors": []
}
```
```

**G02** — `show high risk projects`
```
```json
{
  "schema_version": "0.1.0",
  "status": "ok",
  "language": "ar",
  "intent": "list_records",
  "root_table": "Projects",
  "target_tables": [],
  "selected_fields": [],
  "filters": [
    {
      "table": "",
      "column": "",
      "operator": "eq",
      "value": "مخاطر عالية"
    }
  ],
  "relationships": [],
  "aggregations": [],
  "date_range": null,
  "sort": [],
  "limit": null,
  "confidence": 1.0,
  "needs_clarification": false,
  "clarification_question": null,
  "clarification_options": [],
  "unsupported_reason": null,
  "validation_errors": []
}
```
```

**G03** — `كم عدد المشاريع منخفضة المخاطر؟`
```
```json
{
  "schema_version": "0.1.0",
  "status": "ok",
  "language": "ar",
  "intent": "count_records",
  "root_table": "Projects",
  "target_tables": [],
  "selected_fields": ["Id", "PeriortyLevelId"],
  "filters": [
    {
      "table": "",
      "column": "PeriortyLevelId",
      "operator": "eq",
      "value": "1"
    }
  ],
  "relationships": [],
  "aggregations": [],
  "date_range": null,
  "sort": [],
  "limit": null,
  "confidence": 1.0,
  "needs_clarification": false,
  "clarification_question": null,
  "clarification_options": [],
  "unsupported_reason": null,
  "validation_errors": []
}
```
```

## Paste into deterministic_grounding_spike/raw_slm_outputs.py for the 3-arm comparison

```python
RAW_SLM_OUTPUTS = {
    "G01": {
        "raw_text": "```json {   \"schema_version\": \"0.1.0\",   \"status\": \"ok\",   \"language\": \"ar\",   \"intent\": \"list_records\",   \"root_table\": \"Projects\",   \"target_tables\": [],   \"selected_fields\": [],   \"filters\": [     {       \"table\": \"\",       \"column\": \"\",       \"operator\": \"eq\",       \"value\": \"مخاطر عالية\"     }   ],   \"relationships\": [],   \"aggregations\": [],   \"date_range\": null,   \"sort\": [],   \"limit\": null,   \"confidence\": 0.0,   \"needs_clarification\": false,   \"clarification_question\": null,   \"clarification_options\": [],   \"unsupported_reason\": null,   \"validation_errors\": [] } ```",
        "parsed": {"schema_version": "0.1.0", "status": "ok", "language": "ar", "intent": "list_records", "root_table": "Projects", "target_tables": [], "selected_fields": [], "filters": [{"table": "", "column": "", "operator": "eq", "value": "مخاطر عالية"}], "relationships": [], "aggregations": [], "date_range": null, "sort": [], "limit": null, "confidence": 0.0, "needs_clarification": false, "clarification_question": null, "clarification_options": [], "unsupported_reason": null, "validation_errors": []},
        "source": "S22 Ultra M0 device run (parse_probe_logs.py)",
    },
    "G02": {
        "raw_text": "```json {   \"schema_version\": \"0.1.0\",   \"status\": \"ok\",   \"language\": \"ar\",   \"intent\": \"list_records\",   \"root_table\": \"Projects\",   \"target_tables\": [],   \"selected_fields\": [],   \"filters\": [     {       \"table\": \"\",       \"column\": \"\",       \"operator\": \"eq\",       \"value\": \"مخاطر عالية\"     }   ],   \"relationships\": [],   \"aggregations\": [],   \"date_range\": null,   \"sort\": [],   \"limit\": null,   \"confidence\": 1.0,   \"needs_clarification\": false,   \"clarification_question\": null,   \"clarification_options\": [],   \"unsupported_reason\": null,   \"validation_errors\": [] } ```",
        "parsed": {"schema_version": "0.1.0", "status": "ok", "language": "ar", "intent": "list_records", "root_table": "Projects", "target_tables": [], "selected_fields": [], "filters": [{"table": "", "column": "", "operator": "eq", "value": "مخاطر عالية"}], "relationships": [], "aggregations": [], "date_range": null, "sort": [], "limit": null, "confidence": 1.0, "needs_clarification": false, "clarification_question": null, "clarification_options": [], "unsupported_reason": null, "validation_errors": []},
        "source": "S22 Ultra M0 device run (parse_probe_logs.py)",
    },
    "G03": {
        "raw_text": "```json {   \"schema_version\": \"0.1.0\",   \"status\": \"ok\",   \"language\": \"ar\",   \"intent\": \"count_records\",   \"root_table\": \"Projects\",   \"target_tables\": [],   \"selected_fields\": [\"Id\", \"PeriortyLevelId\"],   \"filters\": [     {       \"table\": \"\",       \"column\": \"PeriortyLevelId\",       \"operator\": \"eq\",       \"value\": \"1\"     }   ],   \"relationships\": [],   \"aggregations\": [],   \"date_range\": null,   \"sort\": [],   \"limit\": null,   \"confidence\": 1.0,   \"needs_clarification\": false,   \"clarification_question\": null,   \"clarification_options\": [],   \"unsupported_reason\": null,   \"validation_errors\": [] } ```",
        "parsed": {"schema_version": "0.1.0", "status": "ok", "language": "ar", "intent": "count_records", "root_table": "Projects", "target_tables": [], "selected_fields": ["Id", "PeriortyLevelId"], "filters": [{"table": "", "column": "PeriortyLevelId", "operator": "eq", "value": "1"}], "relationships": [], "aggregations": [], "date_range": null, "sort": [], "limit": null, "confidence": 1.0, "needs_clarification": false, "clarification_question": null, "clarification_options": [], "unsupported_reason": null, "validation_errors": []},
        "source": "S22 Ultra M0 device run (parse_probe_logs.py)",
    },
}
```
