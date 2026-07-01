# Feature Specification: Hybrid Grounded Intent Pipeline for Local AI Assistant

**Feature Branch**: `003-hybrid-grounded-intent`

**Created**: 2026-07-01

**Status**: Draft

**Input**: User description: "Update/start the production design for the Hybrid Grounded Intent Pipeline, focusing on the Spec and the local Schema Catalog. Do not depend on backend for this phase. Build a local Flutter-side grounded intent pipeline using local schema metadata, an enriched Schema Catalog, a SchemaGraph, candidate retrieval, a candidate menu, SLM candidate selection, deterministic validation, and deterministic assembly of a Final Intent JSON. The SLM currently produces valid JSON shape but fails schema grounding: it invents or empties table/column/relationship references, translates exact Arabic entity values, and confuses risk with priority. Root cause: the SLM must not freely generate table names, column names, FK relationships, lookup values, IDs, or exact entity values; it must only classify intent and select from deterministic candidate IDs. The design must be generic and SchemaGraph-driven, not a hardcoded mapper. Preserve hard boundaries: no SQL generation, DB connection, data retrieval, backend query execution, MCP, production answer-from-data, and no change to existing 001 free-text local chat behavior."

## Why This Feature Exists

The on-device SLM (`flutter_gemma` / Qwen2.5 1.5B) already returns syntactically valid JSON, but the JSON is **not schema-grounded** and therefore **not safe to turn into a database query later**. Four recorded failure classes prove the problem:

1. **Empty/invented schema references** — `give me low priorities projects` returns `table=""`, `column=""`, `operator="lt"`, `value="أولوية منخفضة"`, `relationships=[]`. The expected grounded result is a filter `PeriortyLevels.Name eq "أولوية منخفضة"` reached through the relationship `Projects.PeriortyLevelId → PeriortyLevels.Id`.
2. **Entity translation and wrong intent** — `what is the budget of أتمتة العقود والقوانين` returns `intent=list_records`, empty `selected_fields`, `table=""`, `column=Name`, and the Arabic entity **translated** to `"automation of contracts and laws"`. The expected result is `intent=get_record_detail`, `selected_fields=[Projects.Budget]`, filter `Projects.Name eq "أتمتة العقود والقوانين"` (exact original Arabic).
3. **Fabricated aggregation path** — `اكثر المشاريع تقدما من حيث المخرجات` returns a filter on `EndDate gt today()`. The expected result is an output-count aggregation over the real child table through a reverse foreign key: `Projects.Id → ProjectOutPutModels.ProjectId`, `count(ProjectOutPutModels.Id) as output_count`, sorted `output_count desc`.
4. **Concept confusion / dropped grounding** — for `مخاطر عالية` the SLM sometimes copies the value correctly but leaves table/column/relationships empty, and sometimes confuses risk with priority.

**Root cause**: the SLM is being asked to do a job it cannot do reliably — freely producing table names, column names, foreign-key relationships, lookup values, identifiers, and exact entity strings. Those are deterministic schema facts, not language-model guesses.

**Solution shape**: make the SLM a **classifier and selector only**. Deterministic Flutter-side code builds a local **Schema Catalog**, derives a **SchemaGraph**, retrieves a bounded set of **candidates** (fields, filters, relationships, aggregations, sorts), and renders a compact **candidate menu**. The SLM classifies the intent and **selects candidate IDs**. Deterministic code then **validates** the selection and **assembles** the Final Intent JSON. Exact entity values are protected with placeholders so the SLM can never rewrite them.

This feature delivers the **local foundation only**: catalog, graph, retrieval, menu, selection, validation, assembly, and a Final Intent JSON contract. It does **not** generate SQL, connect to a database, retrieve data, call MCP, or touch the existing free-text chat.

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Ground a lookup-value question through a foreign key (Priority: P1)

An evaluator asks a projects question whose meaning depends on a reference/lookup value (priority, risk, department, category, lifecycle). The pipeline resolves the value against approved catalog lookups and reaches it through the correct foreign-key relationship, without emptying or inventing schema references.

**Why this priority**: This is the most common failure class (examples 1 and 4). It exercises catalog lookups, the outgoing-FK relationship path, and deterministic assembly end to end.

**Independent Test**: Run `give me low priorities projects` and `مشاريع عالية الخطورة` through grounded intent mode and verify the Final Intent JSON filters `PeriortyLevels.Name eq "أولوية منخفضة"` / `RiskLevels.Name eq "مخاطر عالية"` with the matching `Projects → PeriortyLevels` / `Projects → RiskLevels` relationship, and never uses the other concept.

