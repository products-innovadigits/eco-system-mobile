# Tasks: Schema-Aware Intent JSON Extraction (Projects POC)

**Input**: Design documents from `specs/002-slm-db-schema-intent-json/`

**Prerequisites**: `plan.md`, `spec.md`, `research.md`, `data-model.md`, `contracts/`, `quickstart.md`

**Hard gate**: M0 is mandatory. No M2+ on-device pipeline implementation may start, land, or merge before G-M0 is recorded in `specs/002-slm-db-schema-intent-json/research.md`.

**G-M0 means all six are recorded**:
1. Schema sample exists.
2. Context/token budget is measured.
3. Current Qwen2.5 1.5B is tested with the trimmed projects schema.
4. Strict JSON vs structured output is evaluated where available.
5. Generation path is selected.
6. Keep-current-model or fallback-needed decision is recorded.

**Non-goals for every task**: Do not add SQL generation, DB connections from Flutter, real DB data retrieval, MCP, backend handoff, Python CLI automation, clickable clarification UI, startup model switching, or changes to the existing 001 free-text chat path.

## Format

- Checklist line: `- [ ] T### [P?] [US?] Description with file path`
- Metadata line: `Milestone`, `Title`, `Description`, `Files touched`, `Dependencies`, `Acceptance check`, `Execution`, `CI`
- `[P]` means the task can run in parallel after its dependencies are satisfied.
- `[US1]` etc. maps to the user stories in `spec.md`. M0/M1 setup tasks omit user-story labels unless they directly serve a story.

---

## DO FIRST: M0 / Schema sample + Measurement Gate

**Milestone goal**: Prepare a realistic schema sample and complete the Samsung Galaxy S22 Ultra measurement gate before any M2+ pipeline implementation. M0 blocks M2, M3, M4, M5, M6, and M7 implementation.

- [X] T001 Create the manual export script scaffold in `tools/schema_export/export_projects_schema.sql`
  - Metadata: Milestone=M0; Title=Create export SQL scaffold; Description=Add the read-only SQL Server script skeleton with editable root-table variable, FK-depth-2 traversal intent, lookup cap default `maxLookupRows = 50`, denylist placeholders, and `FOR JSON PATH` guidance, without adding automation; Files touched=`tools/schema_export/export_projects_schema.sql`; Dependencies=None; Acceptance check=script is reviewable, contains no credentials, and documents root-table/depth/cap/denylist variables; Execution=blocking, gated, manual-prep; CI=manual-only.

- [X] T002 Create the export operator runbook in `tools/schema_export/README.md`
  - Metadata: Milestone=M0; Title=Create manual export README; Description=Document SSMS/sqlcmd read-only execution, root-table selection, copy-out/manual assembly, denylist review, representative-sample fallback, and the rule that DB credentials stay outside the repo and Flutter; Files touched=`tools/schema_export/README.md`; Dependencies=T001; Acceptance check=README lets a developer produce or simulate the asset without Python CLI automation or Flutter DB access; Execution=blocking, gated, manual-prep; CI=manual-only.

- [X] T003 Prepare an initial contract-compliant schema sample in `systems/project_management/assets/ai/schema/projects_db_metadata_schema.json`
  - Metadata: Milestone=M0; Title=Prepare schema sample asset; Description=Run the manual SQL Server export read-only or hand-author a representative projects-domain sample that matches `contracts/schema_metadata_contract.md`, including schema metadata, capped lookups, provenance, and sample values off by default; Files touched=`systems/project_management/assets/ai/schema/projects_db_metadata_schema.json`; Dependencies=T001,T002; Acceptance check=JSON parses, declares `schema_version`, `generated_at`, `root_table`, `extraction_summary`, `schema_metadata`, `lookup_values`, and no uncapped lookup arrays; Execution=blocking, gated, manual or simulated; CI=manual-only until loader tests exist.

- [X] T004 Review the schema sample for sensitive fields and record the review result in `specs/002-slm-db-schema-intent-json/research.md`
  - Metadata: Milestone=M0; Title=Sensitive-field review; Description=Check the schema asset against the denylist in the schema contract and record reviewer/date/source plus zero-sensitive-fields or remediation notes in the M0 section; Files touched=`specs/002-slm-db-schema-intent-json/research.md`; Dependencies=T003; Acceptance check=research.md states whether the asset is real or representative and confirms no password/token/secret/PII-style fields are present; Execution=blocking, gated, manual; CI=manual-only.

- [X] T005 Register the schema asset path in `systems/project_management/pubspec.yaml`
  - Metadata: Milestone=M0; Title=Register schema asset; Description=Add `assets/ai/schema/projects_db_metadata_schema.json` to Flutter assets only if not already covered, preserving existing 001 assets; Files touched=`systems/project_management/pubspec.yaml`; Dependencies=T003; Acceptance check=`flutter pub get` can resolve the asset declaration and existing assets remain listed; Execution=blocking, gated, automated-safe; CI=CI-safe.

- [X] T006 Run or simulate the manual SQL Server export and record provenance in `specs/002-slm-db-schema-intent-json/research.md`
  - Metadata: Milestone=M0; Title=Export provenance record; Description=Record whether the sample came from SQL Server or representative authoring, chosen root table, FK depth, lookup cap, denylist applied, and any manual assembly steps; Files touched=`specs/002-slm-db-schema-intent-json/research.md`; Dependencies=T003,T004; Acceptance check=research.md contains enough provenance to reproduce or replace the sample; Execution=blocking, gated, manual; CI=manual-only.

- [ ] T007 Run M0 context/token-budget measurement on Samsung Galaxy S22 Ultra and record results in `specs/002-slm-db-schema-intent-json/research.md`
  - Metadata: Milestone=M0; Title=Measure context budget; Description=Using current Qwen2.5 1.5B, measure/estimate usable context, depth-2 slice size, prompt size, and first fallback ladder step that fits: compact formatting, reduced lookup caps, or depth 1; Files touched=`specs/002-slm-db-schema-intent-json/research.md`; Dependencies=T003,T005,T006; Acceptance check=research.md records context window, depth-2 token estimate, fit/no-fit, fallback step, and latency notes from S22 Ultra; Execution=blocking, gated, manual; CI=manual-only.

