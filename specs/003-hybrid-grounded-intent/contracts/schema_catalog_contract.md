# Contract: Local Schema Catalog

**Feature**: `003-hybrid-grounded-intent`

This contract defines the versioned, **local/offline** Schema Catalog asset that grounds the pipeline. Proposed location: `assets/ai/schema/schema_catalog.json` (bundled under `systems/project_management/assets/ai/schema/`). The catalog is generated from the existing raw schema metadata plus local enrichment; it is not fetched from any backend in this phase.

## Purpose

Raw DB schema metadata tells us structure (tables, columns, types, PKs, FKs). It does **not** tell us business meaning. The catalog is schema-driven **and** business-enriched so that deterministic retrieval can map natural-language terms to grounded schema references and approved values.

| Raw schema knows | Enrichment adds |
|---|---|
| `Projects.PeriortyLevelId → PeriortyLevels.Id` | "low priority / أولوية منخفضة" → `PeriortyLevels.Name = "أولوية منخفضة"` |
| `Projects.Budget` is a `bigint` column | "budget / cost / ميزانية / تكلفة" → `Projects.Budget` |
| `ProjectOutPutModels.ProjectId → Projects.Id` | "outputs / deliverables / المخرجات" → `count(ProjectOutPutModels.Id)` |

## Generation

```text
projects_db_metadata_schema.json  (existing raw metadata: tables, columns, types, PKs, FKs, lookup_values, exclusions)
        +
schema_enrichment.json            (local: concept tags, ar/en synonyms, field roles, exclusions)
        ↓  generator (build-time or committed script; runs during implementation)
schema_catalog.json               (versioned catalog consumed by the app)
```

The generator also **derives**: incoming/reverse relationships and depth-1 relationship paths from the FK edge set (v1 scope; multi-hop depth-N derivation is future — see RelationshipPath below). Retrieval reads only `schema_catalog.json`.

## Top-Level Shape

```json
{
  "catalog_version": "0.1.0",
  "source_schema_version": "0.1.0",
  "source_metadata_reference": "assets/ai/schema/projects_db_metadata_schema.json",
  "generated_at": "2026-07-01T00:00:00Z",
  "lookup_value_cap": 50,
  "root_tables": ["Projects"],
  "tables": [ /* CatalogTable[] */ ],
  "relationships": {
    "outgoing": [ /* Relationship[] */ ],
    "incoming": [ /* Relationship[] */ ],
    "paths": [ /* RelationshipPath[] */ ]
  },
  "relationship_edges": [ /* Relationship[] — flat outgoing+incoming convenience list */ ],
  "lookups": [ /* LookupSet[] */ ],
  "concepts": [ /* Concept[] */ ],
  "aggregation_candidates": [ /* AggregationCandidate[] — derived from concept aggregation targets */ ],
  "exclusions": {
    "tables": ["AspNetUserClaims", "AppTokens"],
    "columns": ["Projects.CreatedBy", "Projects.IsDeleted"],
    "reasons": { "AspNetUserClaims": "identity_security", "AppTokens": "denylist" }
  }
}
```

**Additive fields** (emitted by the generator, additive to the base contract):

- `source_metadata_reference` — relative path of the raw metadata the catalog was generated from.
- `lookup_value_cap` — max approved values retained per lookup column (see rule 9).
- `relationship_edges` — a flat concatenation of `relationships.outgoing` + `relationships.incoming` for consumers that want a single edge list.
- `aggregation_candidates` — pre-derived aggregation candidates (see AggregationCandidate below).

### CatalogTable

```json
{
  "name": "Projects",
  "schema": "dbo",
  "is_root": true,
  "primary_key": "Id",
  "columns": [
    {
      "name": "Budget",
      "data_type": "bigint",
      "is_primary_key": false,
      "is_foreign_key": false,
      "roles": ["safe", "selectable", "aggregatable", "sortable", "filterable"],
      "concept_tags": ["budget"],
      "synonyms": { "ar": ["ميزانية", "تكلفة"], "en": ["budget", "cost"] }
    },
    {
      "name": "Name",
      "data_type": "nvarchar",
      "roles": ["safe", "selectable", "searchable", "entity", "filterable"],
      "concept_tags": ["project_name"],
      "synonyms": { "ar": ["اسم", "المشروع"], "en": ["name", "project"] }
    },
    {
      "name": "PeriortyLevelId",
      "data_type": "int",
      "is_foreign_key": true,
      "references": { "table": "PeriortyLevels", "column": "Id" },
      "roles": ["filterable"],
      "concept_tags": ["priority"],
      "synonyms": { "ar": ["أولوية", "الأولوية"], "en": ["priority"] }
    }
  ]
}
```