**Acceptance Scenarios**:

1. **Given** the catalog contains the priority lookup and the `Projects.PeriortyLevelId → PeriortyLevels.Id` relationship, **When** the evaluator asks `give me low priorities projects`, **Then** the Final Intent JSON has `root_table=Projects`, a filter `PeriortyLevels.Name eq "أولوية منخفضة"`, the relationship `Projects → PeriortyLevels`, and `grounding.fully_grounded=true`.
2. **Given** the catalog contains the risk lookup and `Projects.RiskLevelId → RiskLevels.Id`, **When** the evaluator asks `مشاريع عالية الخطورة`, **Then** the filter is `RiskLevels.Name eq "مخاطر عالية"` via `Projects → RiskLevels`, and no priority field appears.
3. **Given** the SLM selection references a candidate that does not exist in the rendered menu, **When** validation runs, **Then** the result is not `ok`; it is rejected with a validation error and no schema names are fabricated.

---

### User Story 2 - Preserve an exact entity value and select the right field (Priority: P1)

An evaluator asks for a specific attribute of a named entity (for example the budget of a project named in Arabic). The exact entity string is preserved verbatim, the correct detail intent and selected field are chosen, and the entity is never translated or rewritten.

**Why this priority**: This is failure example 2 — the SLM translated the Arabic entity and picked the wrong intent/field. Entity preservation and field selection are core to any detail question.

**Independent Test**: Run `what is the budget of أتمتة العقود والقوانين` and verify `intent=get_record_detail`, `selected_fields=[Projects.Budget]`, filter `Projects.Name eq "أتمتة العقود والقوانين"` with the exact original Arabic, and `entities` containing the untranslated placeholder mapping.

**Acceptance Scenarios**:

1. **Given** the entity extractor replaces the project name with `@ENTITY_1` before the SLM call, **When** the SLM produces its selection, **Then** the assembled filter value equals the original Arabic string byte-for-byte and `entities["@ENTITY_1"]` holds that same string.
2. **Given** the question asks for a single attribute of one named record, **When** intent is classified, **Then** `intent=get_record_detail` and `selected_fields` contains `Projects.Budget` from the candidate menu, not an invented column.
3. **Given** the SLM output contains a translated or modified entity value, **When** validation compares it to the entity map, **Then** the result is rejected with an `entity_value_modified` error.

---

### User Story 3 - Aggregate over a child table through a reverse foreign key (Priority: P1)

An evaluator asks a "most/least/how many per project" question that requires counting or summing rows in a related child table. The pipeline builds the aggregation over the real child table through the reverse (incoming) foreign-key path and sorts by the aggregated value.

**Why this priority**: This is failure example 3 — the SLM fabricated an unrelated date filter. Reverse-FK aggregation is required for the "outputs / deliverables / المخرجات" class and proves the SchemaGraph handles incoming relationships, not just outgoing ones.

**Independent Test**: Run `اكثر المشاريع تقدما من حيث المخرجات` and verify the Final Intent JSON contains an aggregation `count(ProjectOutPutModels.Id) as output_count` reached through `Projects.Id → ProjectOutPutModels.ProjectId`, with `sort=[output_count desc]` and no fabricated `EndDate` filter.

**Acceptance Scenarios**:

1. **Given** the catalog exposes the reverse relationship `Projects.Id → ProjectOutPutModels.ProjectId` and an aggregatable child key, **When** the evaluator asks for the projects with the most outputs, **Then** the aggregation is `count(ProjectOutPutModels.Id) as output_count` via that reverse path.
2. **Given** the question implies ranking, **When** the intent is classified, **Then** `sort` contains `output_count desc` and `intent` reflects an aggregation/ranking intent.
3. **Given** the SLM selects an aggregation candidate whose child table is not related to the root table, **When** validation runs, **Then** the result is rejected with an `aggregation_unrelated_table` error.

---

### User Story 4 - Keep free-text chat unchanged (Priority: P1)

Users continue to use the existing offline free-text local chat with no behavior change, unless a caller explicitly routes a question into grounded intent mode.

**Why this priority**: The 001 local assistant is shipped value and must remain stable. Grounded intent is an additive, opt-in mode.

**Independent Test**: Run the existing free-text chat flow with grounded intent mode not selected and confirm unchanged behavior; separately route a question into grounded intent mode and confirm it returns Final Intent JSON instead of prose.

**Acceptance Scenarios**:

