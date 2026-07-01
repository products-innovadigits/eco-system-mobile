# Data Model: Hybrid Grounded Intent Pipeline

**Feature**: `003-hybrid-grounded-intent` | **Date**: 2026-07-01

All entities are in-memory production models for the grounded intent mode plus one local asset (the Schema Catalog). They do not imply SQL generation, database connections, data retrieval, backend calls, or MCP. The Schema Catalog asset shape is fixed by `contracts/schema_catalog_contract.md`; the menu/selection shapes by `contracts/candidate_menu_contract.md`; the output by `contracts/final_intent_json_contract.md`.

## Pipeline Overview

```text
GroundedIntentRequest
  → NormalizedQuestion
  → EntityMap (spans → @ENTITY_n)
  → SchemaCatalog (loaded asset) → SchemaGraph
  → ConceptMatch[] + LookupMatch[]
  → Candidate[]  (typed, grounded, with IDs)
  → CandidateMenu (rendered)
  → SlmSelection (candidate IDs only)
  → ValidationResult
  → FinalIntentJson + GroundingEvidence
```

## Local Catalog Entities

### SchemaCatalog

In-memory representation of `schema_catalog.json`.

| Field | Meaning |
|---|---|
| `catalogVersion` | Catalog asset version. |
| `sourceSchemaVersion` | Raw schema version this catalog was generated from. |
| `rootTables` | Root tables (v1: `Projects`). |
| `tables` | `CatalogTable[]`. |
| `relationships` | Outgoing + incoming `Relationship[]` and `RelationshipPath[]`. |
| `lookups` | `LookupSet[]`. |
| `concepts` | `Concept[]`. |
| `exclusions` | Denylisted/private tables and columns. |

### CatalogTable / CatalogColumn

| Field | Meaning |
|---|---|
| `name`, `schema`, `isRoot`, `primaryKey` | Table identity. |
| `columns[]` | `CatalogColumn`: `name`, `dataType`, `isPrimaryKey`, `isForeignKey`, `references`, `roles`, `conceptTags`, `synonyms`. |

Column `roles` ⊆ `{safe, selectable, searchable, entity, aggregatable, sortable, filterable}`. A column without `safe` (or listed in `exclusions`) is never a candidate.

### Relationship / RelationshipPath

| Field | Meaning |
|---|---|
| `id`, `direction` | `outgoing` or `incoming`. |
| `fromTable`, `fromColumn`, `toTable`, `toColumn`, `fkName` | FK edge. |
| `RelationshipPath.hops[]` | Ordered relationship ids for depth-2/depth-N paths. |

### LookupSet

| Field | Meaning |
|---|---|
| `id`, `table`, `column`, `reachedVia` | Lookup identity + relationship id. |
| `values[]` | Approved values, copied verbatim from source metadata. |

### Concept

| Field | Meaning |
|---|---|
| `id`, `labels`, `synonyms` | Concept identity + ar/en synonyms. |
| `target` | Grounded target: `column` \| `lookup_filter` \| `aggregation`. |
| `conflictsWith` | Concept ids that make this ambiguous (e.g. risk ↔ priority). |

## SchemaGraph

Built from the catalog; generic traversal, no per-concept branches.

| Capability | Meaning |
|---|---|
| direct columns | selectable/filterable/sortable columns of the root table |
| outgoing FKs | `Projects → PeriortyLevels`, `Projects → RiskLevels`, … |
| incoming/reverse FKs | `Projects.Id → ProjectOutPutModels.ProjectId`, … |
| relationship paths | configured paths from the catalog (v1: depth-1; depth-N future scope) |
| aggregation targets | child tables reachable via incoming FKs |

Invariant: the graph exposes only what the catalog declares; it cannot synthesize an edge that is not present.

## Request/Processing Entities

### GroundedIntentRequest

| Field | Meaning |
|---|---|
| `question` | Original user question. |
| `mode` | Must indicate grounded intent mode, not free-text chat. |
| `localeHint` | Optional; final language is detected by normalization. |
| `expectedCatalogVersion` | Optional guard against stale catalog. |

### NormalizedQuestion

| Field | Meaning |
|---|---|
| `original` | Original question. |
| `normalized` | Text after Arabic/Latin normalization. |
| `language` | `ar`, `en`, or `mixed`. |
| `tokens` | Normalized terms used by matchers. |
| `flags` | Derived flags: `empty`, `unsupported_candidate`, `write_action_candidate`, `schema_introspection_candidate`. |

### EntitySpan / EntityMap

| Field | Meaning |
|---|---|
| `placeholder` | `@ENTITY_1`, `@ENTITY_2`, … |
| `originalValue` | Exact captured value, never translated. |
| `sourceRange` | Character span in the original question. |
| `detection` | `quoted` \| `heuristic`. |

`EntityMap` is `placeholder → originalValue`. The placeholder-substituted question is what the SLM sees.

### ConceptMatch

| Field | Meaning |
|---|---|
| `conceptId` | Matched catalog concept. |
| `matchedTerms` | Terms that triggered it. |
| `score` | Deterministic match confidence. |
| `ambiguityReason` | Present when the term also matches a `conflictsWith` concept. |

### LookupMatch