- [ ] T008 Compare strict JSON prompting with structured output if available and record results in `specs/002-slm-db-schema-intent-json/research.md`
  - Metadata: Milestone=M0; Title=Evaluate generation path; Description=Run the same M0 probe questions through strict JSON prompting and any available structured-output path, then record parse-success, schema-validity, repair need, and latency; Files touched=`specs/002-slm-db-schema-intent-json/research.md`; Dependencies=T007; Acceptance check=research.md states strict-JSON parse rate, structured-output parse rate or unavailable status, and sample failures; Execution=blocking, gated, manual; CI=manual-only.

- [ ] T009 Record G-M0 decision and selected generation path in `specs/002-slm-db-schema-intent-json/research.md`
  - Metadata: Milestone=M0; Title=Record G-M0; Description=Record the selected generation path, keep-current-model or fallback-needed decision, thresholds, and explicit approval to begin M2+ implementation only if G-M0 passes; Files touched=`specs/002-slm-db-schema-intent-json/research.md`; Dependencies=T001,T002,T003,T004,T005,T006,T007,T008; Acceptance check=research.md contains a dated G-M0 section with all six gate criteria satisfied or a stop/escalate decision; Execution=blocking, gated, manual; CI=manual-only.

- [X] T009a Dev-only M0 Intent JSON probe via the normal chat send flow (M0 support — NOT the Intent pipeline)
  - Metadata: Milestone=M0; Title=M0 Intent JSON probe (config + send param); Description=No `--dart-define`, no separate screen. A code-level config `AiAssistantDevConfig{useIntentJsonProbe:bool=false, intentProbeDepth:int=2}` is passed from the normal chat send (`AiAssistantBody._sendLocal`) into the controller method that receives the question: `AiInferenceController.generate(userText, {useIntentJsonProbe=false, intentProbeDepth=2})`. When false → exact feature-001 free-text behavior (no template loaded, no logs). When true → `M0IntentPrompt.build` loads the fixed template for the depth (`assets/ai/prompts/m0_strict_json_depth_2.txt` / `..._depth_1.txt`), injects the typed question into `{{USER_QUESTION}}`, calls the existing `LocalSlmService.generateText`, and emits `[AI_INTENT_PROBE]` debug logs (variant, question/prompt length, latency, `raw_output=…`); the raw output is returned as the chat response so it shows in the bubble during testing; Files touched=`lib/features/ai_assistant/m0_probe/ai_assistant_dev_config.dart`,`.../m0_intent_prompt.dart`,`.../m0_probe_log.dart`,`lib/features/ai_assistant/local_slm/ai_inference_controller.dart`,`lib/features/ai_assistant/widgets/ai_assistant_body.dart`,`assets/ai/prompts/m0_strict_json_depth_2.txt`,`assets/ai/prompts/m0_strict_json_depth_1.txt`,`pubspec.yaml`; Dependencies=T003; Acceptance check=tester types only the question on the normal chat screen; `useIntentJsonProbe=false` keeps 001 behavior unchanged with no intent template/logs (regression test); `useIntentJsonProbe=true` assembles the depth-2/depth-1 template and reuses `LocalSlmService`; NO SchemaGraph/loader/trimmer/parser/validator/repair/IntentService/production Intent Debug UI; does NOT mark G-M0 passed; Execution=automated (unit tests for on/off + depth) + manual (device run); CI=CI-safe (no real inference in CI).
  - Note: Supersedes the earlier separate-screen/`--dart-define` approach, which was removed (`m0_probe_view.dart`, `m0_probe_flags.dart`, `m0_probe_controller.dart`, the flag-gated launcher in `ai_assistant_view.dart`, and the screen-only DI registration). This is **M0 measurement support only** — not M2+; the `intent/` pipeline folder is still not created. G-M0 remains pending until real S22 Ultra results (T007/T008) are recorded and reviewed.
  - Crash-fix update (device SIGSEGV on depth-2): the probe now runs a **fresh, history-free one-shot** via a new minimal dev method `LocalSlmService.generateOneShotText` (FlutterGemma impl closes+reopens a clean session so prior chat context cannot overflow the model window; normal `generateText` chat path unchanged). A **preflight size guard** in `AiInferenceController` estimates prompt tokens against `AiAssistantDevConfig.intentProbeContextTokens` (1024) minus `intentProbeOutputReserveTokens` (256); oversized prompts return a controlled `GenerationFailed('prompt_too_large…')` and log `[AI_INTENT_PROBE] prompt_too_large` WITHOUT calling native (no SIGSEGV). Added `assets/ai/prompts/m0_strict_json_depth_0.txt` (minimal, ~410 tok) for the 1024-ctx model; on Qwen2.5 1.5B depth-2 (~1226 tok) and depth-1 (~895 tok) are correctly rejected as too-large, depth-0 fits. Default `useIntentJsonProbe=false`, `intentProbeDepth=1`. Still M0-only; no SchemaGraph/parser/validator/repair/IntentService; G-M0 still pending.

**Checkpoint M0**: Stop if T009 does not record G-M0 as passed. M1 documentation and asset cleanup may continue, but no M2+ on-device pipeline implementation starts or merges. (T009a, the dev-only measurement harness, is permitted M0 support and is NOT M2+.)

---

## M1 - Manual SQL Server export script + reviewed JSON asset

**Milestone goal**: Make the off-device export path durable and keep the reviewed asset committed and consumable by Flutter. M1 asset is required for M2 loader tests.

