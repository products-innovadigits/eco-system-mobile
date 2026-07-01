# Contract: Final Validated Intent JSON

**Feature**: `003-hybrid-grounded-intent`

This contract describes the final output after normalization, entity extraction, catalog-driven candidate retrieval, SLM candidate-ID selection, deterministic validation, and deterministic assembly. It is **not** the raw SLM output. Raw SLM output never reaches the SQL Generator: it is confined to candidate-ID selection and is discarded once the deterministic assembler has expanded the selection. A later backend SQL Generator (out of scope in this phase) will consume this Final Intent JSON, and MUST consume only results where `status="ok"` and `grounding.fully_grounded=true`.

> **Note on IDs.** Candidate IDs and relationship IDs are opaque stable catalog identifiers. Examples in this document may use shortened IDs (`R_PROJECTS_PRIORITY`, `R_PROJECTS_OUTPUTS`) for readability, but runtime output must reference IDs that exist in the generated Schema Catalog (`assets/ai/schema/schema_catalog.json`) — e.g. `R_PROJECTS_PERIORTYLEVELID_PERIORTYLEVELS`, `R_PROJECTS_ID_PROJECTOUTPUTMODELS`. No consumer may depend on the exact spelling of an example ID.

## Canonical Object

```json
{
  "schema_version": "0.2.0",
  "catalog_version": "0.1.0",
  "status": "ok",
  "language": "ar",
  "intent": "list_records",
  "root_table": "Projects",
  "selected_fields": [],
  "filters": [
    {
      "table": "PeriortyLevels",
      "column": "Name",
      "operator": "eq",
      "value": "أولوية منخفضة",
      "value_source": "lookup_match",
      "via_relationship": "R_PROJECTS_PRIORITY",
      "candidate_id": "F1"
    }
  ],
  "relationships": [
    {
      "id": "R_PROJECTS_PRIORITY",
      "direction": "outgoing",
      "from_table": "Projects",
      "from_column": "PeriortyLevelId",
      "to_table": "PeriortyLevels",
      "to_column": "Id"
    }
  ],
  "aggregations": [],
  "group_by": [],
  "sort": [],
  "limit": null,
  "entities": {},
  "grounding": {
    "fully_grounded": true,
    "grounded_confidence": 0.9,
    "model_confidence": 0.0,
    "source_map": {
      "filters[0]": "candidate:F1",
      "relationships[0]": "candidate:F1.relationship"
    },
    "matched_concepts": ["concept_priority"],
    "matched_lookup_values": ["أولوية منخفضة"]
  },
  "needs_clarification": false,
  "clarification_question": null,
  "clarification_options": [],
  "unsupported_reason": null,
  "validation_errors": []
}
```

## Field Set

| Field | Meaning |
|---|---|
| `schema_version` | Version of this Final Intent JSON contract. |
| `catalog_version` | Version of the Schema Catalog used to ground this result. |
| `status` | `ok` \| `needs_clarification` \| `unsupported` \| `invalid`. |
| `language` | `ar` \| `en` \| `mixed`. |
| `intent` | See enum below. |
| `root_table` | Grounded root table (`Projects` in v1); `null` for unsupported. |
| `selected_fields` | Grounded selectable columns (`Table.Column`) for detail/aggregation output. |
| `filters` | Grounded filters (lookup, entity, numeric, date). |
| `relationships` | FK paths (outgoing/incoming) required by filters/aggregations. |
| `aggregations` | `count/sum/avg/min/max(child.col) as alias` via a relationship. |
| `group_by` | Grounded group-by fields. |
| `sort` | Grounded sort on a field or aggregation alias. |
| `limit` | Optional integer limit. |
| `entities` | Placeholder → exact original value map, verbatim. |
| `grounding` | Grounding metadata incl. `fully_grounded`, confidences, and source map. |
| `needs_clarification` | Convenience boolean mirroring `status`. |
| `clarification_question` / `clarification_options` | Present when clarification is needed. |
| `unsupported_reason` | Present when `status="unsupported"`. |
| `validation_errors` | Structured error list; empty when `ok`. |

## Enumerated Values

- `status`: `ok | needs_clarification | unsupported | invalid`
- `language`: `ar | en | mixed`
- `intent`: `list_records | count_records | get_record_detail | aggregate_records | compare_records | summarize_records | unknown`
- `filters[].operator`: `eq | neq | gt | gte | lt | lte | in | contains | between | is_null | is_not_null`
- `filters[].value_source`: `lookup_match | entity | date_rule | numeric_parse | free_text_slot`
- `relationships[].direction`: `outgoing | incoming`
- `aggregations[].function`: `count | sum | avg | min | max`

## Required Rules

