# Implementation Plan: Schema-Aware Intent JSON Extraction (Projects POC)

**Branch**: `002-slm-db-schema-intent-json` | **Date**: 2026-06-30 | **Spec**: [spec.md](./spec.md)

**Input**: Feature specification from `specs/002-slm-db-schema-intent-json/spec.md`

> **M0 IS THE GATE.** No full implementation begins until the **M0 Measurement Gate** answers the five questions below. The first two work items are (a) preparing a real (or representative) schema sample asset and (b) running the M0 measurements on a Samsung Galaxy S22 Ultra with the **current Qwen2.5 1.5B** model. Do **not** switch model at the start.

> **Hard boundaries (locked):** No SQL generation · no DB connection from Flutter · no DB retrieval · no MCP · no backend handoff · no Python CLI automation · no clickable clarification UI (deferred to `003-ai-clarification-loop`) · existing 001 free-text local chat must stay **unaffected**. This feature only **adds** a parallel Intent path; it does not modify `LocalSlmService` or `AiInferenceController`.

---

## Summary

Add a schema-aware **Intent JSON** path on top of feature 001's on-device runtime. A **manually executed SQL Server export script** (off-device, read-only, developer-run) produces a reviewed `projects_db_metadata_schema.json` asset. On device, the app loads that asset into a `SchemaGraph`, trims a token-budget-aware schema slice, builds a schema-aware prompt, generates Intent JSON via the existing `LocalSlmService.generateText`, then parses → validates → repairs (one bounded retry). A dev-only Intent Debug screen surfaces every stage, and a ≥50-question golden set produces a scorecard for a Go/No-Go decision. The whole feature is gated by **M0**, which empirically measures whether the current Qwen2.5 1.5B model can handle a depth-2 schema slice and which generation path (strict-JSON prompting vs. structured output) is most reliable.

The Intent layer is **additive and parallel** to 001: a new `intent/` folder beside the existing `local_slm/` folder, a new `IntentInferenceController` that *reuses* (does not modify) `LocalSlmService`, and a dev-only screen reachable only behind a debug flag. Nothing in the existing free-text chat path changes.

---

## Technical Context

**Language/Version**: Dart / Flutter (module `project_management`, Dart SDK `>=3.8.0 <4.0.0`). Off-device export artifact is a **T-SQL script** (SQL Server) — not part of the Flutter build.

**Primary Dependencies**: Existing only — `flutter_gemma` (via the 001 `LocalSlmService`/`FlutterGemmaLocalSlmService`), `get_it` (`projectManagementSl`). No new runtime dependency is required for the Intent path (JSON is parsed with `dart:convert`). **No** SQL client, DB driver, HTTP client, or MCP package is added.

**Storage**: One bundled read-only asset: `assets/ai/schema/projects_db_metadata_schema.json`. No database, no persistence beyond what 001 already does. Golden set + scorecard live as test assets / generated dev output.

**Testing**: `flutter_test` unit/widget tests with **fakes/mocks** for the model (a `FakeLocalSlmService` returning scripted outputs) so CI never runs real inference. Golden-set accuracy + latency are measured **manually on-device**, not in CI.

**Target Platform**: Android first; reference evaluation device **Samsung Galaxy S22 Ultra**. Reuses 001's device/runtime assumptions.

**Project Type**: Mobile (Flutter multi-module monorepo). Intent path lives in the `project_management` system module beside the existing `ai_assistant` feature.