**Column roles** (a column may hold several):

- `safe` — approved for use; absence excludes the column from all candidates.
- `selectable` — may appear in `selected_fields`.
- `searchable` — usable for text/entity matching on the root table.
- `entity` — a canonical entity-name field (for example `Projects.Name`).
- `aggregatable` — may be aggregated (`count`/`sum`/`avg`/`min`/`max`).
- `sortable` — may appear in `sort`.
- `filterable` — may appear in `filters`.

Any column not marked `safe` (or listed in `exclusions`) MUST NOT be offered as a candidate.

**Additive column fields** emitted by the generator: `nullable` (bool), `depth` (int, FK distance from the root as recorded in the source metadata), and `exposure` — a derived summary of the column's availability:

- `safe` — the column has the `safe` role and is offered as a candidate.
- `private` — the column has no `safe` role; `roles`/`concept_tags`/`synonyms` are emitted empty.
- `excluded` — the column is listed in `exclusions.columns`; `roles`/`concept_tags`/`synonyms` are emptied and an `exclusion_reason` is attached.

`CatalogTable` additionally carries a `depth` field and emits `primary_key` as a list of column names.

### Relationship (outgoing and incoming)

```json
{
  "id": "R_PROJECTS_PRIORITY",
  "direction": "outgoing",
  "from_table": "Projects",
  "from_column": "PeriortyLevelId",
  "to_table": "PeriortyLevels",
  "to_column": "Id",
  "fk_name": "FK_Projects_PeriortyLevels_PeriortyLevelId"
}
```

An **incoming/reverse** relationship is the same shape with `"direction": "incoming"`, for example:

```json
{
  "id": "R_PROJECTS_OUTPUTS",
  "direction": "incoming",
  "from_table": "Projects",
  "from_column": "Id",
  "to_table": "ProjectOutPutModels",
  "to_column": "ProjectId",
  "fk_name": "FK_ProjectOutPutModels_Projects_ProjectId"
}
```

Reverse relationships are what make child-table aggregations (output counts) possible.

### RelationshipPath

The `hops` list supports depth-N. A multi-hop example:

```json
{
  "id": "P_PROJECTS_MANAGER_DEPT",
  "from_table": "Projects",
  "to_table": "DepartmentLookups",
  "hops": [
    { "relationship_id": "R_PROJECTS_MANAGER" },
    { "relationship_id": "R_USER_DEPARTMENT" }
  ]
}
```

**v1 scope**: the generator derives only **depth-1** paths — one `paths[]` entry per root-sourced relationship (a single hop), for both outgoing and incoming edges:

```json
{
  "id": "P_PROJECTS_PERIORTYLEVELS",
  "from_table": "Projects",
  "to_table": "PeriortyLevels",
  "hops": [ { "relationship_id": "R_PROJECTS_PERIORTYLEVELID_PERIORTYLEVELS" } ]
}
```

Multi-hop (depth-2/depth-N) path derivation is deferred (see `plan.md` boundaries and `migration-plan.md` hardening gaps). Only configured/derived paths are valid; retrieval MUST NOT invent multi-hop paths that are not present here.

### LookupSet

Approved reference values for a lookup column. Values are copied verbatim from the raw metadata.

```json
{
  "id": "LK_PERIORTYLEVELS_NAME",
  "table": "PeriortyLevels",
  "column": "Name",
  "reached_via": "R_PROJECTS_PERIORTYLEVELID_PERIORTYLEVELS",
  "values": ["أولوية عالية", "أولوية متوسطة", "أولوية منخفضة"]
}
```

```json
{
  "id": "LK_RISKLEVELS_NAME",
  "table": "RiskLevels",
  "column": "Name",
  "reached_via": "R_PROJECTS_RISKLEVELID_RISKLEVELS",
  "values": ["مخاطر عالية", "مخاطر متوسطة", "مخاطر منخفضة"]
}
```

`reached_via` MUST be a relationship that is **root-sourced and targets the lookup table** — i.e. `from_table ∈ root_tables` and `to_table = LookupSet.table` (outgoing root→lookup or incoming root→child). When no depth-1 root-connected relationship exists (the lookup table is only reachable via a multi-hop path not yet derived in v1), `reached_via` MUST be `null` rather than an unrelated edge. Lookup filters MUST use a value from an approved `LookupSet`; invented values and raw FK IDs are invalid.