- [ ] T010 [US2] Complete FK-depth-2 table/column/PK/FK extraction in `tools/schema_export/export_projects_schema.sql`
  - Metadata: Milestone=M1; Title=Implement metadata extraction SQL; Description=Fill in read-only SQL Server queries for root plus FK-depth-2 neighbors, columns, SQL Server data types, nullability, primary keys, foreign keys, and relationship paths; Files touched=`tools/schema_export/export_projects_schema.sql`; Dependencies=T009; Acceptance check=script emits schema metadata sections matching `schema_metadata_contract.md` without credentials or DML; Execution=blocking for asset quality, manual; CI=manual-only.

- [ ] T011 [US2] Complete lookup cap and denylist filtering in `tools/schema_export/export_projects_schema.sql`
  - Metadata: Milestone=M1; Title=Implement lookup and denylist rules; Description=Add capped distinct lookup/reference extraction, `maxLookupRows = 50`, raw samples off by default, and denylist filtering for sensitive tables/columns; Files touched=`tools/schema_export/export_projects_schema.sql`; Dependencies=T009; Acceptance check=lookup arrays are capped, denylisted names are filtered, and samples require an explicit opt-in flag; Execution=blocking for asset quality, manual; CI=manual-only.

- [ ] T012 [US2] Update export runbook details in `tools/schema_export/README.md`
  - Metadata: Milestone=M1; Title=Finalize export README; Description=Document the final script variables, root discovery notes, review checklist, JSON copy-out process, asset destination, and how to replace a representative sample with a real export; Files touched=`tools/schema_export/README.md`; Dependencies=T010,T011; Acceptance check=README explains how to produce the reviewed asset with no DB credentials in repo and no Flutter DB connection; Execution=manual; CI=manual-only.

- [ ] T013 [US2] Refresh and re-review `systems/project_management/assets/ai/schema/projects_db_metadata_schema.json`
  - Metadata: Milestone=M1; Title=Finalize reviewed schema asset; Description=Regenerate or update the schema asset from the completed script or representative sample, then repeat contract and sensitive-field review; Files touched=`systems/project_management/assets/ai/schema/projects_db_metadata_schema.json`,`specs/002-slm-db-schema-intent-json/research.md`; Dependencies=T010,T011,T012; Acceptance check=asset conforms to the contract, contains zero sensitive fields, and review notes in research.md identify final source/provenance; Execution=blocking for M2 tests, manual; CI=manual-only until T016.

- [ ] T014 [P] [US2] Add a compact fixture copy for tests in `systems/project_management/test/features/ai_assistant/intent/fixtures/projects_db_metadata_schema.valid.json`
  - Metadata: Milestone=M1; Title=Create valid schema fixture; Description=Create a small non-sensitive fixture derived from the **M0 schema sample (T003)** so M2 can begin right after M0; refresh it from T013's reviewed asset once M1 is finalized; for CI-safe loader/trimmer/validator tests; Files touched=`systems/project_management/test/features/ai_assistant/intent/fixtures/projects_db_metadata_schema.valid.json`; Dependencies=T003 (refresh after T013 when the reviewed asset is final); Acceptance check=fixture contains root, at least one FK path, lookup values, and no real sensitive data; Execution=automated-prep; CI=CI-safe.

---

## M2 - SchemaGraph load/parse

**Milestone goal**: Load the reviewed schema asset into an in-memory SchemaGraph with CI-safe tests. M2 is blocked by G-M0 and depends on the M1 asset/fixture.

- [ ] T015 [P] [US1] Create SchemaGraph value types in `systems/project_management/lib/features/ai_assistant/intent/schema_graph.dart`
  - Metadata: Milestone=M2; Title=Create SchemaGraph model; Description=Implement `SchemaGraph`, `TableNode`, `ColumnNode`, `FkEdge`, and `LookupSet` with helpers for table/column lookup, FK path checks, neighbors, operator compatibility, and lookup values; Files touched=`systems/project_management/lib/features/ai_assistant/intent/schema_graph.dart`; Dependencies=T009 (data-model/contract only — does NOT depend on the finalized M1 asset/fixture); Acceptance check=types mirror `data-model.md` and expose helpers required by trimmer and validator; Execution=automated; CI=CI-safe.

- [ ] T015a [P] Create the debug-only intent logger in `systems/project_management/lib/features/ai_assistant/intent/intent_debug_log.dart`
  - Metadata: Milestone=M2; Title=Create intent debug logger; Description=Add a centralized debug/POC-only logger (modeled on `local_slm/ai_log.dart`) with consistent greppable category prefixes `[AI_INTENT]`, `[AI_SCHEMA]`, `[AI_PROMPT]`, `[AI_GEN]`, `[AI_VALIDATION]`, `[AI_REPAIR]`, `[AI_SCORE]`; gate all output behind `kReleaseMode`/a POC flag so nothing logs in release; never log credentials, tokens, passwords, connection strings, secrets, private URLs, or PII, and do not log optional sample values unless explicitly enabled; table/column names from the reviewed asset are allowed in POC mode; centralized helper only — no scattered `print()`; Files touched=`systems/project_management/lib/features/ai_assistant/intent/intent_debug_log.dart`; Dependencies=T009; Acceptance check=logger is a single helper, disabled in release, exposes prefixed category methods, and forbids secret/sample-value logging by construction; Execution=automated; CI=CI-safe.

- [ ] T016 [P] [US1] Create schema loader tests in `systems/project_management/test/features/ai_assistant/intent/schema_loader_test.dart`
  - Metadata: Milestone=M2; Title=Add schema_loader_test; Description=Write CI-safe tests for valid fixture loading, unsupported schema major, missing root table, malformed JSON, FK reference reporting, and lookup cap enforcement; Files touched=`systems/project_management/test/features/ai_assistant/intent/schema_loader_test.dart`; Dependencies=T014; Acceptance check=tests fail before loader implementation and do not use DB/network/model inference; Execution=automated; CI=CI-safe.