1. **Given** grounded intent mode is not selected, **When** a user sends a normal chat message, **Then** the existing free-text local chat behavior is preserved unchanged.
2. **Given** grounded intent mode is explicitly selected, **When** a projects question is submitted, **Then** the pipeline returns Final Intent JSON, not a prose answer.
3. **Given** a Final Intent JSON is produced, **When** it is shown or logged in development tooling, **Then** it is not used to query a database or produce real data answers in this phase.

---

### User Story 5 - Reject or clarify ungrounded, ambiguous, or unsupported questions (Priority: P2)

When a question cannot be safely grounded — ambiguous concept, missing lookup value, unrelated request, or prohibited write/introspection — the pipeline produces a structured `needs_clarification`, `unsupported`, or `invalid` result instead of forcing an answer, and `grounding.fully_grounded` is false.

**Why this priority**: Safe refusal is required for a local assistant that has no database access and must never fabricate schema meaning.

**Independent Test**: Run ambiguous (risk vs priority), missing-lookup, unsupported (weather/salary/delete/SQL/schema-introspection), and empty-candidate questions and verify the correct non-`ok` status with clear validation errors and `fully_grounded=false`.

**Acceptance Scenarios**:

1. **Given** a term maps to more than one concept (for example `المهمة` → risk or priority), **When** retrieval produces conflicting high-score candidates, **Then** the status is `needs_clarification` with both options and no arbitrary choice.
2. **Given** the user requests a lookup value not present in the approved catalog, **When** the lookup matcher fails, **Then** the status is `needs_clarification` or `invalid` and no value is invented.
3. **Given** the user asks for weather, poetry, salaries, deletion, SQL, or schema introspection, **When** the question is processed, **Then** the status is `unsupported` with a reason and `fully_grounded=false`.

---

### User Story 6 - Measure production readiness with golden questions (Priority: P2)

An evaluator runs the golden question set through grounded intent mode and receives a scorecard proving whether the pipeline grounds the known failure classes and generalizes across catalog-reachable data.

**Why this priority**: The purpose is a measured production decision with regression protection, not a demo.

**Independent Test**: Run the golden set and verify the scorecard reports selection validity, grounding accuracy, relationship accuracy, entity-preservation rate, invented-reference rate, clarification/unsupported correctness, free-text regression status, and latency.

**Acceptance Scenarios**:

1. **Given** the golden set covers lookup filters, entity detail, reverse-FK aggregation, ambiguity, and unsupported categories, **When** the pipeline is evaluated, **Then** every item records an expected-vs-actual Final Intent JSON.
2. **Given** the four known failure classes are included, **When** the scorecard is produced, **Then** all four produce fully grounded expected output (or correct refusal), and the entity-modification rate and invented-reference rate are 0%.

### Edge Cases

- The SLM returns valid JSON that selects a non-existent candidate ID.
- The SLM returns high raw confidence while the selection is wrong.
- The SLM copies or translates an exact entity value instead of using the placeholder.
- Arabic wording has orthographic variation, tashkeel, or alef/hamza/ya variants.
- A term (`important`, `critical`, `المهمة`, `الهامة`) is ambiguous between risk and priority.
- A requested lookup value is not in the approved catalog list.
- The catalog contains similarly named concepts (risk, priority, status-like tables, lifecycle).
- No relationship path exists between the root table and a candidate table.
- An aggregation targets a table unrelated to the root table.
- The question requires a depth-2/depth-N relationship path.
- The catalog asset is missing, stale, malformed, or lacks required lookup values.
- The question maps to a denylisted/private/unsafe field (for example identity/security tables).
- Grounded intent mode is disabled or not explicitly selected.

## Requirements *(mandatory)*

### Functional Requirements

#### Mode and boundaries

- **FR-001**: The system MUST provide a grounded intent mode that is separate from and additive to the existing free-text chat mode.
- **FR-002**: The existing free-text local chat MUST remain unaffected unless a caller explicitly routes a question to grounded intent mode.
- **FR-003**: The feature MUST NOT generate SQL, connect to a database, retrieve data, execute backend queries, use MCP, or produce production answers from data in this phase.
- **FR-004**: The feature MUST NOT depend on any backend catalog API; the Schema Catalog MUST be local/offline.
- **FR-005**: The feature MUST NOT mark or imply that the earlier M0 gate is passed, and MUST NOT edit feature 002 `research.md`.

#### Local Schema Catalog

