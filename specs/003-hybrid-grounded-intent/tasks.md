# Tasks: Hybrid Grounded Intent Pipeline for Local AI Assistant

**Input**: Design documents from `specs/003-hybrid-grounded-intent/`

**Gate**: This `/speckit-specify` pass produces documentation only. No production code, no catalog asset, and no `.dart` files are created here. The tasks below are the planned implementation backlog for later `/speckit-implement`.

**Hard boundaries**: No SQL generation, DB connection, data retrieval, backend query execution, backend catalog API, MCP, production answer-from-data, feature 002 `research.md` update, or G-M0 status change.

## Phase 0 — Catalog and Fixtures

- [X] T001 Author local enrichment `systems/project_management/assets/ai/schema/schema_enrichment.json` (concept tags, ar/en synonyms, column roles, exclusions) for the `Projects` root, covering at least priority, risk, budget, department, manager, category, lifecycle, and outputs concepts.
- [X] T002 Add a committed catalog generator that reads `projects_db_metadata_schema.json` + `schema_enrichment.json` and emits `systems/project_management/assets/ai/schema/schema_catalog.json` per `contracts/schema_catalog_contract.md` (derives incoming/reverse relationships and depth-1 paths; depth-N/multi-hop is future scope).
- [X] T003 Generate and commit `schema_catalog.json` (with `catalog_version` and `source_schema_version`), and register the new assets in `systems/project_management/pubspec.yaml`.
- [ ] T004 Create CI-safe golden question fixture from `specs/002-slm-db-schema-intent-json/m0_probe/m0_golden_questions.md` plus the four failure classes into `test/features/ai_assistant/grounded_intent/fixtures/golden_questions.json`.
- [ ] T005 Create recorded raw SLM output fixtures for the failure classes from `device_run_results.depth0_1024_real.md` into `test/features/ai_assistant/grounded_intent/fixtures/raw_slm_depth0_1024.json`.
- [ ] T006 Create expected Final Intent JSON fixtures for the four failure classes into `test/features/ai_assistant/grounded_intent/fixtures/expected_final_intents.json`.
- [ ] T007 Create fake SLM selection fixtures (candidate-ID selections) into `test/features/ai_assistant/grounded_intent/fixtures/slm_selections.json`.

## Phase 1 — Catalog and Graph

- [X] T008 [P] Add catalog loader tests in `test/features/ai_assistant/grounded_intent/catalog/schema_catalog_loader_test.dart` (version match, exclusions, lookups, relationship integrity).
- [X] T009 Implement `SchemaCatalog` model + `SchemaCatalogLoader` in `lib/features/ai_assistant/grounded_intent/catalog/`.
- [ ] T010 [P] Add SchemaGraph tests in `test/features/ai_assistant/grounded_intent/catalog/schema_graph_test.dart` (direct columns, outgoing FK, incoming/reverse FK to `ProjectOutPutModels`, depth-N path, aggregation targets).
- [ ] T011 Implement `SchemaGraph` in `lib/features/ai_assistant/grounded_intent/catalog/schema_graph.dart` (generic traversal, no per-concept branches).

## Phase 2 — Normalization and Entities

- [ ] T012 [P] Add normalizer tests in `test/features/ai_assistant/grounded_intent/question_normalizer_test.dart` (tashkeel, alef/hamza/ya, casing, language detection).
- [ ] T013 Implement `QuestionNormalizer` in `lib/features/ai_assistant/grounded_intent/question_normalizer.dart`.
- [ ] T014 [P] Add entity extractor tests in `test/features/ai_assistant/grounded_intent/entity_extractor_test.dart` (quoted + heuristic spans, `@ENTITY_n` mapping, verbatim preservation, no translation).
- [ ] T015 Implement `EntityExtractor` in `lib/features/ai_assistant/grounded_intent/entity_extractor.dart`.

## Phase 3 — Retrieval and Menu

- [ ] T016 [P] Add concept matcher tests in `test/features/ai_assistant/grounded_intent/retrieval/concept_matcher_test.dart` (synonym/tag matches, risk vs priority conflict flag).
- [ ] T017 Implement `ConceptMatcher` in `lib/features/ai_assistant/grounded_intent/retrieval/concept_matcher.dart`.
- [ ] T018 [P] Add lookup matcher tests in `test/features/ai_assistant/grounded_intent/retrieval/lookup_matcher_test.dart` (approved-value-only, reject invented values and raw IDs).
- [ ] T019 Implement `LookupMatcher` in `lib/features/ai_assistant/grounded_intent/retrieval/lookup_matcher.dart`.
- [ ] T020 [P] Add candidate retriever tests in `test/features/ai_assistant/grounded_intent/retrieval/candidate_retriever_test.dart` (typed candidates with IDs for the four failure classes; grounded-by-construction).
- [ ] T021 Implement `CandidateRetriever` in `lib/features/ai_assistant/grounded_intent/retrieval/candidate_retriever.dart`.
- [ ] T022 [P] Add candidate ranker tests in `test/features/ai_assistant/grounded_intent/retrieval/candidate_ranker_test.dart` (ranking + ambiguity flagging).
- [ ] T023 Implement `CandidateRanker` in `lib/features/ai_assistant/grounded_intent/retrieval/candidate_ranker.dart`.
- [ ] T024 [P] Add menu renderer tests in `test/features/ai_assistant/grounded_intent/menu/candidate_menu_renderer_test.dart` (compact format, placeholder shown not raw value, relationship aliases, size vs full schema).
- [ ] T025 Implement `CandidateMenu` + `CandidateMenuRenderer` in `lib/features/ai_assistant/grounded_intent/menu/`.

