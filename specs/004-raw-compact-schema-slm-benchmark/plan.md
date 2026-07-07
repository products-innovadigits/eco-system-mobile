# Implementation Plan: Raw No-Terms Compact Schema SLM Benchmark

**Branch**: `004-raw-compact-schema-slm-benchmark` | **Date**: 2026-07-05 | **Spec**: [spec.md](spec.md)

**Input**: Feature specification from `specs/004-raw-compact-schema-slm-benchmark/spec.md`

## Summary

Build a **dev-only, manual benchmark harness** that feeds one compact schema file plus one
natural-language question to the already-wired local SLM and displays/logs the model's **raw** text
output verbatim. The harness measures the SLM's raw schema-understanding ability only. It performs no
validation, parsing, repair, SQL, DB, backend, MCP, routing, lookup normalization, business terms,
QuerySpec, or JSON intent. All new code is isolated behind a dev-only flag and reuses the existing
`LocalSlmService` invocation point without modifying it.

## Technical Context

**Language/Version**: Dart / Flutter (existing app; `systems/project_management` module)

**Primary Dependencies**: `flutter_gemma: 0.12.6` (local on-device inference, already wired via
`FlutterGemmaLocalSlmService`); Flutter `rootBundle` for asset loading; existing `get_it` DI locator.

**Storage**: N/A — reads one bundled text asset; no database, no persistence. Benchmark results are
recorded manually by a human reviewer (scorecard in `quickstart.md`).

**Testing**: `flutter test` — lightweight unit tests for pure prompt construction / asset loading /
question set. Inference itself is exercised **manually** on-device (not in CI; requires a downloaded
model + capable device).

**Target Platform**: On-device (Android/iOS) via `flutter_gemma`; dev/debug builds only.

**Project Type**: Mobile app (existing), single feature module addition under
`systems/project_management`.

**Performance Goals**: None asserted. Latency is *measured and logged* per run for observation, not
constrained.

**Constraints**: Dev-only (behind a compile-time flag, default off); raw-output-only (no
post-processing); single compact schema file; no production assistant behavior touched.

**Scale/Scope**: 1 compact schema asset, 6 predefined benchmark questions, 1 dev harness, 3 small
unit-test files. No production surface area.

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

The project constitution (`.specify/memory/constitution.md`) is an **unfilled template** — it defines
no ratified, concrete principles or gates. There are therefore no formal gates to evaluate. The plan
nonetheless honors the spirit of scope isolation and simplicity:

- **Isolation**: benchmark building blocks live under a new `.../ai_assistant/benchmark/` folder.
  Production touch-points are minimal and either additive (`resetSession()` on the SLM service; the
  pubspec asset line) or **flag-gated** (the chat send flow in `ai_assistant_body.dart`, inert when the
  flag is off).
- **Simplicity / YAGNI**: pure functions for prompt building and asset loading; no new abstractions
  beyond a thin runner that reuses `LocalSlmService`.
- **No scope creep**: every spec non-goal is preserved (see "Scope Guardrails" below).

**Result**: PASS (no violations; Complexity Tracking table left empty).

## Constraints (Scope Guardrails)

Strict non-goals carried from the spec and re-asserted for implementation:

- This is a dedicated **experiment branch** (`004-raw-compact-schema-slm-benchmark`). The experiment
  runs through the **existing chat screen**; when `kRawSchemaBenchmarkEnabled` is **on**, normal chat
  behavior is **intentionally overridden** to call the benchmark runner. This override is confined to
  this branch and behind the flag (default **off**); **no production readiness is claimed** and the
  change must not be enabled or merged into production chat behavior.
- No SQL generation, no SQL execution.
- No DB connection, no backend call, no MCP.
- No system routing, no per-system schema selection (single compact schema only).
- No lookup values, no business terms / synonym dictionary.
- No validation, no parsing, no repair, no candidate retrieval.
- No QuerySpec, no JSON intent pipeline; the raw SLM text is shown as-is.
- No changes to Spec 001 / 002 / 003 files, research, or milestones.
- The benchmark's own logging (raw output + lengths + latency) is a **dev-only result record**, kept
  separate from the production `PocMetric` telemetry (which forbids prompt/response content).

## Project Structure

### Documentation (this feature)

