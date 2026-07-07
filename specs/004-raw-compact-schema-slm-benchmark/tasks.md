---

description: "Task list for Raw No-Terms Compact Schema SLM Benchmark"
---

# Tasks: Raw No-Terms Compact Schema SLM Benchmark

**Input**: Design documents from `/specs/004-raw-compact-schema-slm-benchmark/`

**Prerequisites**: plan.md, spec.md, research.md, data-model.md, contracts/, quickstart.md

**Tests**: Included — the spec/plan explicitly request lightweight, **inference-free** unit tests
(prompt builder, loader, question set). No automated inference-correctness tests (human-judged per SC-002/SC-005).

**Organization**: Tasks are grouped by user story (US1 = run a question; US2 = record/compare six).

## Format: `[ID] [P?] [Story] Description`

- **[P]**: Can run in parallel (different files, no dependencies)
- **[Story]**: US1 / US2 (Setup, Foundational, Polish have no story label)
- All paths are relative to repo root `/Users/macbook/StudioProjects/eco-system-mobile/`

## Scope Guardrails (apply to EVERY task)

Every task below MUST preserve these non-goals. If a task seems to require any of them, STOP — it is out of scope:

- ❌ No production Flutter assistant behavior · ❌ No SQL generation/execution · ❌ No DB connection
- ❌ No backend calls · ❌ No MCP · ❌ No system routing / per-system schema selection
- ❌ No lookup values · ❌ No business terms · ❌ No validation / parsing / repair
- ❌ No candidate retrieval · ❌ No QuerySpec · ❌ No JSON intent pipeline
- ❌ No changes to Spec 001 / 002 / 003 files
- ✅ Everything gated behind `kRawSchemaBenchmarkEnabled` (default `false`); raw output shown as-is

**Paths**: Flutter module `systems/project_management/`. Benchmark building blocks live in a NEW
isolated folder `systems/project_management/lib/features/ai_assistant/benchmark/`; tests in
`systems/project_management/test/features/ai_assistant/benchmark/`. The experiment runs through the
**existing chat screen** — the only production UI edit is a **flag-gated** hook in
`systems/project_management/lib/features/ai_assistant/widgets/ai_assistant_body.dart` (T011/T012).

---

## Phase 1: Setup (Shared Infrastructure)

**Purpose**: Declare the input asset and the dev-only gate; no behavior yet.

- [X] T001 Add the compact schema asset declaration `- assets/ai/schema/nawah_compact_schema_no_terms.slim.v1.txt` under the existing `flutter: assets:` list in `systems/project_management/pubspec.yaml` (additive only; do not remove existing asset lines).
- [X] T002 [P] Create the dev-only flag `const bool kRawSchemaBenchmarkEnabled = false;` (with a doc comment stating it is DEV-ONLY, default off, and that the benchmark is inert unless enabled) in `systems/project_management/lib/features/ai_assistant/benchmark/raw_schema_benchmark_flags.dart`.

**Checkpoint**: Asset is bundled and the dev gate exists (default off).

---

## Phase 2: Foundational (Blocking Prerequisites)

**Purpose**: The pure, story-agnostic building blocks reused by both user stories. Tests are written FIRST (expected to fail until the implementation task lands).

**⚠️ CRITICAL**: No user story (Phase 3+) can begin until this phase is complete.

- [X] T003 [P] Write `benchmark_questions_test.dart` asserting the question set has **exactly six** entries stored **verbatim** (Arabic/English preserved, in order) in `systems/project_management/test/features/ai_assistant/benchmark/benchmark_questions_test.dart`. Expected values:
  1. `مشاريع عالية الخطورة`
  2. `give me low priorities projects`
  3. `what is the budget of أتمتة العقود والقوانين`
  4. `من المسؤول عن مشروع مختبر التميز المؤسسي`
  5. `اكثر المشاريع تقدما من حيث المخرجات`
  6. `ما وصف اجتماع لجنة المتابعة`