| Field | Meaning |
|---|---|
| `lookupId`, `table`, `column` | Approved lookup identity. |
| `value` | Exact value copied from the catalog `LookupSet`. |
| `reachedVia` | Relationship id. |
| `inputTerms`, `matchType` (`exact`/`normalized`/`fuzzy_safe`), `score` | Match evidence. |

Rule: `LookupMatch.value` is always copied from an approved `LookupSet`; invented values and raw lookup IDs are not valid lookup matches.

### Candidate

Typed, grounded option with a stable ID (see `contracts/candidate_menu_contract.md`).

| Field | Meaning |
|---|---|
| `id` | `C#/F#/E#/R#/A#/S#/G#`. |
| `type` | `selected_field \| lookup_filter \| entity_filter \| relationship \| aggregation \| sort \| group_by`. |
| `payload` | Grounded fields for the type (table, column, operator, value/placeholder, function, alias, relationshipId, order). |
| `description` | Human-readable menu line. |
| `score` | Ranking score. |
| `conceptId` | Source concept, when applicable. |

Invariant: every candidate references only catalog-validated tables/columns/relationships/values at construction time (grounded-by-construction).

### CandidateMenu

| Field | Meaning |
|---|---|
| `questionForModel` | Placeholder-substituted question. |
| `candidates[]` | Rendered candidates. |
| `relationshipAliases` | Local aliases (`R1`, `R_OUTPUTS`). |
| `offeredIntents[]` | Allowed intents. |
| `renderedText` | Compact text block sent to the SLM. |
| `estimatedTokens` | Prompt budget estimate. |

### SlmSelection

Parsed SLM output — candidate IDs only.

| Field | Meaning |
|---|---|
| `intent` | Classified intent. |
| `selectedFieldIds`, `filterIds`, `relationshipIds`, `aggregationIds`, `groupByIds`, `sortIds` | Referenced candidate IDs. |
| `limit` | Optional. |
| `needsClarification` | Model-signaled clarification. |
| `rawText` | Raw model output (for evidence). |
| `modelConfidence` | Informational only. |
| `strayContent` | Any free-form schema text the model emitted (flagged, never used). |

### ValidationResult

| Field | Meaning |
|---|---|
| `valid` | Whether the selection assembles to a fully grounded result. |
| `errors[]` | `ValidationError { code, reference, message }`. |
| `warnings[]` | Non-blocking notes. |
| `fullyGrounded` | Mirrors `grounding.fully_grounded`. |

Validation error codes (see `final_intent_json_contract.md`): `empty_table`, `empty_column`, `unknown_table`, `unknown_column`, `missing_relationship`, `invalid_lookup_value`, `invented_lookup_value`, `raw_lookup_id`, `operator_type_mismatch`, `entity_value_modified`, `aggregation_unrelated_table`, `ungrounded_sort_or_group`, `sql_fragment`, `invented_reference`, `candidate_not_found`, `ambiguous_concept`, `unsupported_request`, `parse_error`.

### FinalIntentJson

The output contract. See `contracts/final_intent_json_contract.md`.

### GroundingEvidence

| Field | Meaning |
|---|---|
| `normalization` | Normalized question + language. |
| `entityMap` | Placeholder → original value. |
| `conceptMatches`, `lookupMatches` | Deterministic matches. |
| `candidates` | Retrieved candidate menu. |
| `selection` | SLM selection. |
| `sourceMap` | Each final field → originating candidate. |
| `decision` | `assembled_ok \| needs_clarification \| unsupported \| invalid`. |

### GoldenQuestionResult

| Field | Meaning |
|---|---|
| `questionId` | e.g. `G01`. |
| `expected` | Expected status + grounded fields. |
| `actual` | FinalIntentJson. |
| `pass` | All acceptance checks passed. |
| `failureReasons` | Mismatches. |
| `latencyMs` | End-to-end latency. |

## Entity Relationships

```text
GroundedIntentRequest
  → NormalizedQuestion
  → EntityMap
  → SchemaCatalog → SchemaGraph
  → ConceptMatch[] + LookupMatch[]
  → Candidate[] → CandidateMenu
  → SlmSelection
  → ValidationResult
  → FinalIntentJson + GroundingEvidence

GoldenQuestionItem
  → GroundedIntentRequest
  → GoldenQuestionResult
  → Scorecard
```

## Critical Invariants

- Every schema reference in the output traces to a catalog-validated candidate (grounded-by-construction).
- The SLM contributes intent + candidate IDs only; it never supplies table/column/relationship/lookup/id/entity strings.
- Entity values in `entities` and in entity filters equal the exact original captured span; translation or modification is invalid.
- Lookup filter values are copied from approved `LookupSet`s; raw FK IDs are never accepted.
- Aggregations target only tables related to the root via a declared (usually incoming) relationship.
- `RiskLevels` and `PeriortyLevels` are separate concepts with `conflicts_with`; ambiguous terms trigger clarification.
- `Projects → PeriortyLevels` is required for priority filters; `Projects → RiskLevels` for risk filters; `Projects.Id → ProjectOutPutModels.ProjectId` for output aggregation.
- Empty table/column references are never final-valid.
- `status="ok"` ⇔ `grounding.fully_grounded=true` with zero validation errors.
- The catalog and graph are offline; loading performs no network/backend/MCP call.