```text
specs/004-raw-compact-schema-slm-benchmark/
├── spec.md              # Feature spec (already present)
├── plan.md              # This file (/speckit-plan output)
├── research.md          # Phase 0 output
├── data-model.md        # Phase 1 output
├── quickstart.md        # Phase 1 output (manual run flow + scorecard)
├── contracts/
│   ├── benchmark-output.contract.md   # The exact 6-section plain-text output contract
│   └── prompt.contract.md             # Prompt structure contract (schema + question + directive)
└── checklists/
    └── requirements.md  # (already present)
```

### Source Code (repository root)

New, isolated feature folder inside the existing `project_management` system module. **All files are
new** except the single additive pubspec asset declaration.

```text
systems/project_management/
├── pubspec.yaml                        # CHANGE (additive): declare the slim schema asset
├── assets/ai/schema/
│   └── nawah_compact_schema_no_terms.slim.v1.txt   # EXISTING asset (input; unchanged)
├── lib/features/ai_assistant/benchmark/            # NEW — all benchmark-only building blocks
│   ├── raw_schema_benchmark_flags.dart             # dev-only flag (default false)
│   ├── benchmark_questions.dart                    # the 6 predefined questions (verbatim)
│   ├── compact_schema_loader.dart                  # loads the slim asset via rootBundle
│   ├── benchmark_prompt_builder.dart               # pure: schema + question -> prompt string
│   ├── benchmark_result_record.dart                # dev-only result holder (no production telemetry)
│   └── raw_schema_benchmark_runner.dart            # orchestrates load->reset->build->infer->log (reuses LocalSlmService)
├── lib/features/ai_assistant/widgets/
│   └── ai_assistant_body.dart          # CHANGE (flag-gated): when kRawSchemaBenchmarkEnabled, the
│                                       #   existing chat send flow routes the message through the
│                                       #   runner and shows rawOutput as the assistant message
└── test/features/ai_assistant/benchmark/           # NEW — lightweight unit tests
    ├── benchmark_prompt_builder_test.dart
    ├── compact_schema_loader_test.dart
    ├── benchmark_questions_test.dart
    └── raw_schema_benchmark_runner_test.dart
```

**Structure Decision**: Benchmark **building blocks** live in an additive feature folder under
`systems/project_management/lib/features/ai_assistant/benchmark/` (sibling to `local_slm/`). The
experiment is exercised **through the existing chat screen** rather than a separate dev page: when
`kRawSchemaBenchmarkEnabled` is true, the existing chat send flow in `widgets/ai_assistant_body.dart`
routes the typed message through `RawSchemaBenchmarkRunner` and renders the raw output as the assistant
message. When the flag is false, the chat behaves exactly as before. This is acceptable because this is
a dedicated experiment branch (see Constraints); no production readiness is claimed.

## 3. Proposed Files to Create / Change

| File | Action | Purpose |
|------|--------|---------|
| `.../benchmark/raw_schema_benchmark_flags.dart` | create | `const bool kRawSchemaBenchmarkEnabled = false;` dev gate |
| `.../benchmark/benchmark_questions.dart` | create | The 6 questions as verbatim constants |
| `.../benchmark/compact_schema_loader.dart` | create | `Future<String> loadCompactSchema()` via `rootBundle` |
| `.../benchmark/benchmark_prompt_builder.dart` | create | Pure `buildBenchmarkPrompt(schema, question) -> String` |
| `.../benchmark/benchmark_result_record.dart` | create | Holds question, schemaChars, promptChars, estTokens, rawOutput, latencyMs |
| `.../benchmark/raw_schema_benchmark_runner.dart` | create | Orchestrates a single fresh-session run (reset → generate); logs record |
| `.../local_slm/local_slm_service.dart` + `flutter_gemma_local_slm_service.dart` | change (additive) | Added `resetSession()` for fresh one-shot context (done in T010 hardening) |
| `.../widgets/ai_assistant_body.dart` | change (flag-gated) | When `kRawSchemaBenchmarkEnabled`, the existing chat send flow calls the runner and shows `rawOutput` as the assistant message; unchanged when flag off |
| `systems/project_management/pubspec.yaml` | change (additive) | Add `- assets/ai/schema/nawah_compact_schema_no_terms.slim.v1.txt` |
| `test/features/ai_assistant/benchmark/*_test.dart` | create (×4) | Prompt-builder, loader, questions, runner unit tests |