- [X] T004 [P] Implement the six benchmark questions as immutable constants (id 1..6 + verbatim text; no normalization/translation) making T003 pass, in `systems/project_management/lib/features/ai_assistant/benchmark/benchmark_questions.dart`.
- [X] T005 [P] Write `compact_schema_loader_test.dart` asserting the loader returns **non-empty** raw text and a positive char count from the bundled asset (uses the Flutter test asset bundle) in `systems/project_management/test/features/ai_assistant/benchmark/compact_schema_loader_test.dart`.
- [X] T006 [P] Implement `Future<String> loadCompactSchema()` that loads **only** `assets/ai/schema/nawah_compact_schema_no_terms.slim.v1.txt` via `rootBundle.loadString` and returns the raw text **unchanged** (no parsing, no validation) in `systems/project_management/lib/features/ai_assistant/benchmark/compact_schema_loader.dart`.
- [X] T007 [P] Write `benchmark_prompt_builder_test.dart` (per `contracts/prompt.contract.md`) asserting the built prompt: (a) embeds the schema text **verbatim**; (b) embeds the question text **verbatim**; (c) contains all six section labels `Table(s):`,`Column(s):`,`Relationship(s):`,`Filter(s):`,`Sort(s):`,`Entity(s):` **in order**; (d) contains an explicit **prohibition** against SQL and JSON output; (e) contains the raw-phrase-preservation rule and the no-lookup-normalization / no-invented-values rule; (f) does **not** contain any directive to *generate* SQL or JSON; (g) is **deterministic** (identical output for identical inputs); (h) contains **no** few-shot examples. File: `systems/project_management/test/features/ai_assistant/benchmark/benchmark_prompt_builder_test.dart`.
- [X] T008 Implement the **pure** function `String buildBenchmarkPrompt({required String compactSchema, required String question})` per `contracts/prompt.contract.md` (fixed instruction block → `SCHEMA:` + verbatim schema → `QUESTION:` + verbatim question → `ANSWER:` cue), making T007 pass, in `systems/project_management/lib/features/ai_assistant/benchmark/benchmark_prompt_builder.dart`. No I/O, no lookup values, no business terms, no few-shot examples.
- [X] T009 [P] Implement the dev-only in-memory result holder `BenchmarkResultRecord` with fields: `questionId`, `questionText`, `schemaCharCount`, `promptCharCount`, `estimatedTokens` (nullable), `rawOutput`, `latencyMs` — no persistence, and **must not** reuse production `PocMetric` — in `systems/project_management/lib/features/ai_assistant/benchmark/benchmark_result_record.dart`.

**Checkpoint**: Questions, loader, prompt builder, and result record exist and their unit tests pass.

---

## Phase 3: User Story 1 - Run a question through the raw benchmark (Priority: P1) 🎯 MVP

**Goal**: Through the **existing chat screen**, send one question and display the raw SLM output verbatim as the assistant message, with benchmark metrics logged (and optionally shown).

**Independent Test**: With `kRawSchemaBenchmarkEnabled = true` and a model loaded, type one of the six questions into the **normal chat input** and send → the raw SLM text appears verbatim as the assistant reply, and schema chars / prompt chars / estimated tokens / latency are logged.

### Implementation for User Story 1

- [X] T010 [US1] Implement `RawSchemaBenchmarkRunner` that: calls `loadCompactSchema()` (T006) → `resetSession()` → `buildBenchmarkPrompt(...)` (T008) → runs **`generateText()`** (single-shot, per plan D2) → measures wall-clock `latencyMs` → returns a `BenchmarkResultRecord` (T009) with the **raw** output and char/estimated-token counts. Reuses the DI-registered `LocalSlmService`; no new inference engine; no parsing/validation/repair. File: `systems/project_management/lib/features/ai_assistant/benchmark/raw_schema_benchmark_runner.dart`. *(Includes the additive `resetSession()` hardening on `LocalSlmService` / `FlutterGemmaLocalSlmService`.)*
- [X] T011 [US1] Wire `RawSchemaBenchmarkRunner` into the **existing chat send flow** behind the flag: in `systems/project_management/lib/features/ai_assistant/widgets/ai_assistant_body.dart` (`_onSend` / `_sendLocal`, ~lines 189/280), when `kRawSchemaBenchmarkEnabled` is `true`, bypass the normal assistant pipeline (do **not** call the online flow or `AiInferenceController`/JSON-intent path) and instead wrap the typed text as a `BenchmarkQuestion` and call `RawSchemaBenchmarkRunner.run(...)`. When the flag is `false`, behavior is **unchanged**. No new page, no new route, no debug button.
- [X] T012 [US1] In the **existing chat messages UI** (`ai_assistant_body.dart`), render `RawSchemaBenchmarkRunner`'s `rawOutput` **verbatim** as the assistant message (normal Flutter text rendering, Arabic-safe) — no parsing/transforming/wrapping. Log the benchmark metrics (`schemaCharCount`, `promptCharCount`, `estimatedTokens`, `latencyMs`) to the dev log, and **optionally** show them in a small debug text area; the assistant message itself must stay the raw output only.

**Checkpoint**: US1 is functional — sending one question in the normal chat shows the raw output as the assistant reply with metrics logged.

---

## Phase 4: User Story 2 - Record and compare results across the six questions (Priority: P2)

**Goal**: Run all six questions through the normal chat input and capture their raw outputs + a simple per-question comparison for manual scoring.