- [ ] T017 [US1] Implement schema loading and contract validation in `systems/project_management/lib/features/ai_assistant/intent/schema_loader.dart`
  - Metadata: Milestone=M2; Title=Implement SchemaLoader; Description=Load the asset with Flutter asset APIs, parse JSON with `dart:convert`, validate the schema contract, build `SchemaGraph`, ignore unknown top-level future keys, produce clear load errors, and emit `[AI_SCHEMA]` debug logs for asset load + parse result via `intent_debug_log`; Files touched=`systems/project_management/lib/features/ai_assistant/intent/schema_loader.dart`; Dependencies=T015,T016,T015a; Acceptance check=`schema_loader_test` passes, invalid assets fail gracefully without touching the 001 chat path, and `[AI_SCHEMA]` logs appear only in debug/POC mode; Execution=automated; CI=CI-safe.

- [ ] T018 [US1] Register `SchemaLoader` in `systems/project_management/lib/core/di/project_management_locator.dart`
  - Metadata: Milestone=M2; Title=Register schema loader; Description=Add guarded lazy registration for `SchemaLoader` using the existing `isRegistered` pattern and new intent imports only; Files touched=`systems/project_management/lib/core/di/project_management_locator.dart`; Dependencies=T017; Acceptance check=DI setup compiles and existing local SLM registrations are unchanged except additive imports/registrations; Execution=automated; CI=CI-safe.

---

## M3 - Schema context trimming

**Milestone goal**: Produce a token-budget-aware schema slice from SchemaGraph. M3 requires M2 SchemaGraph and the G-M0 measured budget.

- [ ] T019 [P] [US1] Create context trimmer tests in `systems/project_management/test/features/ai_assistant/intent/schema_context_trimmer_test.dart`
  - Metadata: Milestone=M3; Title=Add schema_context_trimmer_test; Description=Write tests for depth-2 fit, compact serialization, reduced lookup caps, depth-1 fallback, deterministic output, and configurable token-budget heuristic; Files touched=`systems/project_management/test/features/ai_assistant/intent/schema_context_trimmer_test.dart`; Dependencies=T015,T017; Acceptance check=tests use fixtures and measured M0 budget values as configurable inputs, not real inference; Execution=automated; CI=CI-safe.

- [ ] T020 [US1] Implement `SchemaContextTrimmer` in `systems/project_management/lib/features/ai_assistant/intent/schema_context_trimmer.dart`
  - Metadata: Milestone=M3; Title=Implement schema trimming; Description=Serialize a compact schema slice around the root table, apply depth 2, lookup-cap reduction, and depth-1 fallback according to the M0 budget, report trim metadata, and emit `[AI_SCHEMA]` debug logs (selected root, included tables, FK depth used, lookup caps, approximate prompt/context size); Files touched=`systems/project_management/lib/features/ai_assistant/intent/schema_context_trimmer.dart`; Dependencies=T017,T019,T015a; Acceptance check=`schema_context_trimmer_test` passes, produced slices never exceed the configured budget in tests, and the trim summary logs only in debug/POC mode; Execution=automated; CI=CI-safe.

- [ ] T021 [US1] Register `SchemaContextTrimmer` in `systems/project_management/lib/core/di/project_management_locator.dart`
  - Metadata: Milestone=M3; Title=Register trimmer; Description=Add guarded lazy registration for the trimmer without changing 001 controllers or chat wiring; Files touched=`systems/project_management/lib/core/di/project_management_locator.dart`; Dependencies=T020; Acceptance check=DI compiles and trimmer can be resolved after setup; Execution=automated; CI=CI-safe.

---

## M4 - Intent prompt + generation

**Milestone goal**: Build the schema-aware prompt and call the selected generation path through the existing `LocalSlmService.generateText`. M4 requires M3 trimming and the generation path selected at G-M0.

- [ ] T022 [P] [US1] Add the intent system instruction in `systems/project_management/assets/ai/prompts/intent_system_instruction.txt`
  - Metadata: Milestone=M4; Title=Create intent system prompt asset; Description=Write strict Intent JSON instructions for Arabic/English/mixed questions, no SQL, no real data answers, no invented schema references, and clarification/unsupported contract handling; Files touched=`systems/project_management/assets/ai/prompts/intent_system_instruction.txt`; Dependencies=T009; Acceptance check=prompt instructs JSON-only output and does not ask the model to generate SQL or retrieve data; Execution=automated-prep; CI=CI-safe.

- [ ] T023 [US1] Register prompt asset in `systems/project_management/pubspec.yaml`
  - Metadata: Milestone=M4; Title=Register intent prompt asset; Description=Add the intent system instruction asset while preserving existing 001 prompt and metadata assets; Files touched=`systems/project_management/pubspec.yaml`; Dependencies=T022; Acceptance check=Flutter asset list includes both old 001 assets and new intent prompt asset; Execution=automated; CI=CI-safe.

- [ ] T024 [P] [US1] Create Intent model types in `systems/project_management/lib/features/ai_assistant/intent/intent_model.dart`
  - Metadata: Milestone=M4; Title=Create Intent model; Description=Implement Dart value types/enums mirroring `intent_json_contract.md`, including filters, relationships, aggregations, date range, sort, clarification options, and validation errors; Files touched=`systems/project_management/lib/features/ai_assistant/intent/intent_model.dart`; Dependencies=T009; Acceptance check=models can represent all contract fields and enumerated domains exactly; Execution=automated; CI=CI-safe.

- [ ] T025 [P] [US1] Implement prompt building in `systems/project_management/lib/features/ai_assistant/intent/intent_prompt_builder.dart`
  - Metadata: Milestone=M4; Title=Implement prompt builder; Description=Build prompt text from system instruction, trimmed schema context, user question, max-token guidance, and selected language behavior without touching the 001 `PromptBuilder`; emit `[AI_PROMPT]` debug logs for prompt size and a schema-slice summary only (never raw secrets or sensitive data); Files touched=`systems/project_management/lib/features/ai_assistant/intent/intent_prompt_builder.dart`; Dependencies=T020,T022,T024,T015a; Acceptance check=builder output contains the schema slice and contract instruction, excludes SQL/retrieval instructions, and `[AI_PROMPT]` logs (size/summary only) appear only in debug/POC mode; Execution=automated; CI=CI-safe.

