# Implementation Plan: Hybrid Grounded Intent Pipeline for Local AI Assistant

**Branch**: `003-hybrid-grounded-intent` | **Date**: 2026-07-01 | **Spec**: [spec.md](./spec.md)

**Input**: Feature specification from `specs/003-hybrid-grounded-intent/spec.md`

> This plan defines a production Flutter-side grounded Intent JSON pipeline built on a **local, offline** Schema Catalog. It does not implement code, depend on any backend, update feature 002 `research.md`, mark G-M0 passed, generate SQL, connect to a database, retrieve data, use MCP, or change the existing 001 free-text chat path.

## Summary

Build an explicit, opt-in grounded intent mode beside the existing local free-text assistant. The mode inverts the SLM's responsibility: instead of asking the SLM to produce schema-grounded JSON (which it fails at), deterministic Flutter code produces the schema facts and the SLM only **classifies intent and selects candidate IDs**.

The flow is:

```text
Question
  → normalize question
  → extract exact entity spans → replace with @ENTITY_n placeholders (+ entity map)
  → load local Schema Catalog (offline asset)
  → build SchemaGraph (direct columns, outgoing FKs, incoming/reverse FKs, paths, aggregations)
  → retrieve candidate fields / filters / relationships / aggregations / sorts (each with an ID)
  → render compact candidate menu
  → SLM selects candidate IDs only (+ intent + clarification flag)
  → deterministic validator
  → deterministic assembler
  → Final Validated Intent JSON  (status + grounding.fully_grounded)
  → [later, out of scope] backend SQL Generator
```

### Why raw SLM output is not SQL-ready

The recorded device outputs are valid JSON but ungrounded: empty `table`/`column`, missing relationships, translated Arabic entities, invented lookup values, raw FK IDs (`1`), fabricated date filters, and risk/priority confusion. A downstream SQL generator cannot safely consume any of these because the references do not correspond to real schema objects. Valid JSON shape is necessary but not sufficient; **schema grounding** is the missing property.

### Why the SLM must select candidate IDs instead of generating schema names

Table names, column names, FK relationships, lookup values, identifiers, and exact entity strings are deterministic facts already present in the schema metadata. A 1.5B on-device model has no reliable knowledge of them and will hallucinate or translate. By pre-computing a small set of grounded candidates and asking the SLM to pick IDs, every schema reference in the output is grounded **by construction**; the SLM contributes only the two things it is actually good at — intent classification and choosing among presented options.

## Technical Context

**Language/Version**: Dart / Flutter in `systems/project_management`, Dart SDK `>=3.8.0 <4.0.0`.

**Primary Dependencies**: Existing `flutter_gemma` through the existing 001 `LocalSlmService`; `get_it` via `projectManagementSl`; `dart:convert` for JSON; Flutter asset bundle for the local catalog. No new DB, SQL, HTTP, MCP, or backend runtime dependency.

**Storage**: Bundled local assets only — the existing schema metadata asset and a new versioned Schema Catalog asset, plus test/golden fixtures. No app database and no persistence beyond existing 001 model state.

**Testing**: `flutter_test` unit/widget tests using fakes for the local SLM selection. Real device runs remain manual evaluation.

**Target Platform**: Android-first, same local AI Assistant environment as 001 and 002.

**Project Type**: Mobile Flutter module in the existing multi-module repository.

**Performance Goals**: Catalog load, graph build, retrieval, validation, and assembly are deterministic and fast; SLM latency remains the dominant cost. The candidate menu must be far smaller than the full exported schema so prompt context stays small.

**Constraints**: No SQL generation, DB connection, DB retrieval, backend query execution, backend catalog API, MCP, production answer-from-data, or free-text chat behavior change. Do not mark G-M0 passed. Do not edit feature 002 `research.md`.

**Scale/Scope**: Projects domain only, single root table (`Projects`) in v1, golden questions from the M0 probe plus the four failure classes as the initial regression set.

## Constitution Check

The constitution remains an unfilled template, so no ratified project-wide gate applies. The feature adopts these self-imposed gates:

- **Mode separation**: grounded intent is opt-in and separate from 001 free-text chat.
- **Grounded-by-construction**: every schema reference in the output originates from a catalog-validated candidate, never from raw SLM text.
- **Entity fidelity**: exact entity values are placeholder-protected and never translated or rewritten.
- **Local-only**: catalog and graph are offline; no backend dependency in this phase.
- **No execution**: Final Intent JSON is not SQL and is not used to retrieve real data.
- **Generic**: behavior is catalog/SchemaGraph-driven, not hardcoded per concept.
- **Evidence-driven**: the four failure classes and the M0 golden set are mandatory regression inputs.
- **M0 isolation**: no edits to feature 002 `research.md`; G-M0 state unchanged.

No violations are planned.

## Project Structure

### Documentation (this feature)