The experiment is run through the **existing chat UI**, not a separate dev page. The chat integration
is a **flag-gated** edit to `ai_assistant_body.dart`: production chat behavior is preserved when the
flag is off; when on (experiment branch only), the send flow is intentionally overridden to call the
runner. The additive pubspec asset line is still required so `rootBundle.loadString` can read the schema.

## 4. Dev-only Flag Name

`kRawSchemaBenchmarkEnabled` — a top-level `const bool` in
`raw_schema_benchmark_flags.dart`, **default `false`**. Follows the existing convention set by
`kPocDemoRealChat` in `poc_demo_flags.dart`. The existing chat send flow checks this flag: when
`true`, a sent message is routed through `RawSchemaBenchmarkRunner` and the raw output is shown as the
assistant reply; when `false`, the benchmark is entirely inert and the chat behaves exactly as it does
in production. The tester flips it to `true` on this experiment branch before running on device.

## 5. Prompt Builder Design

`benchmark_prompt_builder.dart` exposes a **pure** function
`String buildBenchmarkPrompt({required String compactSchema, required String question})` — no I/O, no
model calls, fully unit-testable. The assembled prompt has three fixed parts, in order:

1. **Instruction block** (fixed English text): instructs the model to answer using **only** the
   provided schema and to output **exactly** the six sections, in this order — `Table(s):`,
   `Column(s):`, `Relationship(s):`, `Filter(s):`, `Sort(s):`, `Entity(s):` — each as plain bullet
   lines; express relationships in inline FK form `Parent.Column -> Referenced.Column`; keep the raw
   phrase from the question verbatim in filters; do **not** produce SQL, JSON, normalized lookup
   codes, or invented values.
2. **Schema block**: `SCHEMA:` followed by the compact schema text **verbatim** (no trimming, no
   reformatting).
3. **Question block**: `QUESTION:` followed by the question **verbatim**, then an `ANSWER:` cue.

Design rules: deterministic string assembly (stable ordering/whitespace so tests can assert exact
structure); no examples that would leak lookup values or business terms; the builder never mutates the
schema or question. Generation parameters (e.g. low temperature, `maxTokens`) are passed at the runner
layer, not baked into the prompt.

## 6. Asset Loading Design

`compact_schema_loader.dart` exposes `Future<String> loadCompactSchema()` that reads
`assets/ai/schema/nawah_compact_schema_no_terms.slim.v1.txt` via Flutter `rootBundle.loadString`
(package-scoped asset in the `project_management` module). Requires the additive pubspec asset
declaration. Returns the raw file contents unchanged; exposes the character count to the runner. No
parsing of the schema is performed — it is treated as opaque text.

## 7. Existing SLM Invocation Point to Reuse

Reuse the already-wired abstraction — **do not create a new inference engine**:

- Interface: `LocalSlmService` at
  `systems/project_management/lib/features/ai_assistant/local_slm/local_slm_service.dart`.
- Method: `Future<String> generateText(String prompt, {int maxTokens, Duration? timeout})`
  (a streaming `generate(...)` variant also exists if token-by-token display is wanted).
- Real implementation: `FlutterGemmaLocalSlmService` (opens a session via `openChat` →
  `addUserMessage` → `generateText`), resolved through the existing DI locator
  (`project_management_locator.dart`).

**Fresh one-shot session per question**: the runner calls the additive `LocalSlmService.resetSession()`
(added in T010 hardening) **before** each `generateText()`, so any prior chat history is cleared and
questions cannot bleed into one another. `resetSession()` reopens a fresh chat on the already-loaded
model (no reinstall/download) and does not change `load()`/`generateText()` or production DI.

## 8. Manual Benchmark Flow

1. Developer downloads/loads a local model through the existing local-SLM path (unchanged).
2. Set `kRawSchemaBenchmarkEnabled = true` on this experiment branch, in a debug build.
3. Open the **normal AI-assistant chat screen** (no separate page).
4. Type one of the six benchmark questions into the **existing chat input** and send.
5. The send flow routes the message through the runner: `loadCompactSchema()` → `resetSession()` →
   `buildBenchmarkPrompt(...)` → `generateText(...)` → capture raw output + latency + prompt/schema
   lengths + estimated tokens.
