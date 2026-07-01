# M0 Device-Run Results — `sample_depth0@1024` (dev-only)

**T009b/T009c — real-device raw-SLM measurement. Auto-scored off-device. Does not flip G-M0.**

## Summary

| Metric | Value |
|---|---|
| total_records | 3 |
| guard_blocked | 1 |
| scored_records | 2 |
| valid_json_pct | 100.0 |
| schema_grounded_pct | 50.0 |
| invented_value_pct | 50.0 |
| risk_priority_confusion_count | 1 |
| relationship_correct_pct | 50.0 |
| clarification_correct_pct | 100.0 |
| latency_ms_p50 | 8350 |
| latency_ms_p90 | 8350 |
| note | raw-SLM arm scored with the same schema graph + golden expectations as the deterministic spike |

## Per-question records

| QID | depth | ctx | prompt_len | est_tok | latency_ms | guard | valid_json | grounded | invented | rel_ok | clarify_ok | confusion |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| G01 | 0 | 1024 | 1420 | 406 | 8350 | False | True | False | True | False | True | True |
| G02 | 0 | 1024 | 1402 | 401 | 7700 | False | True | True | False | True | True | False |
| G08 | 2 | 1024 | 4291 | 1226 | None | True | None | None | None | None | None | None |

## Raw outputs (verbatim)

**G01** — `مشاريع عالية الخطورة`
```
{"filters":[{"table":"","column":"PeriortyLevelId","value":"الهامة"}],"relationships":[],"confidence":1.0}
```

**G02** — `show high risk projects`
```
```json
{"status":"ok","root_table":"Projects","filters":[{"table":"RiskLevels","column":"Name","operator":"eq","value":"مخاطر عالية"}],"relationships":[{"from_table":"Projects","to_table":"RiskLevels"}],"needs_clarification":false}
```
```

**G08** — `المشاريع المتأخرة`
```
[guard-blocked: prompt_too_large, native call skipped]
```

## Paste into deterministic_grounding_spike/raw_slm_outputs.py for the 3-arm comparison

```python
RAW_SLM_OUTPUTS = {
    "G01": {
        "raw_text": "{\"filters\":[{\"table\":\"\",\"column\":\"PeriortyLevelId\",\"value\":\"الهامة\"}],\"relationships\":[],\"confidence\":1.0}",
        "parsed": {"filters": [{"table": "", "column": "PeriortyLevelId", "value": "الهامة"}], "relationships": [], "confidence": 1.0},
        "source": "S22 Ultra M0 device run (parse_probe_logs.py)",
    },
    "G02": {
        "raw_text": "```json {\"status\":\"ok\",\"root_table\":\"Projects\",\"filters\":[{\"table\":\"RiskLevels\",\"column\":\"Name\",\"operator\":\"eq\",\"value\":\"مخاطر عالية\"}],\"relationships\":[{\"from_table\":\"Projects\",\"to_table\":\"RiskLevels\"}],\"needs_clarification\":false} ```",
        "parsed": {"status": "ok", "root_table": "Projects", "filters": [{"table": "RiskLevels", "column": "Name", "operator": "eq", "value": "مخاطر عالية"}], "relationships": [{"from_table": "Projects", "to_table": "RiskLevels"}], "needs_clarification": false},
        "source": "S22 Ultra M0 device run (parse_probe_logs.py)",
    },
}
```