## Phase 4 — SLM Selection, Validation, Assembly

- [ ] T026 Implement `SelectionPromptBuilder` in `lib/features/ai_assistant/grounded_intent/slm/selection_prompt_builder.dart` (menu + placeholder question + "select IDs only" instructions).
- [ ] T027 [P] Add selection parser tests in `test/features/ai_assistant/grounded_intent/slm/slm_selection_parser_test.dart` (bare + object ID forms, stray free-form schema text flagged).
- [ ] T028 Implement `SlmSelectionParser` in `lib/features/ai_assistant/grounded_intent/slm/slm_selection_parser.dart`.
- [ ] T029 [P] Add validator tests in `test/features/ai_assistant/grounded_intent/grounded_intent_validator_test.dart` covering every error code (empty/unknown table/column, missing relationship, invalid/invented lookup, raw id, operator/type, entity modified, unrelated aggregation, ungrounded sort/group, sql fragment, invented reference, candidate not found).
- [ ] T030 Implement `GroundedIntentValidator` in `lib/features/ai_assistant/grounded_intent/grounded_intent_validator.dart`.
- [ ] T031 [P] Add assembler tests in `test/features/ai_assistant/grounded_intent/grounded_intent_assembler_test.dart` (candidate-ID expansion, entity substitution, implied relationships, `fully_grounded`/`status`).
- [ ] T032 Implement `GroundedIntentAssembler` in `lib/features/ai_assistant/grounded_intent/grounded_intent_assembler.dart`.

## Phase 5 — Mode, Service, Wiring

- [ ] T033 [P] Add mode separation tests in `test/features/ai_assistant/grounded_intent/grounded_intent_mode_separation_test.dart` (free-text path unchanged unless grounded mode is explicitly selected).
- [ ] T034 Implement `GroundedIntentMode` request/result boundary in `lib/features/ai_assistant/grounded_intent/grounded_intent_mode.dart`.
- [ ] T035 Add service orchestration tests with fake SLM selections in `test/features/ai_assistant/grounded_intent/grounded_intent_service_test.dart` (four failure classes end to end).
- [ ] T036 Implement `GroundedIntentService` in `lib/features/ai_assistant/grounded_intent/grounded_intent_service.dart` (orchestration + evidence + metrics).
- [ ] T037 Implement explicit opt-in `GroundedIntentController` in `lib/features/ai_assistant/grounded_intent/grounded_intent_controller.dart`.
- [ ] T038 Register grounded intent services additively in `lib/core/di/project_management_locator.dart` (no change to 001 wiring).

## Phase 6 — Evaluation and Scorecard

- [ ] T039 [P] Add golden scorecard tests in `test/features/ai_assistant/grounded_intent/evaluation/golden_question_scorecard_test.dart`.
- [ ] T040 Implement golden question loader in `lib/features/ai_assistant/grounded_intent/evaluation/golden_question_loader.dart`.
- [ ] T041 Implement scorecard (selection validity, grounding accuracy, relationship accuracy, entity-preservation rate, invented-reference rate, clarification/unsupported correctness, latency) in `lib/features/ai_assistant/grounded_intent/evaluation/grounded_intent_scorecard.dart`.
- [ ] T042 Run CI-safe golden regression with fake SLM selections and record results in `specs/003-hybrid-grounded-intent/test-strategy.md`.
- [ ] T043 Run manual device evaluation (latency + real selection behavior) and record in this feature's evaluation notes without editing feature 002 `research.md`.

## Phase 7 — Validation

- [ ] T044 Run `flutter test systems/project_management/test/features/ai_assistant/grounded_intent/`.
- [ ] T045 Run existing 001 free-text chat regression tests to prove behavior is unchanged.
- [ ] T046 Inspect code paths and confirm no SQL generation, DB connection, data retrieval, backend query execution, backend catalog dependency, MCP, or production answer-from-data was introduced.

## Dependencies

- T001–T007 precede implementation.
- T002 depends on T001; T003 depends on T002.
- T009 depends on T003, T008; T011 depends on T009, T010.
- T013 depends on T012; T015 depends on T014.
- T017 depends on T009, T016; T019 depends on T009, T018.
- T021 depends on T011, T015, T017, T019, T020; T023 depends on T021, T022.
- T025 depends on T021, T024.
- T028 depends on T025, T027.
- T030 depends on T011, T021, T028, T029.
- T032 depends on T021, T028, T030, T031.
- T036 depends on T025, T026, T028, T030, T032, T035.
- T037 depends on T036; T038 depends on T037.
- T040–T041 depend on T036; T039 depends on T041.
- T044–T046 depend on all selected implementation tasks.

## Parallel Guidance

- `[P]` tasks are test authoring or independent files; write tests before their implementations.
- Catalog/graph (Phase 1) and normalization/entities (Phase 2) can proceed in parallel once fixtures exist.
- Retrieval (Phase 3) cannot start until catalog/graph and entity extraction are available.