- **FR-006**: The system MUST maintain a versioned local Schema Catalog asset (proposed `assets/ai/schema/schema_catalog.json`) derived from the existing local schema metadata asset and local enrichment, carrying `catalog_version` and `source_schema_version`.
- **FR-007**: The catalog MUST be schema-driven (tables, columns, data types, primary keys, foreign keys) AND enriched with business metadata (concept tags, Arabic/English synonyms, lookup values, searchable/entity fields, aggregatable/sortable/filterable/safe fields, and unsupported/private exclusions).
- **FR-008**: The catalog MUST record outgoing foreign-key relationships, incoming/reverse foreign-key relationships, and relationship paths. In v1 the generator derives depth-1 paths; the path structure supports configured depth-2/depth-N paths, whose derivation is future scope.
- **FR-009**: The catalog MUST list approved lookup/reference values per lookup column so that lookup filters can only use approved values.
- **FR-010**: The catalog MUST mark unsupported/private/denylisted fields and tables as excluded so they are never offered as candidates.
- **FR-011**: The catalog design MUST be generic and root-table-driven; it MUST NOT hardcode the current example concepts (risk, priority, manager, budget, output count) as special cases.

#### SchemaGraph and candidate retrieval

- **FR-012**: The system MUST build an in-memory SchemaGraph from the catalog that supports direct root-table columns, outgoing FK relationships, incoming/reverse FK relationships, and aggregations over related child tables.
- **FR-013**: The system MUST normalize the question (Arabic orthography, tashkeel, alef/hamza/ya variants, Latin casing) and detect language before matching.
- **FR-014**: The system MUST match business vocabulary and lookup values against catalog concept tags, synonyms, and approved lookup values only.
- **FR-015**: The system MUST retrieve a bounded set of typed candidates — selectable fields, filters (including lookup filters through relationships), relationship paths, aggregations, sorts, and group-bys — each with a stable candidate ID.
- **FR-016**: Every candidate MUST be fully grounded by construction: it references only catalog tables, columns, relationships, and approved values that the deterministic layer already validated.

#### Entity handling

- **FR-017**: The system MUST extract exact entity spans (quoted or detected) and replace them with placeholders (`@ENTITY_1`, `@ENTITY_2`, …) before the SLM call, keeping an entity map from placeholder to the exact original value.
- **FR-018**: The SLM MUST NOT translate, rewrite, or normalize entity values; the Final Intent JSON MUST use the exact original entity value from the entity map.
- **FR-019**: Entity-based filters MUST target catalog-designated searchable/entity fields of the root table (for example `Projects.Name`).

#### Candidate menu and SLM selection

- **FR-020**: The system MUST render a compact candidate menu listing candidate IDs with human-readable descriptions (for example `F1 = PeriortyLevels.Name eq "أولوية منخفضة" via R1`).
- **FR-021**: The SLM MUST receive the menu and the placeholder-substituted question and MUST output a selection that references candidate IDs only, plus an intent classification and a clarification flag.
- **FR-022**: The SLM output MUST NOT contain free-form table names, column names, relationship definitions, lookup values, IDs, or entity strings; any such content MUST be ignored or rejected by validation.

#### Validation and assembly

- **FR-023**: The deterministic validator MUST reject or block final execution when any of the following hold: table empty, column empty, table not in catalog, column not in table, relationship path does not exist, lookup value not in catalog, operator incompatible with column type, entity value translated or modified, aggregation uses an unrelated table, sort/group field not grounded, raw SQL present anywhere, model invented a table/column/value/id, or a referenced candidate ID does not exist.
- **FR-024**: The deterministic assembler MUST expand the validated candidate IDs into the Final Intent JSON, filling `status`, `language`, `intent`, `root_table`, `selected_fields`, `filters`, `relationships`, `aggregations`, `group_by`, `sort`, `limit`, `entities`, grounding metadata, `validation_errors`, and clarification fields.
- **FR-025**: The Final Intent JSON MUST set `grounding.fully_grounded=true` only when every emitted reference is catalog-validated and every entity value is unmodified; otherwise it MUST be false.
- **FR-026**: The Final Intent JSON MUST be `status="ok"` only when it is fully grounded and free of validation errors; ambiguous, missing-lookup, unsupported, or invented cases MUST use `needs_clarification`, `unsupported`, or `invalid`.
- **FR-027**: The confidence exposed to evaluators MUST be derived from deterministic grounding and validation, not from the SLM's raw confidence alone.

#### Evaluation

- **FR-028**: The feature MUST include a golden-question evaluation set derived from the existing M0 golden questions and device-run evidence, extended with the four failure classes described above.
- **FR-029**: The feature MUST produce a scorecard covering selection validity, grounding accuracy, relationship accuracy, entity-preservation rate, invented-reference rate, clarification correctness, unsupported correctness, and latency.
- **FR-030**: The feature MUST provide development/evaluation evidence explaining, for each final field, which catalog candidate produced it and whether the result was assembled, clarified, rejected, or marked unsupported.

