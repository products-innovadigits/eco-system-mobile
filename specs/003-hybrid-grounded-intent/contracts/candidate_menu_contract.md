# Contract: Candidate Menu and SLM Selection

**Feature**: `003-hybrid-grounded-intent`

This contract defines (a) the typed candidates produced by deterministic retrieval, (b) the compact **candidate menu** rendered for the SLM, and (c) the **selection** the SLM returns. The SLM references candidate IDs only; it never emits schema names, relationships, lookup values, IDs, or entity strings.

## Candidate ID scheme

Each candidate gets a stable, human-readable ID prefixed by its type:

| Prefix | Type | Meaning |
|---|---|---|
| `C#` | selectable field | a catalog `selectable` column, e.g. `Projects.Budget` |
| `F#` | value/lookup filter | a filter on a lookup value reached via a relationship |
| `E#` | entity filter | a filter on a root searchable/entity field equal to an `@ENTITY_n` placeholder |
| `R#` | relationship | an outgoing or incoming FK path |
| `A#` | aggregation | `count/sum/avg/min/max(child.col) as alias` via a relationship |
| `S#` | sort | a sort on a grounded field or aggregation alias |
| `G#` | group_by | a group-by on a grounded field |

IDs are assigned per request (stable within one menu). Every candidate is **grounded by construction** — it references only catalog-validated tables, columns, relationships, and approved values.

> **Note on IDs.** Candidate IDs and relationship IDs are opaque stable catalog identifiers. Examples in this document may use shortened IDs (`F1`, `R1`, `R_OUTPUTS`) for readability, but runtime output must reference IDs that exist in the generated Schema Catalog (`assets/ai/schema/schema_catalog.json`) — e.g. relationship IDs like `R_PROJECTS_PERIORTYLEVELID_PERIORTYLEVELS` and lookup IDs like `LK_PERIORTYLEVELS_NAME`. No consumer may depend on the exact spelling of an example ID.

## Candidate object (internal)

```json
{
  "id": "F1",
  "type": "lookup_filter",
  "table": "PeriortyLevels",
  "column": "Name",
  "operator": "eq",
  "value": "أولوية منخفضة",
  "value_source": "lookup_match",
  "relationship_id": "R_PROJECTS_PRIORITY",
  "description": "PeriortyLevels.Name eq \"أولوية منخفضة\" via R1",
  "score": 0.92,
  "concept_id": "concept_priority"
}
```

Aggregation candidate:

```json
{
  "id": "A1",
  "type": "aggregation",
  "function": "count",
  "table": "ProjectOutPutModels",
  "column": "Id",
  "alias": "output_count",
  "relationship_id": "R_PROJECTS_OUTPUTS",
  "description": "count(ProjectOutPutModels.Id) as output_count via R_OUTPUTS",
  "score": 0.88,
  "concept_id": "concept_outputs"
}
```

Entity filter candidate:

```json
{
  "id": "E1",
  "type": "entity_filter",
  "table": "Projects",
  "column": "Name",
  "operator": "eq",
  "value_placeholder": "@ENTITY_1",
  "value_source": "entity",
  "description": "Projects.Name eq @ENTITY_1",
  "score": 0.80
}
```

## Rendered menu (given to the SLM)

The renderer emits a compact text block. Relationships referenced by other candidates are given short local aliases (`R1`, `R_OUTPUTS`) for readability.

```text
QUESTION: what is the budget of @ENTITY_1

CANDIDATES:
R1 = Projects.PeriortyLevelId -> PeriortyLevels.Id
R_OUTPUTS = Projects.Id -> ProjectOutPutModels.ProjectId
F1 = PeriortyLevels.Name eq "أولوية منخفضة" via R1
C1 = Projects.Budget
E1 = Projects.Name eq @ENTITY_1
A1 = count(ProjectOutPutModels.Id) as output_count via R_OUTPUTS

INTENTS: list_records | count_records | get_record_detail | aggregate_records | compare_records | summarize_records | unknown
```

Rendering rules:

1. The menu MUST be far smaller than the full schema — only retrieved candidates and the relationships they use appear.
2. Every candidate line MUST start with its ID.
3. Entity filters MUST show the placeholder (`@ENTITY_1`), never the raw value.
4. The question shown to the SLM MUST be the placeholder-substituted question.
5. The renderer MUST NOT include denylisted/private fields or unapproved values.

## SLM selection output (returned by the SLM)

The SLM returns IDs only, plus an intent and a clarification flag:

```json
{
  "intent": "get_record_detail",
  "selected_fields": ["C1"],
  "filters": ["E1"],
  "relationships": [],
  "aggregations": [],
  "group_by": [],
  "sort": [],
  "limit": null,
  "needs_clarification": false
}
```

Example for `give me low priorities projects`:

```json
{
  "intent": "list_records",
  "selected_fields": [],
  "filters": [{ "candidate_id": "F1" }],
  "relationships": [],
  "aggregations": [],
  "sort": [],
  "needs_clarification": false
}
```

Both the bare-string form (`"F1"`) and the object form (`{ "candidate_id": "F1" }`) are accepted by the parser; the object form is canonical.

Example for `اكثر المشاريع تقدما من حيث المخرجات`:

```json
{
  "intent": "aggregate_records",
  "aggregations": [{ "candidate_id": "A1" }],
  "sort": [{ "candidate_id": "S1" }],
  "needs_clarification": false
}
```

## Selection rules

1. Every referenced ID MUST exist in the rendered menu; a non-existent ID is a validation error (`candidate_not_found`) and blocks `ok`.
2. The SLM output MUST NOT contain table names, column names, relationship definitions, lookup values, IDs, or entity strings; any such free-form content is ignored, and if it replaces an expected ID reference it is a validation error.
3. `intent` MUST be one of the offered intents.
4. If the SLM cannot choose safely, it MUST set `needs_clarification=true` (or the ranker's ambiguity flag forces it), and the assembler emits `needs_clarification`.
5. Relationships required by a selected filter/aggregation are added deterministically by the assembler from the candidate's `relationship_id`; the SLM does not need to select them explicitly, and selecting a relationship that conflicts with its filter is a validation error.

## From selection to Final Intent JSON

The assembler:

1. Resolves each selected ID back to its grounded candidate.
2. Substitutes `@ENTITY_n` placeholders with exact original values from the entity map.
3. Adds relationships implied by selected filters/aggregations.
4. Runs the validator (see `final_intent_json_contract.md` and `data-model.md`).
5. Emits the Final Intent JSON with `grounding.fully_grounded` and a `status`.

Because every candidate was grounded at retrieval time, the assembled output cannot contain an invented schema reference.