6. The **raw** output is shown as-is as the assistant chat message; metrics are logged (and optionally
   shown in a small debug text area). The assistant message is never parsed or transformed.
7. Developer records raw output + metrics + the four human judgements in a manual run report (per the
   updated tasks; `quickstart.md` remains the template).
8. Repeat for all six questions through the same chat input; compile the single comparison summary. No
   automated scoring occurs.

Logged per run: question, schema char count, prompt length (chars), estimated tokens (heuristic if the
engine exposes no tokenizer), raw output, latency (ms).

## 9. Test Plan

Lightweight, inference-free unit tests (`flutter test`):

- **benchmark_prompt_builder_test.dart**: asserts the built prompt contains all six section labels in
  the required order; embeds the schema text verbatim; embeds the question verbatim; contains the
  inline-FK and raw-phrase directives; contains **no** SQL/JSON directives; is deterministic for the
  same inputs.
- **compact_schema_loader_test.dart**: loads the bundled asset (via test asset bundle), returns
  non-empty content, and reports a positive character count. (Confirms the pubspec declaration is
  effective.)
- **benchmark_questions_test.dart**: asserts exactly six questions, each stored verbatim (Arabic/English
  preserved), matching the spec's benchmark set.

Explicitly **not** tested automatically: actual model inference, output correctness, latency
thresholds — these are manual/human-judged per the spec (SC-002, SC-005).

## 10. Risks and Decisions

*All prior open questions (Q1–Q3) are now resolved as decisions D1–D3 below.*

| # | Risk / Question | Impact | Mitigation / Proposed default |
|---|-----------------|--------|-------------------------------|
| R1 | `flutter_gemma` session may retain context across questions | Cross-question bleed skews results | Use a **fresh session per question** (dispose/reopen or new chat) |
| R2 | Engine may not expose a tokenizer/token count | "estimated tokens" not exact | Log a **char/4 heuristic** clearly labeled "estimated"; note in scorecard |
| R3 | Model may ignore the exact six-section format | Output not in required shape | **Expected** — recorded as a failure note; harness does not repair (per FR-005/FR-010) |
| R4 | Slim asset not bundled | Loader fails at runtime | Additive pubspec asset line (planned change) + loader unit test |
| R5 | Overriding the existing chat send flow when the flag is on | Normal chat behavior changes on this branch | Confine to this **experiment branch**, gate on `kRawSchemaBenchmarkEnabled` (default off), preserve normal behavior when off; do not merge the enabled flag to production |
| D1 | **Decided (revised)** — Entrypoint | Determines how the experiment is reached | Run **inside the existing chat screen**: when `kRawSchemaBenchmarkEnabled = true`, the existing send flow in `widgets/ai_assistant_body.dart` routes the typed message through `RawSchemaBenchmarkRunner` and shows `rawOutput` as the assistant message. **No separate dev page, no debug button/card, no new route.** |
| D2 | **Decided** — Inference call | UX only | Use **single-shot `LocalSlmService.generateText()`** (preceded by `resetSession()`); no streaming for this experiment. |
| D3 | **Decided (revised)** — Output/metrics display | Readability of Arabic output/logs | The assistant chat message is the **raw output verbatim** (normal Flutter text rendering). Metrics (`schemaCharCount`, `promptCharCount`, `estimatedTokens`, `latencyMs`) are **logged**, and may optionally appear in a small debug text area — but never replace or wrap the raw assistant message. |

## 11. Scope Confirmation

This implementation remains **benchmark-only** and **raw-output-only**:

- The harness's sole function is: load one schema → reset session → build one prompt → call the
  existing SLM → show and log the raw response as the assistant chat message. Nothing consumes or
  transforms that response.
- No validation, parsing, repair, SQL, DB, backend, MCP, routing, lookup normalization, business
  terms, QuerySpec, or JSON intent is introduced.
- Production chat behavior is **preserved when `kRawSchemaBenchmarkEnabled` is off**. When on (this
  experiment branch only), the chat send flow is intentionally overridden to call the runner; **no
  production readiness is claimed** and the enabled flag must not reach production.
- Spec 001 / 002 / 003 artifacts are untouched.

## Complexity Tracking

> No constitution violations to justify. Table intentionally empty.

| Violation | Why Needed | Simpler Alternative Rejected Because |
|-----------|------------|-------------------------------------|
| — | — | — |