### Key Entities *(include if feature involves data)*

- **Schema Catalog**: The versioned local asset that carries schema-derived structure plus business enrichment (concepts, synonyms, lookups, field roles, exclusions).
- **SchemaGraph**: The in-memory graph built from the catalog, exposing direct columns, outgoing FKs, incoming/reverse FKs, relationship paths, and aggregation targets.
- **Normalized Question**: The question after language detection and text normalization.
- **Entity Span / Entity Map**: An extracted exact value, its placeholder (`@ENTITY_n`), and the placeholder→value mapping preserved unchanged.
- **Candidate**: A typed, fully grounded option (selectable field, filter, relationship, aggregation, sort, group-by) with a stable ID and human-readable description.
- **Candidate Menu**: The compact rendered list of candidate IDs given to the SLM.
- **SLM Selection**: The SLM output referencing candidate IDs plus an intent classification and clarification flag — never raw schema names.
- **Validation Result**: The deterministic pass/fail decision with specific error codes.
- **Final Intent JSON**: The assembled, validated structured result (see `contracts/final_intent_json_contract.md`).
- **Grounding Metadata**: The trace showing which candidate produced each field and whether the whole result is fully grounded.
- **Golden Question Item**: A question, expected Final Intent JSON, category, and acceptance checks used for the scorecard.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: The lookup-through-FK questions (`give me low priorities projects`, `مشاريع عالية الخطورة`) produce the expected lookup filter and relationship, with no empty or opposite-concept references, in 100% of evaluation runs.
- **SC-002**: The entity-detail question (`what is the budget of أتمتة العقود والقوانين`) produces `get_record_detail`, `selected_fields=[Projects.Budget]`, and a `Projects.Name` filter equal to the exact original Arabic in 100% of evaluation runs.
- **SC-003**: The reverse-FK aggregation question (`اكثر المشاريع تقدما من حيث المخرجات`) produces `count(ProjectOutPutModels.Id) as output_count` via the reverse path and `output_count desc` sort, with no fabricated date filter, in 100% of evaluation runs.
- **SC-004**: Across the golden set, the entity-value modification rate is 0% (no translated or rewritten entities).
- **SC-005**: Across the golden set, the invented-reference rate (table/column/relationship/lookup/id not in the catalog) is 0%.
- **SC-006**: Across the golden set, at least 95% of supported questions produce Final Intent JSON with `fully_grounded=true` and no validation errors.
- **SC-007**: Across questions requiring relationships or aggregations, at least 95% of outputs contain the expected relationship or reverse-FK aggregation path.
- **SC-008**: Across ambiguous, missing-lookup, and unsupported questions, at least 90% produce the expected `needs_clarification` / `unsupported` / `invalid` status.
- **SC-009**: Existing free-text chat regression checks pass with grounded intent mode disabled.
- **SC-010**: Inspection confirms no SQL generation, DB connection, data retrieval, backend query execution, MCP, backend catalog dependency, or production answer-from-data path is introduced.
- **SC-011**: The design is generic: adding a new catalog-reachable concept (a new lookup table, reverse-FK child, or column) requires only catalog/enrichment data, with no per-concept code branch.

## Assumptions

- The existing projects schema metadata asset (`systems/project_management/assets/ai/schema/projects_db_metadata_schema.json`, `schema_version 0.1.0`, root table `Projects`) is the source of truth from which the local Schema Catalog is generated and enriched.
- The current local SLM remains useful for intent classification and candidate selection but is not trusted to produce schema names, relationships, lookup values, IDs, or exact entity strings.
- The first production scope is the projects domain with `Projects` as the single root table; multi-root/multi-domain routing is future work.
- The misspelled exported field name `PeriortyLevelId` / table `PeriortyLevels` is treated as the real schema spelling for priority and must remain distinct from risk.
- The Final Intent JSON is a design contract for a later backend SQL Generator; that generator is out of scope until the DB retrieval phase and will consume only `status="ok"` with `grounding.fully_grounded=true`.
- Golden questions from the M0 probe plus the four failure classes are acceptable as the first regression suite; a held-out set is added before release.
- `Projects.OutputCount` may exist as a denormalized column, but the aggregation example is deliberately grounded through the reverse FK to prove incoming-relationship aggregation; the catalog MAY offer either path as candidates.