### Concept

A business concept binds synonyms to one or more grounded **targets** and disambiguates near-neighbors. A concept carries a `targets` **array** (not a single `target`) because one concept can ground to several shapes — for example `concept_outputs` grounds to both a direct column and a child-table aggregation.

Each target has a `type` (`column` | `lookup_filter` | `aggregation`) plus type-specific fields. The generator resolves the enrichment's endpoint description into a `relationship_id` (and, for `lookup_filter`, a `lookup_id`).

```json
{
  "id": "concept_priority",
  "labels": { "ar": "الأولوية", "en": "Priority" },
  "synonyms": { "ar": ["أولوية", "الأولوية"], "en": ["priority", "low priorities"] },
  "targets": [
    {
      "type": "lookup_filter",
      "lookup_table": "PeriortyLevels",
      "lookup_column": "Name",
      "lookup_id": "LK_PERIORTYLEVELS_NAME",
      "relationship_id": "R_PROJECTS_PERIORTYLEVELID_PERIORTYLEVELS"
    }
  ],
  "conflicts_with": ["concept_risk"],
  "capabilities": ["filterable", "sortable", "selectable"]
}
```

```json
{
  "id": "concept_outputs",
  "labels": { "ar": "المخرجات", "en": "Outputs / deliverables" },
  "synonyms": { "ar": ["المخرجات", "مخرجات"], "en": ["outputs", "deliverables"] },
  "targets": [
    { "type": "column", "table": "Projects", "column": "OutputCount" },
    {
      "type": "aggregation",
      "function": "count",
      "table": "ProjectOutPutModels",
      "column": "Id",
      "alias": "output_count",
      "relationship_id": "R_PROJECTS_ID_PROJECTOUTPUTMODELS"
    }
  ],
  "capabilities": ["selectable", "sortable", "aggregatable"]
}
```

`conflicts_with` drives ambiguity detection (risk vs priority) so the pipeline can request clarification instead of guessing. `capabilities` is the union of what the concept's targets support.

### AggregationCandidate

Every `aggregation` target across all concepts is also flattened into the top-level `aggregation_candidates` list for direct consumption by candidate retrieval:

```json
{
  "id": "AGG_CONCEPT_OUTPUTS_OUTPUT_COUNT",
  "concept_id": "concept_outputs",
  "function": "count",
  "table": "ProjectOutPutModels",
  "column": "Id",
  "alias": "output_count",
  "relationship_id": "R_PROJECTS_ID_PROJECTOUTPUTMODELS",
  "description": "count(ProjectOutPutModels.Id) as output_count"
}
```

`relationship_id` MUST reference an existing (usually incoming) relationship connecting the root table to the aggregated child table.

## Rules

1. `catalog_version` and `source_schema_version` MUST be present; the loader MUST reject a catalog whose `source_schema_version` does not match the loaded raw schema.
2. Every relationship endpoint MUST reference tables/columns that exist in `tables`.
3. Every non-null `LookupSet.reached_via`, every `Concept.targets[].relationship_id`, and every `aggregation_candidates[].relationship_id` MUST reference an existing relationship id. A `LookupSet.reached_via` MUST additionally be root-sourced and target the lookup table, or be `null`.
4. Every `Concept.targets[].lookup_id` MUST reference an existing `LookupSet` id, and every relationship path hop MUST reference an existing relationship id.
5. Values in a `LookupSet` MUST be copied verbatim from the source metadata; the generator MUST NOT translate or normalize them (it MAY cap the count at `lookup_value_cap` and drop raw-SQL-looking values).
6. Any table/column in `exclusions` MUST NOT appear as a candidate target anywhere; excluded columns are emitted with empty `roles`/`concept_tags`/`synonyms` and an `exclusion_reason`.
7. The catalog MUST be generic: concepts, synonyms, lookups, roles, and paths are data; no consumer may special-case a concept by name.
8. The catalog is offline; loading MUST NOT perform any network or backend call.
9. No catalog string field may contain a raw-SQL fragment; the loader's validator rejects the catalog if one is present.

## Genericity Check

Adding a new reachable concept (a new lookup table, a new reverse-FK child, a new selectable/aggregatable column) requires only: (a) marking roles/exclusions and synonyms in enrichment, (b) adding the `Concept`/`LookupSet`/relationship entries, (c) regenerating `schema_catalog.json`. No code branch per concept is permitted (see spec SC-011).