- [ ] T026 [US1] Implement generation strategy abstraction in `systems/project_management/lib/features/ai_assistant/intent/intent_generation_strategy.dart`
  - Metadata: Milestone=M4; Title=Implement IntentGenerationStrategy; Description=Add `StrictJsonStrategy` and optional `StructuredOutputStrategy` wrapper selected from G-M0, both using the existing `LocalSlmService.generateText(prompt, maxTokens, timeout)` contract without modifying `LocalSlmService`; emit `[AI_GEN]` debug logs for strategy used, start/end timestamps, latency, and timeout/error; Files touched=`systems/project_management/lib/features/ai_assistant/intent/intent_generation_strategy.dart`; Dependencies=T009,T025,T015a; Acceptance check=strategy compiles with existing 001 service interface, records the selected path, and `[AI_GEN]` logs appear only in debug/POC mode; Execution=automated; CI=CI-safe with fakes, real model manual-only.

- [ ] T027 [US1] Register prompt builder and generation strategy in `systems/project_management/lib/core/di/project_management_locator.dart`
  - Metadata: Milestone=M4; Title=Register prompt/generation components; Description=Add guarded lazy registrations for `IntentPromptBuilder` and the G-M0 selected `IntentGenerationStrategy`, reusing registered `LocalSlmService`; Files touched=`systems/project_management/lib/core/di/project_management_locator.dart`; Dependencies=T025,T026; Acceptance check=DI resolves intent generation components and existing `AiInferenceController` remains unchanged; Execution=automated; CI=CI-safe.

---

## M5 - Parse / validate / repair

**Milestone goal**: Parse model output, validate it against SchemaGraph, and perform exactly one repair retry. M5 requires M2 SchemaGraph and M4 generation.

- [ ] T028 [P] [US1] Create parser tests in `systems/project_management/test/features/ai_assistant/intent/intent_parser_test.dart`
  - Metadata: Milestone=M5; Title=Add intent_parser_test; Description=Test fenced JSON, noisy prose with first balanced object, clean JSON, truncated JSON, malformed JSON, enum validation, and parse-error reporting; Files touched=`systems/project_management/test/features/ai_assistant/intent/intent_parser_test.dart`; Dependencies=T024; Acceptance check=tests are deterministic and use no real model; Execution=automated; CI=CI-safe.

- [ ] T029 [P] [US3] [US4] Create validator tests in `systems/project_management/test/features/ai_assistant/intent/intent_validator_test.dart`
  - Metadata: Milestone=M5; Title=Add intent_validator_test; Description=Test unknown table, unknown column, missing FK path, type-incompatible operator, unknown lookup value, raw SQL fragment, clarification option table validation, unsupported shape, and 100% catch of crafted hallucination cases; Files touched=`systems/project_management/test/features/ai_assistant/intent/intent_validator_test.dart`; Dependencies=T015,T017,T024; Acceptance check=tests fail before validator implementation and cover SC-005 cases; Execution=automated; CI=CI-safe.

- [ ] T030 [P] [US3] Create repair tests in `systems/project_management/test/features/ai_assistant/intent/intent_repair_test.dart`
  - Metadata: Milestone=M5; Title=Add intent_repair_test; Description=Test invalid-then-valid scripted output, invalid-twice finalization, parse-error repair, validation-error repair prompt content, and exactly-one-retry behavior; Files touched=`systems/project_management/test/features/ai_assistant/intent/intent_repair_test.dart`; Dependencies=T024,T026,T031a; Acceptance check=tests use the shared fakes (T031a) for invalid-then-valid sequences and never run real inference; Execution=automated; CI=CI-safe.

- [ ] T031 [P] [US1] Create service orchestration tests in `systems/project_management/test/features/ai_assistant/intent/intent_service_test.dart`
  - Metadata: Milestone=M5; Title=Add intent_service_test; Description=Test end-to-end orchestration with the shared `FakeLocalSlmService` for ok, needs_clarification, unsupported, invalid_schema_reference, parse failure, and repair success/failure; Files touched=`systems/project_management/test/features/ai_assistant/intent/intent_service_test.dart`; Dependencies=T017,T020,T024,T026,T031a; Acceptance check=tests are CI-safe, scripted via the shared fakes (T031a), and assert no SQL/DB/network paths are used; Execution=automated; CI=CI-safe.

- [ ] T031a [P] [US1] Create shared intent test fakes in `systems/project_management/test/features/ai_assistant/intent/fakes/`
  - Metadata: Milestone=M5; Title=Create shared intent test fakes; Description=Add reusable `FakeLocalSlmService` (implements the 001 `LocalSlmService`) and `FakeIntentGenerationStrategy` (implements `IntentGenerationStrategy`) supporting queued/scripted outputs, invalid-then-valid sequences for repair-retry tests, and optional latency/error simulation; CI-safe, never uses real `flutter_gemma`; replaces inline per-test fakes so they are not duplicated; Files touched=`systems/project_management/test/features/ai_assistant/intent/fakes/fake_local_slm_service.dart`,`systems/project_management/test/features/ai_assistant/intent/fakes/fake_intent_generation_strategy.dart`; Dependencies=T024,T026 (no dependency on the tests that consume it — implement T031a before T030/T031/T034/T035/T039/T044); Acceptance check=both fakes return queued outputs deterministically, support an invalid→valid sequence, and run with no real inference, network, or DB; Execution=automated; CI=CI-safe.