**Independent Test**: Type each of the six questions into the **normal chat input** in turn; each send produces a fresh-session run (via T010's `resetSession()`) and a raw assistant reply, and the reviewer records them without any automated validation.

### Implementation for User Story 2

- [ ] T013 [US2] Run **all six** benchmark questions **manually through the existing chat input** (one send per question; each is a fresh session via `resetSession()` inside `RawSchemaBenchmarkRunner`). No batch UI, no dev page — this is a manual sequence through the normal chat screen; each raw assistant reply + its logged metrics is the recorded data point.
- [ ] T014 [US2] Manual comparison only: the reviewer records per-question notes/judgements in the manual run report (see T018). **Do not auto-detect sections, do not parse output, do not compute correctness** in code. (Optional: the small debug metrics area from T012 may aid the reviewer, but all judgements are manual.)
- [X] T015 [US2] Confirm/refresh the manual scorecard and summary tables in `specs/004-raw-compact-schema-slm-benchmark/quickstart.md` so they match the final metric fields (question set, metrics, human-judgement columns) and the chat-screen run flow. Docs only.

**Checkpoint**: All six questions can be run through normal chat and recorded manually.

---

## Phase 5: Polish & Verification (Cross-Cutting)

**Purpose**: Static/unit verification and the manual benchmark run. No production surface touched.

- [X] T016 [P] Run `cd systems/project_management && flutter analyze` and resolve any analyzer issues introduced by the new `benchmark/` files only.
- [X] T017 Run `cd systems/project_management && flutter test test/features/ai_assistant/benchmark/` and confirm all inference-free unit tests (T003/T005/T007 + questions/loader/builder) pass.
- [ ] T018 Manual on-device benchmark: with `kRawSchemaBenchmarkEnabled = true` and a model loaded, run all six questions **through the normal chat input** on a mobile device. Record raw outputs + metrics + human judgements in a **manual run report**, e.g. `specs/004-raw-compact-schema-slm-benchmark/manual-results/benchmark_run_<date>.md`, or an external team note. **Keep `quickstart.md` as the template/instructions (do not write raw run outputs into it).** Do not commit raw run outputs unless explicitly requested. (Manual; no automated correctness assertions.)
- [ ] T019 Non-goals guard review: grep the new `benchmark/` folder to confirm it introduces no SQL/JSON-intent/DB/backend/MCP/routing/QuerySpec/validation code and no edits outside the benchmark folder + the single pubspec asset line; confirm `kRawSchemaBenchmarkEnabled` defaults to `false` and the app is inert when off.

---

## Dependencies & Execution Order

### Phase Dependencies

- **Setup (Phase 1)**: no dependencies — start immediately.
- **Foundational (Phase 2)**: depends on Setup (needs the asset from T001 and the flag from T002); **blocks all user stories**.
- **User Story 1 (Phase 3)**: depends on Foundational (T004, T006, T008, T009) and the flag (T002).
- **User Story 2 (Phase 4)**: depends on US1 (the flag-gated chat send flow being wired).
- **Polish (Phase 5)**: depends on the code under test/verification existing.

### Task-Level Dependencies

- T001, T002 → independent of each other ([P]).
- T003→T004, T005→T006, T007→T008 (test-first pairs). T009 independent.
- T010 depends on T004, T006, T008, T009.
- T011 (chat send-flow wiring) depends on T002, T004, T010. T012 (raw output in chat UI + metrics) depends on T011.
- T013 (manual six-question run through chat) depends on T011, T012. T014 manual notes depend on T013. T015 docs-only (after metric fields finalized in T012).
- T016/T017 after implementation exists; T018 after T012 (and ideally T014); T019 last.

### Parallel Opportunities

- Setup: T002 [P] alongside T001.
- Foundational: the three test tasks T003/T005/T007 are [P] (different files); implementations T004/T006 [P] and T009 [P] (T008 waits on its test T007 being defined).
- Polish: T016 [P] can run alongside test authoring; T017 after impl.

---

## Parallel Example: Foundational (Phase 2)

```bash
# Write the inference-free unit tests together (different files):
Task: "benchmark_questions_test.dart — 6 verbatim questions"
Task: "compact_schema_loader_test.dart — non-empty raw load"
Task: "benchmark_prompt_builder_test.dart — verbatim + ordered sections + SQL/JSON prohibition"

# Then implement the building blocks together (different files):
Task: "benchmark_questions.dart"
Task: "compact_schema_loader.dart"
Task: "benchmark_result_record.dart"
```

---

## Implementation Strategy

### MVP First (User Story 1 only)

1. Phase 1 Setup (T001–T002).
2. Phase 2 Foundational (T003–T009) — building blocks + unit tests green.
3. Phase 3 US1 (T010–T012) — send one question in the normal chat, see raw output + metrics.
4. **STOP and VALIDATE**: send one benchmark question end-to-end through the chat screen on device (flag on).

### Incremental Delivery

1. Setup + Foundational → building blocks ready.
2. US1 → single-question raw benchmark through the normal chat (MVP).
3. US2 → six-question manual run through the chat + manual comparison + scorecard.
4. Polish → analyze, unit tests, manual run, non-goals guard.

---

## Notes

- [P] = different files, no dependency on an incomplete task.
- Benchmark building blocks are isolated in `.../ai_assistant/benchmark/`. Production touch-points: the additive pubspec asset line (T001), the additive `resetSession()` on the SLM service (T010), and the **flag-gated** chat send-flow edit in `widgets/ai_assistant_body.dart` (T011/T012) — inert when the flag is off.
- This is a dedicated **experiment branch**; when `kRawSchemaBenchmarkEnabled` is on, normal chat behavior is intentionally overridden. Default stays **false**; do not enable/merge to production. No production readiness claimed.
- Raw SLM output is shown/recorded verbatim as the assistant chat message; no validation, parsing, or repair (FR-005/FR-010).
- Do not commit as part of these tasks unless explicitly asked.
