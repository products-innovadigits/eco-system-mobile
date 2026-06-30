# Contract — Intent JSON (model output)

**Produced by**: `IntentGenerationStrategy` (via `LocalSlmService.generateText`) → `IntentParser`.
**Validated by**: `IntentValidator` against the in-memory `SchemaGraph`.
**Authoritative**: this is the canonical copy of the spec's Intent JSON Contract; the Dart `Intent` model mirrors it 1:1.

## Canonical object

```json
{
  "schema_version": "0.1.0",
  "status": "ok | needs_clarification | unsupported | invalid_schema_reference",
  "language": "ar | en | mixed",
  "intent": "list_records | count_records | summarize_records | get_record_detail | compare_records | unknown",
  "root_table": null,
  "target_tables": [],
  "selected_fields": [],
  "filters": [],
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

## Nested shapes

```json
// selected_fields[] and filters[].{table,column} reference SchemaGraph
"filters": [
  { "table": "Projects", "column": "StatusId", "operator": "eq", "value": "Delayed" }
],
"relationships": [
  { "from_table": "Projects", "to_table": "ProjectStatus" }
],
"aggregations": [
  { "type": "count", "table": "Projects", "column": null }
],
"date_range": { "field": "DueDate", "from": null, "to": null, "relative": "due_soon" },
"sort": [ { "table": "Projects", "column": "DueDate", "direction": "asc" } ],
"clarification_options": [
  {
    "id": "projects",
    "type": "root_table",
    "table": "Projects",
    "display_label": { "ar": "المشاريع", "en": "Projects" },
    "reason": "The question may refer to project records.",
    "confidence": 0.72
  }
],
"validation_errors": [
  { "code": "unknown_column", "reference": "Projects.Priorityy", "message": "Column not found in schema." }
]
```

## Enumerated value domains

- `status`: `ok | needs_clarification | unsupported | invalid_schema_reference`
- `language`: `ar | en | mixed`
- `intent`: `list_records | count_records | summarize_records | get_record_detail | compare_records | unknown`
- `filters[].operator`: `eq | neq | gt | gte | lt | lte | in | contains | between | is_null | is_not_null`
- `aggregations[].type`: `count | sum | avg | min | max`
- `sort[].direction`: `asc | desc`
- `validation_errors[].code`: `unknown_table | unknown_column | no_fk_path | operator_type_mismatch | unknown_lookup_value | sql_fragment | unknown_reference | parse_error`

## Validator rules → status mapping

| Check | On failure |
|---|---|
| `root_table`, `target_tables[]`, every `selected_fields[]`/`filters[]` table & column exist in SchemaGraph | `validation_errors += unknown_table/unknown_column`; `status = invalid_schema_reference` |
| Every `relationships[]` (and any implied join between referenced tables) has an FK path in SchemaGraph | `no_fk_path`; `status = invalid_schema_reference` |
| `filters[].operator` is compatible with the column's `data_type` (e.g. no `gt`/`between` on text status) | `operator_type_mismatch`; `status = invalid_schema_reference` |
| Any referenced lookup/enum value exists in `lookup_values` (when the column `is_lookup`) | `unknown_lookup_value`; `status = invalid_schema_reference` |
| No raw SQL fragment anywhere in any string value (e.g. `select `, ` from `, `;`, `--`, `union `) | `sql_fragment`; `status = invalid_schema_reference` |
| No unknown/invented schema reference of any kind | `unknown_reference`; `status = invalid_schema_reference` |
| Parse failed even after one repair | `parse_error`; `status = invalid_schema_reference` |
| Well-formed, grounded, but ambiguous | `status = needs_clarification`, `needs_clarification = true`, `clarification_question` + `clarification_options` set |
| Out-of-scope question | `status = unsupported`, `unsupported_reason` set, `intent = unknown` |
| Clean, grounded, answerable | `status = ok` |

## Hard rules

- Validation failures are **always surfaced** (debug screen + metrics + `validation_errors`); never silently passed through (FR-019).
- Exactly **one** repair retry is attempted before finalizing (FR-016).
- `clarification_options` are **generated and validated only** in this spec — no clickable UI (deferred to `003-ai-clarification-loop`). Every `clarification_options[].table` MUST exist in the SchemaGraph.
- `confidence` ∈ [0.0, 1.0].
- The pipeline never emits SQL and never connects to a database (FR-026).