- [ ] T032 [US1] Implement tolerant parsing in `systems/project_management/lib/features/ai_assistant/intent/intent_parser.dart`
  - Metadata: Milestone=M5; Title=Implement IntentParser; Description=Strip markdown fences, extract the first balanced top-level JSON object, decode with `dart:convert`, map to `Intent`, and produce parse errors without throwing through UI; Files touched=`systems/project_management/lib/features/ai_assistant/intent/intent_parser.dart`; Dependencies=T024,T028; Acceptance check=`intent_parser_test` passes; Execution=automated; CI=CI-safe.

- [ ] T033 [US3] [US4] Implement schema-grounded validation in `systems/project_management/lib/features/ai_assistant/intent/intent_validator.dart`
  - Metadata: Milestone=M5; Title=Implement IntentValidator; Description=Validate table/column/FK/operator/lookup references, reject SQL fragments in any string value, validate clarification option table references, derive final status per contract (incl. `needs_clarification` and `unsupported`), and emit `[AI_VALIDATION]` debug logs for the validation result and each validation error; Files touched=`systems/project_management/lib/features/ai_assistant/intent/intent_validator.dart`; Dependencies=T015,T017,T024,T029,T015a; Acceptance check=`intent_validator_test` passes with 100% catch of crafted hallucination and SQL-fragment cases, and `[AI_VALIDATION]` logs appear only in debug/POC mode; Execution=automated; CI=CI-safe.

- [ ] T034 [US3] Implement one-retry repair in `systems/project_management/lib/features/ai_assistant/intent/intent_repair.dart`
  - Metadata: Milestone=M5; Title=Implement IntentRepair; Description=Create a compact repair prompt containing original question, trimmed schema, raw output or parsed candidate, and validation errors; invoke generation once and finalize errors if still invalid; emit `[AI_REPAIR]` debug logs for retry start/end and outcome; Files touched=`systems/project_management/lib/features/ai_assistant/intent/intent_repair.dart`; Dependencies=T026,T032,T033,T030,T015a; Acceptance check=`intent_repair_test` passes, proves exactly one retry, and `[AI_REPAIR]` logs appear only in debug/POC mode; Execution=automated; CI=CI-safe with fakes.

- [ ] T035 [US1] Implement orchestration in `systems/project_management/lib/features/ai_assistant/intent/intent_service.dart`
  - Metadata: Milestone=M5; Title=Implement IntentService; Description=Orchestrate schema load, trim, prompt build, generation, parse, validation, repair, metrics payload creation, empty-question handling, and in-progress gating; emit `[AI_INTENT]` debug logs for run start, raw model output, parsed Intent JSON, and final Intent result (delegating stage-specific logs to the relevant components); Files touched=`systems/project_management/lib/features/ai_assistant/intent/intent_service.dart`; Dependencies=T017,T020,T025,T026,T032,T033,T034,T031,T031a,T015a; Acceptance check=`intent_service_test` passes with the shared `FakeLocalSlmService` and no real model, and `[AI_INTENT]` logs appear only in debug/POC mode; Execution=automated; CI=CI-safe with fakes.

- [ ] T035a [P] Create intent debug logger tests in `systems/project_management/test/features/ai_assistant/intent/intent_debug_log_test.dart`
  - Metadata: Milestone=M5; Title=Add intent_debug_log_test; Description=Verify the logger is gated (no output in release/disabled mode), uses the documented `[AI_*]` prefixes, and that logging calls do not alter pipeline behavior or return values; Files touched=`systems/project_management/test/features/ai_assistant/intent/intent_debug_log_test.dart`; Dependencies=T015a; Acceptance check=tests confirm release/disabled gating and behavior-neutrality; CI must not depend on terminal log output; Execution=automated; CI=CI-safe.

- [ ] T036 [US1] Implement dev entry controller in `systems/project_management/lib/features/ai_assistant/intent/intent_inference_controller.dart`
  - Metadata: Milestone=M5; Title=Implement IntentInferenceController; Description=Expose a dev-only controller around `IntentService`, model readiness errors, current run state, and last result for the debug screen; Files touched=`systems/project_management/lib/features/ai_assistant/intent/intent_inference_controller.dart`; Dependencies=T035; Acceptance check=controller compiles and does not modify `AiInferenceController`; Execution=automated; CI=CI-safe.

- [ ] T037 [US1] Register parser, validator, repair, service, and intent controller in `systems/project_management/lib/core/di/project_management_locator.dart`
  - Metadata: Milestone=M5; Title=Register intent pipeline; Description=Add guarded lazy registrations for parser, validator, repair, service, and controller, preserving existing 001 registrations; Files touched=`systems/project_management/lib/core/di/project_management_locator.dart`; Dependencies=T032,T033,T034,T035,T036; Acceptance check=DI resolves the full intent pipeline and existing free-text registration remains untouched; Execution=automated; CI=CI-safe.

---

## M6 - Dev-only Intent Debug screen

**Milestone goal**: Add a dev-only UI showing every stage of the Intent path. M6 requires M5 service and must not link from the production chat flow.

- [ ] T038 [P] [US1] Add Intent Debug flag in `systems/project_management/lib/features/ai_assistant/local_slm/poc_demo_flags.dart`
  - Metadata: Milestone=M6; Title=Add debug flag; Description=Add an additive Dart define or debug flag for revealing the Intent Debug screen, reusing the existing flag style; Files touched=`systems/project_management/lib/features/ai_assistant/local_slm/poc_demo_flags.dart`; Dependencies=T009; Acceptance check=flag defaults to off and does not change production AI Assistant behavior; Execution=automated; CI=CI-safe.

- [ ] T039 [P] [US1] Create debug widget tests in `systems/project_management/test/features/ai_assistant/intent/intent_debug_view_test.dart`
  - Metadata: Milestone=M6; Title=Add intent_debug_view_test; Description=Test with the shared fakes (T031a) that the screen renders question input, trimmed context, raw output, parsed Intent JSON, validation errors, repair result, latency, loading, and error states; Files touched=`systems/project_management/test/features/ai_assistant/intent/intent_debug_view_test.dart`; Dependencies=T036,T031a; Acceptance check=widget tests use the shared fakes and no real inference; Execution=automated; CI=CI-safe.