1. `root_table` MUST be present for supported project intents and MUST exist in the catalog.
2. Every `selected_fields`, `filters[].table/column`, `group_by`, and `sort` reference MUST exist in the catalog and be role-appropriate (`selectable` / `filterable` / `sortable`).
3. Every lookup filter `value` MUST come from an approved catalog `LookupSet`; raw FK IDs and invented values are invalid.
4. Every `entities` value MUST equal the exact original captured span; a translated or modified value is invalid.
5. Every relationship MUST correspond to a catalog relationship or path (outgoing or incoming); missing paths are invalid.
6. Every aggregation MUST target a table related to `root_table` via its declared relationship; unrelated tables are invalid.
7. Empty table or column strings MUST NOT appear in `ok` output.
8. SQL fragments MUST NOT appear anywhere.
9. Every emitted reference MUST trace to a selected candidate (`grounding.source_map`); references with no candidate origin are invalid.
10. `grounding.fully_grounded` MUST be `true` only when rules 1–9 hold with zero `validation_errors`.
11. `status="ok"` requires `grounding.fully_grounded=true`.
12. `grounding.grounded_confidence` MUST derive from deterministic evidence; `model_confidence` MAY be recorded but MUST NOT override grounding.

## Known Required Outputs

### Lookup via outgoing FK — `give me low priorities projects`

```json
{
  "status": "ok",
  "language": "en",
  "intent": "list_records",
  "root_table": "Projects",
  "filters": [
    { "table": "PeriortyLevels", "column": "Name", "operator": "eq", "value": "أولوية منخفضة", "value_source": "lookup_match", "via_relationship": "R_PROJECTS_PRIORITY" }
  ],
  "relationships": [
    { "id": "R_PROJECTS_PRIORITY", "direction": "outgoing", "from_table": "Projects", "from_column": "PeriortyLevelId", "to_table": "PeriortyLevels", "to_column": "Id" }
  ],
  "grounding": { "fully_grounded": true }
}
```

Forbidden: empty table/column, `operator: "lt"`, `RiskLevels`, raw value `"1"`, empty relationships.

### Entity detail — `what is the budget of أتمتة العقود والقوانين`

```json
{
  "status": "ok",
  "language": "ar",
  "intent": "get_record_detail",
  "root_table": "Projects",
  "selected_fields": ["Projects.Budget"],
  "filters": [
    { "table": "Projects", "column": "Name", "operator": "eq", "value": "أتمتة العقود والقوانين", "value_source": "entity" }
  ],
  "relationships": [],
  "entities": { "@ENTITY_1": "أتمتة العقود والقوانين" },
  "grounding": { "fully_grounded": true }
}
```

Forbidden: `intent: "list_records"`, empty `selected_fields`, translated value `"automation of contracts and laws"`, `column: "Name"` used as a bare selected field instead of the filter.

### Reverse-FK aggregation — `اكثر المشاريع تقدما من حيث المخرجات`

```json
{
  "status": "ok",
  "language": "ar",
  "intent": "aggregate_records",
  "root_table": "Projects",
  "aggregations": [
    { "function": "count", "table": "ProjectOutPutModels", "column": "Id", "alias": "output_count", "via_relationship": "R_PROJECTS_OUTPUTS" }
  ],
  "relationships": [
    { "id": "R_PROJECTS_OUTPUTS", "direction": "incoming", "from_table": "Projects", "from_column": "Id", "to_table": "ProjectOutPutModels", "to_column": "ProjectId" }
  ],
  "sort": [ { "field": "output_count", "order": "desc" } ],
  "grounding": { "fully_grounded": true }
}
```

Forbidden: a fabricated `EndDate gt today()` filter, an aggregation over an unrelated table, missing reverse relationship.

## Clarification Shape

```json
{
  "status": "needs_clarification",
  "intent": "unknown",
  "root_table": "Projects",
  "needs_clarification": true,
  "clarification_question": "هل تقصد مستوى المخاطر أم الأولوية؟",
  "clarification_options": [
    { "id": "concept_risk", "labels": { "ar": "مستوى المخاطر", "en": "Risk level" }, "confidence": 0.55 },
    { "id": "concept_priority", "labels": { "ar": "الأولوية", "en": "Priority" }, "confidence": 0.45 }
  ],
  "grounding": { "fully_grounded": false },
  "validation_errors": [
    { "code": "ambiguous_concept", "reference": "المهمة", "message": "The term can refer to risk or priority." }
  ]
}
```

No clickable clarification UI is part of this feature.

## Unsupported Shape

```json
{
  "status": "unsupported",
  "language": "en",
  "intent": "unknown",
  "root_table": null,
  "selected_fields": [],
  "filters": [],
  "relationships": [],
  "aggregations": [],
  "grounding": { "fully_grounded": false },
  "unsupported_reason": "The question is outside the supported projects intent scope.",
  "validation_errors": []
}
```

## Validation Error Codes

- `empty_table`
- `empty_column`
- `unknown_table`
- `unknown_column`
- `missing_relationship`
- `invalid_lookup_value`
- `invented_lookup_value`
- `raw_lookup_id`
- `operator_type_mismatch`
- `entity_value_modified`
- `aggregation_unrelated_table`
- `ungrounded_sort_or_group`
- `sql_fragment`
- `invented_reference`
- `candidate_not_found`
- `ambiguous_concept`
- `unsupported_request`
- `parse_error`