```text
specs/003-hybrid-grounded-intent/
├── spec.md
├── plan.md
├── data-model.md
├── test-strategy.md
├── migration-plan.md
├── tasks.md
├── contracts/
│   ├── schema_catalog_contract.md
│   ├── candidate_menu_contract.md
│   └── final_intent_json_contract.md
└── checklists/
    └── requirements.md
```

### Local asset (proposed, generated in the implementation phase)

```text
systems/project_management/assets/ai/schema/
├── projects_db_metadata_schema.json   # existing raw schema metadata (source)
├── schema_enrichment.json             # new: concept tags, synonyms, field roles, exclusions
└── schema_catalog.json                # new: generated catalog = schema + enrichment (versioned)
```

> The catalog asset is generated during implementation, not in this documentation command. Its structure is fixed by `contracts/schema_catalog_contract.md`.

### Source Code (future implementation)

Additive Flutter layout under `systems/project_management/lib/features/ai_assistant/`:

```text
systems/project_management/lib/features/ai_assistant/
├── local_slm/                                  # existing 001 free-text path, unchanged
├── grounded_intent/                            # new opt-in mode
│   ├── grounded_intent_mode.dart               # explicit mode boundary + request/result types
│   ├── question_normalizer.dart
│   ├── entity_extractor.dart                   # spans → @ENTITY_n + entity map
│   ├── catalog/
│   │   ├── schema_catalog.dart                 # in-memory catalog model + loader
│   │   ├── schema_catalog_loader.dart          # loads schema_catalog.json asset
│   │   └── schema_graph.dart                   # direct cols, outgoing/incoming FKs, paths, aggregations
│   ├── retrieval/
│   │   ├── concept_matcher.dart                # question terms → catalog concepts (synonyms/tags)
│   │   ├── lookup_matcher.dart                 # approved-value-only lookup matching
│   │   ├── candidate_retriever.dart            # builds typed candidates with IDs
│   │   └── candidate_ranker.dart               # ranks + flags ambiguity
│   ├── menu/
│   │   ├── candidate_menu.dart                 # candidate menu model
│   │   └── candidate_menu_renderer.dart        # compact text rendering for the SLM
│   ├── slm/
│   │   ├── selection_prompt_builder.dart       # builds the selection prompt (menu + placeholder question)
│   │   └── slm_selection_parser.dart           # parses candidate-ID selection JSON
│   ├── grounded_intent_validator.dart          # deterministic validation rules
│   ├── grounded_intent_assembler.dart          # expands candidate IDs → Final Intent JSON
│   ├── grounded_intent_service.dart            # orchestration + evidence + metrics
│   ├── grounded_intent_controller.dart         # explicit opt-in entry point
│   ├── grounded_intent_models.dart
│   ├── grounded_intent_metrics.dart
│   └── evaluation/
│       ├── golden_question_loader.dart
│       └── grounded_intent_scorecard.dart
└── view_or_dev_only_entry/
    └── grounded_intent_debug_view.dart         # dev/eval only, behind a debug flag if needed
```

Proposed tests:

```text
systems/project_management/test/features/ai_assistant/grounded_intent/
├── question_normalizer_test.dart
├── entity_extractor_test.dart
├── catalog/schema_catalog_loader_test.dart
├── catalog/schema_graph_test.dart
├── retrieval/concept_matcher_test.dart
├── retrieval/lookup_matcher_test.dart
├── retrieval/candidate_retriever_test.dart
├── retrieval/candidate_ranker_test.dart
├── menu/candidate_menu_renderer_test.dart
├── slm/slm_selection_parser_test.dart
├── grounded_intent_validator_test.dart
├── grounded_intent_assembler_test.dart
├── grounded_intent_service_test.dart
├── grounded_intent_mode_separation_test.dart
└── evaluation/golden_question_scorecard_test.dart
```

**Structure Decision**: All new production code lives under `grounded_intent/`, never in `local_slm/`, so the 001 free-text path is untouched. The SLM is reached only through a selection service that receives a candidate menu and returns candidate IDs.

## Component Responsibilities