- [ ] T040 [US1] Implement debug screen in `systems/project_management/lib/features/ai_assistant/intent/view/intent_debug_view.dart`
  - Metadata: Milestone=M6; Title=Implement Intent Debug view; Description=Build the dev-only screen with typed question input and six panels: trimmed schema context, raw output, parsed Intent JSON, validation errors, repair result, and latency; the harness run path emits the `[AI_INTENT]`/`[AI_SCHEMA]`/`[AI_GEN]`/`[AI_VALIDATION]`/`[AI_REPAIR]` terminal logs (debug/POC only) so a developer can also trace runs in the terminal; Files touched=`systems/project_management/lib/features/ai_assistant/intent/view/intent_debug_view.dart`; Dependencies=T036,T038,T039; Acceptance check=`intent_debug_view_test` passes, UI does not expose clickable clarification handling, and terminal logs are emitted only in debug/POC mode; Execution=automated; CI=CI-safe with fakes, real model manual-only.

- [ ] T041 [US1] Add a standalone dev-only Intent Debug entry behind a POC flag in `systems/project_management/lib/features/ai_assistant/intent/view/intent_debug_launcher.dart`
  - Metadata: Milestone=M6; Title=Wire standalone debug-only entry; Description=Expose the Intent Debug screen via a **standalone** dev-only launcher/route gated by the POC flag (T038), so the production `ai_assistant_view.dart`/`AiAssistantBody`/`AiInferenceController`/free-text path is **not modified**; Files touched=`systems/project_management/lib/features/ai_assistant/intent/view/intent_debug_launcher.dart`; Dependencies=T040,T038; Acceptance check=the Intent Debug screen is reachable only when the POC flag is on, no production-facing 001 file is changed, and existing 001 chat widget tests still pass; Execution=automated; CI=CI-safe with widget tests. **If touching a production file ever proves unavoidable, the change MUST be purely additive, flag-off behavior MUST be byte-identical to current behavior, a widget test MUST prove flag-off renders the existing AI Assistant view unchanged, and existing 001 chat tests MUST still pass.**

---

## M7 - Golden set + scorecard

**Milestone goal**: Measure POC quality on device and record the Go/No-Go decision. M7 depends on M2-M6.

- [ ] T042 [P] [US5] [US4] Create golden set asset in `systems/project_management/test/features/ai_assistant/intent/golden/intent_golden_set.json`
  - Metadata: Milestone=M7; Title=Create golden set; Description=Add at least 50 questions covering Arabic, English, mixed, high-risk, delayed, status, owner, department, due-soon, count/list/summarize, ambiguous, and unsupported categories with expected status/intent fields; Files touched=`systems/project_management/test/features/ai_assistant/intent/golden/intent_golden_set.json`; Dependencies=T009,T013; Acceptance check=file has >=50 items and at least one item per required category; Execution=manual-prep plus CI fixture validation; CI=CI-safe as static asset.

- [ ] T043 [P] [US5] Implement metrics and scorecard types in `systems/project_management/lib/features/ai_assistant/intent/intent_metrics.dart`
  - Metadata: Milestone=M7; Title=Implement scorecard metrics; Description=Add per-run `IntentMetric`, aggregate `Scorecard`, per-category scoring, repair-rate, validity-rate, intent-match-rate, and latency P50/P90 calculations; Files touched=`systems/project_management/lib/features/ai_assistant/intent/intent_metrics.dart`; Dependencies=T024,T035; Acceptance check=metrics can score scripted run outputs deterministically; Execution=automated; CI=CI-safe.

- [ ] T044 [US5] Add scorecard coverage to `systems/project_management/test/features/ai_assistant/intent/intent_service_test.dart`
  - Metadata: Milestone=M7; Title=Test scorecard integration; Description=Extend the shared-fake service tests to verify golden-like run output can be converted into metrics and a scorecard without invoking real inference; Files touched=`systems/project_management/test/features/ai_assistant/intent/intent_service_test.dart`; Dependencies=T043,T031a; Acceptance check=CI verifies scorecard math over scripted outputs from the shared fakes; Execution=automated; CI=CI-safe.

- [ ] T045 [US5] Run the full golden set manually on Samsung Galaxy S22 Ultra and record scorecard in `specs/002-slm-db-schema-intent-json/research.md`
  - Metadata: Milestone=M7; Title=Manual golden-set run; Description=Run all golden questions through the real on-device current Qwen2.5 1.5B pipeline, collect parse validity, intent match, repair rate, language handling, latency P50/P90, and per-category results; confirm the `[AI_*]` terminal logs (model/active-model status, schema load, SchemaGraph parse, trim summary, prompt size, generation, raw output, parsed Intent, validation, repair, scorecard summary) are visible and greppable during the run; Files touched=`specs/002-slm-db-schema-intent-json/research.md`; Dependencies=T037,T040,T041,T042,T043,T044; Acceptance check=research.md contains a dated scorecard for >=50 questions from S22 Ultra and notes that debug/POC terminal logs were available during manual validation; Execution=manual; CI=manual-only.

- [ ] T046 [US5] Record Go/No-Go and 001 regression smoke result in `specs/002-slm-db-schema-intent-json/research.md`
  - Metadata: Milestone=M7; Title=Record final POC decision; Description=Record whether the POC meets SC-004/SC-007/SC-009, confirm no SQL/DB path was introduced, and document the existing 001 free-text chat smoke result; Files touched=`specs/002-slm-db-schema-intent-json/research.md`; Dependencies=T045; Acceptance check=research.md contains final Go/No-Go, free-text chat regression outcome, and any follow-up model/context recommendation; Execution=manual; CI=manual-only.

---

## Dependencies & Execution Order