**Performance Goals**: POC-grade. Target an Intent JSON round-trip that is usable for evaluation on the S22 Ultra (record actual latency; no hard SLA in this POC). No UI freeze (inference already runs in `flutter_gemma`'s isolate). M0 establishes the realistic latency baseline.

**Constraints**: Trimmed schema slice + prompt must fit the **empirically measured** context window of the current Qwen2.5 1.5B build (M0). `maxLookupRows` default 50. One bounded repair retry. Offline; no network from the Intent path.

**Scale/Scope**: Single domain (projects), **single root table** in v1, FK depth 2 with depth-1 fallback. One dev-only debug screen. ≥50 golden questions. 2 components (off-device export script + on-device pipeline).

---

## Constitution Check

*GATE: Must pass before Phase 0. Re-check after Phase 1 design.*

The project constitution at `.specify/memory/constitution.md` is an **unfilled template** (no ratified principles), so the gate is **non-binding** — identical situation to feature 001. We adopt these self-imposed gates, consistent with the spec's hard boundaries:

- **Additive-only**: do not modify `LocalSlmService`, `AiInferenceController`, or the existing chat UI. The Intent path is a new parallel folder + a dev-only screen. ✅ planned.
- **Reuse, don't fork**: Intent generation calls the existing `LocalSlmService.generateText`; no second runtime. ✅ planned.
- **No secrets / no live data on device**: schema asset is denylist-filtered and manually reviewed; no credentials, no DB connection, no real rows. ✅ enforced.
- **Scope discipline**: no SQL, no retrieval, no MCP, no backend, no Python CLI, no clarification UI. ✅ enforced as FR-026/FR-027.
- **Measurement-first**: M0 precedes implementation. ✅ this plan's ordering.

No violations → **Complexity Tracking left empty**.

---

## Project Structure

### Documentation (this feature)

```text
specs/002-slm-db-schema-intent-json/
├── plan.md              # This file
├── spec.md              # Feature spec (Intent JSON contract authoritative)
├── research.md          # Phase 0 — M0 measurement design + generation-path decision
├── data-model.md        # Phase 1 — SchemaGraph + Intent JSON entities/contracts
├── quickstart.md        # Phase 1 — how to run M0, export schema, eval golden set on S22 Ultra
├── contracts/
│   ├── schema_metadata_contract.md   # JSON asset contract (3 sections + provenance)
│   └── intent_json_contract.md       # Intent JSON + clarification_options contract
└── checklists/
    └── requirements.md  # Spec quality checklist (already passing)
```

### Source Code (repository root)

New on-device code is **additive**, in a new `intent/` folder beside the existing `local_slm/` folder; existing files are untouched.

```text
systems/project_management/
├── lib/features/ai_assistant/
│   ├── local_slm/                                  # EXISTING (001) — UNTOUCHED
│   │   ├── local_slm_service.dart                  # reused as-is (generateText)
│   │   ├── ai_inference_controller.dart            # free-text path — UNTOUCHED
│   │   └── ...                                      # everything else unchanged
│   └── intent/                                      # NEW (002)
│       ├── schema_graph.dart                       # SchemaGraph + TableNode/ColumnNode/FkEdge/LookupSet
│       ├── schema_loader.dart                      # loads+validates schema asset → SchemaGraph
│       ├── schema_context_trimmer.dart             # token-budget slice (depth 2 → depth 1 fallback)
│       ├── intent_prompt_builder.dart              # system + trimmed schema + question (AR/EN/mixed)
│       ├── intent_generation_strategy.dart         # StrictJson | StructuredOutput selectable path
│       ├── intent_service.dart                     # orchestrates generate→parse→validate→repair
│       ├── intent_inference_controller.dart        # dev entry point (reuses LocalSlmService)
│       ├── intent_model.dart                       # Intent, Filter, Relationship, ClarificationOption…
│       ├── intent_parser.dart                      # raw text → Intent (tolerant JSON extraction)
│       ├── intent_validator.dart                   # schema-grounded validation rules
│       ├── intent_repair.dart                      # one bounded repair retry (re-prompt with errors)
│       ├── intent_metrics.dart                     # per-run latency/validity/repair/lang record
│       └── view/intent_debug_view.dart             # NEW dev-only screen (behind debug flag)
├── lib/core/di/project_management_locator.dart     # EXISTING — add lazy registrations (guarded)
├── assets/ai/schema/
│   └── projects_db_metadata_schema.json            # NEW — reviewed export output (committed)
├── assets/ai/prompts/
│   └── intent_system_instruction.txt               # NEW — Intent system prompt (AR/EN)
└── test/features/ai_assistant/intent/              # NEW unit/widget tests
    ├── schema_loader_test.dart
    ├── schema_context_trimmer_test.dart
    ├── intent_parser_test.dart
    ├── intent_validator_test.dart                  # hallucination + SQL-fragment cases
    ├── intent_repair_test.dart
    ├── intent_service_test.dart                    # FakeLocalSlmService scripted outputs
    ├── intent_debug_view_test.dart                 # widget test, fake service
    └── golden/intent_golden_set.json               # ≥50 questions + expected outcomes

tools/schema_export/                                # NEW — OFF-DEVICE, not in Flutter build
├── export_projects_schema.sql                      # the manual T-SQL export script
└── README.md                                       # how to run, set root table, denylist, review
```

**Structure Decision**: Keep the Intent path inside the `project_management` module under a **new `intent/` folder** (parallel to `local_slm/`) so it reuses the existing `projectManagementSl` DI and the already-wired `LocalSlmService`, while leaving all 001 files byte-for-byte unchanged. The export script lives under a top-level `tools/` directory and is explicitly excluded from the app bundle (only its reviewed JSON output is committed into assets).

---

## Phase −1 (DO FIRST) — Schema Sample Preparation + M0 Measurement Gate

> These two precede everything. No pipeline implementation lands before M0's decision is recorded in [research.md](./research.md).

### Step A — Schema sample preparation (unblocks M0 and all on-device work)
1. Author `tools/schema_export/export_projects_schema.sql` (manual discovery query + chosen-root variable + FK-depth-2 traversal + capped lookups + denylist).
2. Run it read-only on SQL Server (or, if DB access is not yet available, hand-author a **representative** sample that matches the contract) and produce `projects_db_metadata_schema.json`.
3. Manually review → confirm zero denylisted/sensitive fields → commit to `assets/ai/schema/`.
   - *Rationale*: M0 needs a realistic schema to measure context size; the on-device pipeline needs the asset to exist.

### Step B — M0 measurement (mandatory gate, current Qwen2.5 1.5B, on S22 Ultra)
M0 must answer, with recorded numbers, the five questions:

| # | Question | How M0 answers it |
|---|----------|-------------------|
| 1 | Can current Qwen2.5 1.5B handle the trimmed project schema context? | Feed depth-2 and depth-1 slices + a sample question; record whether it returns coherent, parseable Intent JSON. |
| 2 | Does FK depth 2 fit the prompt/context budget? | Measure token estimate of the depth-2 slice + system prompt + question against the model's measured `ekv`/context window; record fit/no-fit. |
| 3 | If depth 2 is too large, what fallback? | Apply, in order: **compact formatting** → **reduce lookup caps** → **depth-1 prompt slice**. Record which step first makes it fit. Model/context change is fallback-only and **out of scope unless clearly required**. |
| 4 | Strict-JSON prompting vs. function-calling/structured output — which is more reliable? | Run the same N questions through both paths (if the runtime exposes structured output); compare parse-success and schema-validity rates. |
| 5 | What generation path for the rest of the feature? | Choose the winner of #4 as the default `IntentGenerationStrategy`; record the decision + thresholds. |

**M0 exit criteria (Decision Gate G-M0):**
- A schema slice (depth 2, or the first fallback that fits) demonstrably fits the context budget.
- A generation path is selected with measured parse-success ≥ a recorded threshold on the M0 probe set.
- Decision recorded: **keep current model** (default) vs. *flag* a larger-context build as a later fallback **only if** depth-1 + compact + reduced caps still fails. Per the spec, do not switch model at the start.

If G-M0 fails outright (no slice fits, no path parses), stop and escalate before building the full pipeline.

---

## Phase 0 — Research (research.md)

Consolidates the M0 design and the open technical decisions:
- Token-budget estimation approach for on-device (heuristic char/token ratio vs. any available tokenizer) and the chosen compact schema serialization format.
- Strict-JSON prompting technique (delimited JSON, stop sequences, `maxTokens` sizing) vs. structured-output/function-calling availability in `flutter_gemma` for Qwen.
- Tolerant JSON extraction strategy for small-model output (fenced-block stripping, first-balanced-object extraction) before declaring a parse failure.
- Repair-prompt design (feed `validation_errors` back, one retry).
- Representative-schema authoring guidance if live DB access lags.

**Output**: `research.md` with Decision / Rationale / Alternatives for each, plus the recorded M0 plan and G-M0 thresholds.

---

## Phase 1 — Design & Contracts

### Data model (data-model.md)
- **SchemaGraph** (in-memory): `tables: Map<String,TableNode>`, FK adjacency, lookup sets. `TableNode{name, columns[], primaryKey[], foreignKeys[]}`, `ColumnNode{name, dataType, nullable, isLookup}`, `FkEdge{fromTable, fromColumns, toTable, toColumns}`, `LookupSet{table, column, values[] (≤ cap)}`. Helpers: `hasTable`, `hasColumn`, `fkPathExists(a,b)`, `operatorAllowed(column, op)`, `lookupHasValue(table,col,value)`, `neighbors(table, depth)`.
- **Intent** + nested types (`Filter{table,column,operator,value}`, `Relationship{fromTable,toTable}`, `Aggregation`, `DateRange`, `Sort`, `ClarificationOption{id,type,table,displayLabel{ar,en},reason,confidence}`, `ValidationError{code,reference,message}`) — exactly mirroring the spec's Intent JSON Contract.
- **GoldenSetItem** `{id, question, language, category, expected: {status,intent,...} | unsupported | needs_clarification}`.
- **Scorecard** aggregate `{validityRate, intentMatchRate, repairRate, latencyP50/P90, perCategory[]}`.

### Contracts (contracts/)
1. `schema_metadata_contract.md` — the asset's stable JSON shape: top-level `schema_version`, `generated_at`, `root_table`, `extraction_summary{depth, max_lookup_rows, samples_enabled, denylist_applied}`, and three sections `schema_metadata`, `lookup_values`, `sample_values?`. Designed for future multi-root (`roots[]` reserved) without breaking the parser.
2. `intent_json_contract.md` — the Intent JSON + `clarification_options` shape, enumerated value domains, and the validator rule table (table/column/FK/operator/lookup/no-SQL/no-unknown-ref → which `status` + `validation_errors` code).

### Generation path (selectable)
`IntentGenerationStrategy` interface with `StrictJsonStrategy` (default unless M0 says otherwise) and an optional `StructuredOutputStrategy`. Both consume the trimmed prompt and call `LocalSlmService.generateText`; the chosen one is wired via DI from the M0 decision.

### DI
Register (guarded by the existing `isRegistered` pattern, lazy singletons) in `project_management_locator.dart`: `SchemaLoader`, `SchemaContextTrimmer`, `IntentPromptBuilder`, the selected `IntentGenerationStrategy`, `IntentParser`, `IntentValidator`, `IntentRepair`, `IntentService`, `IntentInferenceController`, `IntentMetrics`. **No changes** to existing 001 registrations.

### Dev-only entry
`intent_debug_view.dart` is reachable only behind a debug flag (reuse the existing `poc_demo_flags.dart` style); it is **not** linked from the production chat flow.

**Output**: `data-model.md`, `contracts/*`, `quickstart.md`, updated agent context (CLAUDE.md plan pointer).

---

## Milestones

- **M0 — Measurement Gate (BLOCKING)**: schema sample prepared; context-budget + depth-2/1 fit measured; strict-JSON vs structured-output trialed; generation path + keep-model decision recorded. *No pipeline code merges before G-M0.*
- **M1 — Manual SQL export script + reviewed asset**: `export_projects_schema.sql` + README; `projects_db_metadata_schema.json` reviewed and committed; registered in pubspec assets.
- **M2 — SchemaGraph load/parse**: `schema_loader.dart` + `schema_graph.dart` + tests (valid/malformed/contract-mismatch).
- **M3 — Schema context trimming**: `schema_context_trimmer.dart` (compact format, lookup-cap reduction, depth-2→depth-1 fallback) + tests asserting budget fit.
- **M4 — Intent prompt + generation**: `intent_prompt_builder.dart` + `intent_generation_strategy.dart` (selected path) + `intent_system_instruction.txt`; reuses `LocalSlmService`.
- **M5 — Parse / validate / repair**: `intent_parser.dart`, `intent_validator.dart` (all rules), `intent_repair.dart` (one retry), `intent_service.dart` orchestration + tests.
- **M6 — Intent Debug screen (dev-only)**: `intent_debug_view.dart` showing trimmed context, raw output, parsed Intent, validation errors, repair result, latency; behind debug flag.
- **M7 — Golden set + scorecard**: `intent_golden_set.json` (≥50, all categories) + `intent_metrics.dart` scorecard; manual S22 Ultra evaluation run + recorded Go/No-Go.

Dependency order: **M0 → (M1 ∥ M2) → M3 → M4 → M5 → M6 → M7**. M1 and M2 can proceed in parallel once M0's schema sample exists.

---

## Files / Components — create vs modify

**Create (on-device):** `intent/schema_graph.dart`, `intent/schema_loader.dart`, `intent/schema_context_trimmer.dart`, `intent/intent_prompt_builder.dart`, `intent/intent_generation_strategy.dart`, `intent/intent_service.dart`, `intent/intent_inference_controller.dart`, `intent/intent_model.dart`, `intent/intent_parser.dart`, `intent/intent_validator.dart`, `intent/intent_repair.dart`, `intent/intent_metrics.dart`, `intent/view/intent_debug_view.dart`; assets `assets/ai/schema/projects_db_metadata_schema.json`, `assets/ai/prompts/intent_system_instruction.txt`; tests under `test/features/ai_assistant/intent/` incl. `golden/intent_golden_set.json`.

**Create (off-device):** `tools/schema_export/export_projects_schema.sql`, `tools/schema_export/README.md`.

**Modify (minimal):** `lib/core/di/project_management_locator.dart` (add guarded lazy registrations only); `pubspec.yaml` (register the two new assets); optionally `poc_demo_flags.dart` (add a debug flag to reveal the Intent Debug screen) — additive only.

**Do NOT touch:** `local_slm_service.dart`, `ai_inference_controller.dart`, `ai_assistant_body.dart`, `prompt_builder.dart`, and the rest of the 001 free-text path.

---

## Data / Model Contracts (summary)

- **Schema asset contract** → `contracts/schema_metadata_contract.md`. Stable, versioned, three-section, future-multi-root-ready (FR-010, FR-011).
- **Intent JSON contract** → `contracts/intent_json_contract.md`, authoritative copy of the spec's contract incl. `clarification_options` entry shape; enumerated `status`/`language`/`intent`; validator rule→status mapping (FR-017–FR-020).
- **LocalSlmService reuse contract**: Intent generation uses only `LocalSlmService.generateText(prompt, maxTokens, timeout)` from 001 — no new method on the interface, so 001 stays unaffected (FR-015, FR-025).

---

## Testing Strategy

**Automated (CI — no real model, no network, no DB):**
- `schema_loader_test`: parses a valid asset → SchemaGraph; rejects malformed/contract-mismatch with clear errors.
- `schema_context_trimmer_test`: depth-2 slice within budget passes; oversized slice triggers compact → reduced-caps → depth-1 fallback (assert the produced slice and that it fits a configurable budget).
- `intent_parser_test`: extracts JSON from fenced/noisy small-model output; fails gracefully on non-JSON/truncated.
- `intent_validator_test`: **crafted cases** — unknown table, unknown column, missing FK path, type-incompatible operator, unknown lookup value, embedded SQL fragment → each yields the correct `status`/`validation_errors` (target 100% catch, SC-005).
- `intent_repair_test`: invalid-then-valid scripted outputs → exactly one retry, final result correct; invalid-twice → finalized as failed-with-errors.
- `intent_service_test`: end-to-end orchestration against a **`FakeLocalSlmService`** returning scripted strings for ok / needs_clarification / unsupported / invalid_schema_reference.
- `intent_debug_view_test`: widget test with fake service renders all six panels.

**Manual on-device (S22 Ultra — not CI):**
- M0 probe measurements (context fit, path comparison, latency).
- Full golden-set run → scorecard.
- 001 free-text chat regression smoke (chat still works unchanged).

**Fakes/mocks rationale**: real inference is non-deterministic and device-bound, so model-dependent behavior is asserted via a `FakeLocalSlmService` in CI; only accuracy/latency quality is judged manually on-device.

---

## Manual Validation Steps (S22 Ultra)

1. Build/install the app with the Intent Debug flag enabled.
2. Confirm `projects_db_metadata_schema.json` loads into a SchemaGraph (no error banner).
3. Run the M0 probe set; record context-fit, chosen slice depth, path comparison, latency → `research.md`.
4. On the Intent Debug screen, submit representative AR/EN/mixed questions; verify the six panels (trimmed context, raw output, parsed Intent, validation errors, repair result, latency).
5. Submit a deliberately ambiguous question → expect `needs_clarification` + well-formed `clarification_options`; an out-of-scope question → `unsupported` + reason.
6. Run the ≥50 golden set → produce the scorecard (validity, intent-match, repair rate, latency, per-category).
7. Open the existing AI Assistant chat → confirm free-text still works (001 regression).
8. Record the Go/No-Go decision with the scorecard.

---

## Risks & Mitigations

| Risk | Impact | Mitigation |
|---|---|---|
| Depth-2 schema slice exceeds Qwen context | Truncation / garbage intent | M0 measures first; tiered fallback compact → reduce caps → depth-1; budget-fit asserted in trimmer tests |
| Small model emits non-strict / noisy JSON | Parse failures | Tolerant `intent_parser` (fenced-block + first-balanced-object), then one repair retry; strict-JSON prompt with stop sequences chosen if M0 favors it |
| Hallucinated schema references | Unsafe downstream intent | `intent_validator` checks table/column/FK/operator/lookup + no-SQL/no-unknown-ref → `invalid_schema_reference`; 100%-catch crafted test set (SC-005) |
| Structured output unavailable in runtime for Qwen | Can't use function-calling path | M0 trials it; default to strict-JSON if absent — feature does not depend on it |
| Live SQL Server access delayed | Blocks schema sample | Phase −1 allows a contract-matching representative sample so M0/dev proceeds; swap real export in later |
| Sensitive data leaks into asset | Privacy exposure | Denylist (documented, editable) + mandatory manual review before commit (FR-007/FR-008, SC-001) |
| Accidental coupling to 001 path | Regression in free-text chat | Additive `intent/` folder; no edits to `LocalSlmService`/`AiInferenceController`; regression smoke (SC-009) |
| Latency too high on-device | Poor evaluation UX | `maxTokens` cap, compact slice, measure in M0; record rather than gate (POC) |
| Repair loop cost | Wasted latency | Exactly one bounded retry; failures surfaced, never silently retried (FR-016/FR-019) |

---

## Acceptance Mapping (spec → plan)

| Spec | Covered by |
|---|---|
| FR-001…FR-009 (manual export, root, depth 2, lookups, denylist, no secrets, FOR JSON) | M1 `export_projects_schema.sql` + README; SC-001 manual review |
| FR-010, FR-011 (asset path, 3-section stable/future-ready contract) | M1 asset + `contracts/schema_metadata_contract.md` |
| FR-012 (load → SchemaGraph) | M2 `schema_loader`/`schema_graph` |
| FR-013, FR-014 (schema-aware prompt, trimming + depth fallback) | M3 `schema_context_trimmer`, M4 `intent_prompt_builder` |
| FR-015 (generate via existing LocalSlmService, no model switch) | M4 `intent_generation_strategy` reusing `generateText` |
| FR-016 (one bounded repair) | M5 `intent_repair` |
| FR-017 (contract conformance) | M5 `intent_model`/`intent_parser` + `intent_json_contract.md` |
| FR-018, FR-019 (validation rules, surfaced failures) | M5 `intent_validator`; SC-005 |
| FR-020 (clarification/unsupported structure only) | M5 model + validator; M6 display; no UI |
| FR-021 (dev-only debug screen, 6 panels) | M6 `intent_debug_view` |
| FR-022, FR-023 (≥50 golden set, scorecard) | M7 `intent_golden_set.json` + `intent_metrics`; SC-007 |
| FR-024 (M0 gate) | Phase −1 / M0; research.md |
| FR-025 (001 unaffected) | Additive structure; SC-009 regression smoke |
| FR-026, FR-027 (hard boundaries / non-goals) | Enforced across all milestones; SC-008 inspection |
| SC-001…SC-010 | M1/M2/M3 + M5 + M7 + M0 as mapped above |

---

## Blockers Before Coding

1. **G-M0 decision unrecorded** — must complete M0 (context fit + generation path) before M2+ pipeline code merges. *Blocking by design.*
2. **Schema sample availability** — need either read-only SQL Server access to run `export_projects_schema.sql`, or sign-off to use a contract-matching representative sample for M0/dev. (Decision needed.)
3. **Structured-output capability unknown** — whether `flutter_gemma`+Qwen exposes function-calling/structured output is unconfirmed; M0 resolves it, default is strict-JSON.
4. **Chosen root table** — the single project root for v1 must be selected during manual discovery before the export produces the asset.
5. **Token budget number** — no reliable figure yet; M0 measures it empirically (do not assume).

> Items 2 and 4 are the only true external dependencies; everything else is resolved inside M0. **Do first: prepare the schema sample, then run the M0 measurement gate.**