- **QuestionNormalizer**: normalize Arabic orthography (tashkeel, alef/hamza/ya), normalize Latin casing, detect `ar` / `en` / `mixed`.
- **EntityExtractor**: detect quoted or high-signal entity spans, replace with `@ENTITY_n`, keep an entity map of placeholder → exact original value. Entity values are never translated.
- **SchemaCatalog / SchemaCatalogLoader**: load `schema_catalog.json`; expose tables, columns, types, PKs, FKs, lookups, field roles, concept tags, synonyms, exclusions, and version fields.
- **SchemaGraph**: build direct columns, outgoing FK edges, incoming/reverse FK edges, configured depth-N paths, and aggregation targets from the catalog. Generic traversal — no per-concept branches.
- **ConceptMatcher**: map normalized question terms to catalog concepts via synonyms/tags (risk, priority, department, manager, budget, outputs, etc.), producing concept matches with scores.
- **LookupMatcher**: match question terms only against approved lookup values in the catalog; never accept invented values or raw FK IDs.
- **CandidateRetriever**: from concept/lookup/entity matches and the SchemaGraph, build typed candidates — selectable fields (`C#`), filters (`F#`), entity filters (`E#`), relationships (`R#`), aggregations (`A#`), sorts (`S#`), group-bys (`G#`) — each fully grounded and given a stable ID. See `contracts/candidate_menu_contract.md`.
- **CandidateRanker**: rank candidates and flag ambiguity (for example risk vs priority) so the pipeline can request clarification.
- **CandidateMenuRenderer**: render the compact menu text (IDs + descriptions) for the SLM.
- **SelectionPromptBuilder**: build the SLM prompt from the menu and the placeholder-substituted question, instructing "select IDs only; do not invent or translate."
- **SlmSelectionParser**: parse the SLM's candidate-ID selection JSON; ignore/flag any free-form schema text.
- **GroundedIntentValidator**: apply every rejection rule (empty table/column, unknown table/column, missing relationship path, invalid/invented lookup value, raw lookup id, operator/type mismatch, translated entity, unrelated aggregation, ungrounded sort/group, SQL fragment, non-existent candidate id).
- **GroundedIntentAssembler**: expand validated candidate IDs into the Final Intent JSON, set `grounding.fully_grounded`, attach entity map, and choose `status`.
- **GroundedIntentService**: orchestrate the pipeline, produce Final Intent JSON plus grounding evidence and metrics.

## Local Schema Catalog: how it is generated and enriched

The catalog is **schema-driven but business-enriched**. Raw DB metadata alone is not enough:

- The schema tells us `Projects.PeriortyLevelId → PeriortyLevels.Id`. Enrichment adds that "low priority / low priorities / أولوية منخفضة / الأولوية المنخفضة" resolves to `PeriortyLevels.Name = "أولوية منخفضة"`.
- The schema tells us `Projects.Budget` is a column. Enrichment adds that "budget / cost / ميزانية / تكلفة" resolves to `Projects.Budget`.
- The schema tells us `ProjectOutPutModels.ProjectId → Projects.Id`. Enrichment adds that "outputs / deliverables / المخرجات" resolves to `count(ProjectOutPutModels.Id)`.

Generation pipeline (build-time or a committed generator, run during implementation):

1. Read the existing `projects_db_metadata_schema.json` (tables, columns, types, PKs, FKs, lookup_values, exclusions).
2. Merge a local `schema_enrichment.json` (concept tags, Arabic/English synonyms, field roles: searchable/entity/aggregatable/sortable/filterable/safe, and unsupported/private exclusions).
3. Derive incoming/reverse relationships and depth-1 relationship paths from the FK graph (v1; depth-N/multi-hop path derivation is future scope).
4. Emit `schema_catalog.json` with `catalog_version` and `source_schema_version`, matching `contracts/schema_catalog_contract.md`.

Because retrieval reads only the catalog, adding a new reachable concept is a **data change** (enrichment + regenerate), not a code change — satisfying the genericity requirement (SC-011).

## How exact Arabic entities are preserved

Before the SLM call, `what is the budget of "أتمتة العقود والقوانين"` becomes `what is the budget of @ENTITY_1`, with `entities = { "@ENTITY_1": "أتمتة العقود والقوانين" }`. The SLM only ever sees the placeholder, so it cannot translate or rewrite the value. The assembler substitutes the exact original string back into the entity filter, and validation rejects any output where the value differs from the entity map.

## How Final Intent JSON becomes SQL-generator-ready later

The Final Intent JSON is a fully grounded, backend-agnostic query description: `root_table`, `selected_fields`, `filters`, `relationships` (with FK paths), `aggregations`, `group_by`, `sort`, `limit`, `entities`, and `grounding`. A later backend SQL Generator (out of scope now) can translate it deterministically to SQL, consuming **only** results where `status="ok"` and `grounding.fully_grounded=true`. Everything the generator needs is already validated against the catalog, so it never has to trust the SLM.

## Boundaries

Do not add in this phase:
- SQL generation
- DB connection or DB retrieval
- backend query execution
- backend catalog API dependency
- MCP
- production answer-from-data
- clickable clarification UI (unless a later feature explicitly asks)
- changes to existing 001 free-text chat behavior
- edits to feature 002 `research.md` or G-M0 status

## References

- `systems/project_management/assets/ai/schema/projects_db_metadata_schema.json` (source schema metadata, `schema_version 0.1.0`, root `Projects`)
- `specs/002-slm-db-schema-intent-json/m0_probe/device_run/out/device_run_results.depth0_1024_real.md`
- `specs/002-slm-db-schema-intent-json/m0_probe/deterministic_grounding_spike/spike_out/spike_report.md`
- `specs/002-slm-db-schema-intent-json/m0_probe/m0_golden_questions.md`
- `specs/002-slm-db-schema-intent-json/m0_probe/schema_slice_summary.md`