### Milestone dependencies

- M0 blocks M2+ pipeline implementation. Do not start or merge M2, M3, M4, M5, M6, or M7 implementation before T009 records G-M0.
- M1 hardens the off-device export and finalizes the reviewed asset. The CI fixture (T014) now derives from the **M0 sample (T003)**, so M2 loader/test work can begin right after G-M0 without waiting for full M1 hardening; the fixture is refreshed from the reviewed asset (T013) once M1 is complete.
- M2 depends on M0 (G-M0) and the T014 fixture. `schema_graph.dart` (T015) is a pure value type and depends only on T009 (data-model/contract), **not** on the finalized M1 asset. M2 `SchemaGraph` is required for M3 trimmer and M5 validator.
- **Cross-cutting (debug logging)**: T015a (logger) is created in M2 and consumed by SchemaLoader, SchemaContextTrimmer, IntentPromptBuilder, IntentGenerationStrategy, IntentValidator, IntentRepair, IntentService, and the Intent Debug harness. T035a tests the logger's release/disabled gating and behavior-neutrality. Logging is debug/POC-only and never gates CI.
- **Shared fakes**: T031a (M5) provides `FakeLocalSlmService` + `FakeIntentGenerationStrategy`; implement it before its consumers (T030, T031, T034, T035, T039, T044). It depends only on T024/T026, never on the tests that use it.
- M3 depends on M2 and the M0 measured context budget. M3 trimmer is required for M4 prompt building.
- M4 depends on M3 and the M0 generation-path decision. M4 generation is required for M5 repair flow.
- M5 depends on M2 SchemaGraph and M4 generation. M5 is required for M6 debug screen.
- M6 depends on M5 service/controller.
- M7 depends on M2-M6 and is manual-only for real model accuracy/latency.

### Safe parallel opportunities

- After T009, M1 SQL/README work should stay serialized where it touches `tools/schema_export/export_projects_schema.sql`.
- T014 (CI fixture) can be prepared from the M0 sample (T003) right after G-M0, then refreshed after T013; this lets M2 begin without waiting for full M1 hardening.
- T015 (SchemaGraph types) and T015a (logger) can run in parallel after T009; T016 (loader tests) runs after T014.
- T022, T023, and T024 can run in parallel after T009, but T025 still depends on M3 trimming.
- T028, T029, T030, and T031 can be drafted in parallel once their listed dependencies exist; **T031a (shared fakes) must be implemented before the tests that consume it.**
- T035a (logger test) can run in parallel after T015a.
- T038 and T039 can run in parallel after M5 controller work is available.
- T042 and T043 can run in parallel after the pipeline contracts are stable.
- The four DI-registration tasks (T018, T021, T027, T037) all edit `project_management_locator.dart` and are intentionally **not** marked `[P]`; keep them serialized.

### CI-safe test set

- `systems/project_management/test/features/ai_assistant/intent/schema_loader_test.dart`
- `systems/project_management/test/features/ai_assistant/intent/schema_context_trimmer_test.dart`
- `systems/project_management/test/features/ai_assistant/intent/intent_parser_test.dart`
- `systems/project_management/test/features/ai_assistant/intent/intent_validator_test.dart`
- `systems/project_management/test/features/ai_assistant/intent/intent_repair_test.dart`
- `systems/project_management/test/features/ai_assistant/intent/intent_service_test.dart` with the shared `FakeLocalSlmService`
- `systems/project_management/test/features/ai_assistant/intent/intent_debug_view_test.dart`
- `systems/project_management/test/features/ai_assistant/intent/intent_debug_log_test.dart`
- Shared fakes: `systems/project_management/test/features/ai_assistant/intent/fakes/` (`FakeLocalSlmService`, `FakeIntentGenerationStrategy`) — no real `flutter_gemma`

### Manual-only validation

- Running the SQL Server export against a real database.
- Sensitive-field review of the exported JSON.
- M0 context/token-budget measurement on Samsung Galaxy S22 Ultra.
- Strict JSON vs structured-output comparison with the real current Qwen2.5 1.5B model.
- Full golden-set accuracy and latency run on Samsung Galaxy S22 Ultra.
- Confirming the debug/POC `[AI_*]` terminal logs are visible and greppable during manual S22 Ultra validation.
- Final Go/No-Go and keep-current-model/fallback-needed decision.

---

## Implementation Strategy

1. Complete M0 first and stop if G-M0 is not recorded as passed.
2. Complete M1 asset/script hardening so M2 has a real or representative contract-compliant input (M2 fixture work may begin from the M0 sample in parallel).
3. Create the shared debug logger (T015a) and shared test fakes (T031a) early so every component can wire logging and every test can reuse the fakes.
4. Build the CI-safe pipeline in order: M2 loader, M3 trimmer, M4 prompt/generation, M5 parser/validator/repair/service — each wiring its `[AI_*]` debug-only logs.
5. Add M6 debug UI only after the service is test-covered with fakes.
6. Run M7 manually on Samsung Galaxy S22 Ultra and record the scorecard and Go/No-Go.

**Modify-list reconciliation**: consistent with `plan.md`'s "Modify (minimal)" list (`project_management_locator.dart`, `pubspec.yaml`, `poc_demo_flags.dart`), the Intent Debug entry (T041) is now a **standalone** dev-only launcher and does **not** modify `ai_assistant_view.dart` or any other 001 production file. New on-device files added by these edits: `intent/intent_debug_log.dart` and `intent/view/intent_debug_launcher.dart`.

## Extension Hooks

**Optional Pre-Hook**: git  
Command: `/speckit-git-commit`  
Description: Auto-commit before task generation

Prompt: Commit outstanding changes before task generation?  
To execute: `/speckit-git-commit`

**Optional Hook**: git  
Command: `/speckit-git-commit`  
Description: Auto-commit after task generation

Prompt: Commit task changes?  
To execute: `/speckit-git-commit`
