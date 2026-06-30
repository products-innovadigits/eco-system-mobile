# Phase 0 Research — Schema-Aware Intent JSON (Projects POC)

**Feature**: `002-slm-db-schema-intent-json` | **Date**: 2026-06-30

This document records the M0 measurement design and the technical decisions that unblock implementation. Everything here precedes pipeline coding. The on-device numbers (context window, latency) are **to be filled by the M0 run on a Samsung Galaxy S22 Ultra** with the current Qwen2.5 1.5B model — placeholders below are marked `[M0]`.

---

## D1 — Generation path: strict-JSON prompting vs. structured output

- **Decision**: Default to **strict-JSON prompting** behind an `IntentGenerationStrategy` interface; trial structured-output/function-calling in M0 and switch only if it measurably wins.
- **Rationale**: `flutter_gemma`'s structured-output support for an arbitrary Qwen2.5 1.5B build is unconfirmed, and strict-JSON prompting (delimited output + stop sequence + tight `maxTokens`) works on any text-generation backend. Keeping it behind a strategy interface lets M0 pick the winner without reworking the pipeline.
- **Alternatives considered**: (a) Hard-commit to function-calling — rejected: availability unknown, would block the feature. (b) Grammar-constrained decoding (GBNF) — rejected for this POC: not exposed by the current runtime; recorded as a future option if strict-JSON parse rates are poor.
- **M0 measurement**: run the same probe set through both paths where available; compare parse-success and schema-validity. `[M0: strict-JSON parse rate = __ ; structured-output parse rate = __ ; chosen = __]`.

## D2 — Token-budget estimation on device

- **Decision**: Use a **heuristic char→token ratio** (start ~3.5 chars/token for mixed AR/EN, tunable) to size the trimmed slice against a configurable budget; calibrate the ratio against actual model behavior during M0.
- **Rationale**: An exact on-device tokenizer for the Qwen build may not be readily callable from Dart; a calibrated heuristic is sufficient to drive the depth-2→depth-1 fallback decision for a POC.
- **Alternatives considered**: Exact tokenizer count — preferred if cheaply available; M0 checks whether the runtime exposes a token count. Word-count heuristic — rejected: too coarse for Arabic.
- **M0 measurement**: `[M0: measured context window (ekv) = __ tokens ; depth-2 slice ≈ __ tokens ; fits? __ ]`.

## D3 — Schema slice trimming & fallback ladder

- **Decision**: Trimmer emits a **compact serialization** (table → `col:type[?]` lines, FK edges as `A.col→B.col`, lookups as `col:[v1,v2,…]` capped) and applies the fallback ladder **in order**: (1) compact formatting, (2) reduce `maxLookupRows`, (3) drop to FK **depth 1**. A larger-context model build is *out of scope* unless all three still fail.
- **Rationale**: Matches the spec's prescribed fallback order; each step sheds tokens with decreasing information loss before any model change is considered.
- **Alternatives considered**: Question-driven sub-graph selection (only tables relevant to detected keywords) — promising, recorded as an enhancement; v1 uses depth-based slicing for determinism and testability.
- **M0 measurement**: `[M0: first ladder step that fits = __ ]`.

## D4 — Tolerant JSON extraction before declaring parse failure

- **Decision**: `intent_parser` strips markdown fences, then extracts the **first balanced top-level `{…}`**, then `jsonDecode`. Only if that fails is the output a parse failure (→ repair retry).
- **Rationale**: Small models commonly wrap JSON in prose/fences; tolerant extraction materially raises usable-output rate without weakening validation (validation still runs on the parsed object).
- **Alternatives considered**: Strict `jsonDecode` of the whole output — rejected: needlessly fails recoverable outputs. Regex field scraping — rejected: brittle, bypasses the contract.

## D5 — Repair strategy (one bounded retry)

- **Decision**: On parse/validation failure, re-prompt **once** with a compact repair instruction that includes the original question, the trimmed schema, and the specific `validation_errors`; re-parse/re-validate; if still invalid, finalize as failed-with-errors (status reflects the failure, errors surfaced).
- **Rationale**: One retry captures most easily-correctable mistakes (wrong field name, stray SQL) without unbounded latency; aligns with FR-016/FR-019.
- **Alternatives considered**: N retries — rejected: latency/cost, diminishing returns. No retry — rejected: leaves easy wins on the table.

## D6 — Validation rule → status mapping

- **Decision**: Any unknown table/column/FK-path/lookup reference → `status = invalid_schema_reference`; any embedded SQL fragment → rejected (invalid_schema_reference). Type-incompatible operator → validation error (invalid_schema_reference). Well-formed but ambiguous → `needs_clarification`. Out-of-scope → `unsupported`. Clean & grounded → `ok`.
- **Rationale**: Makes "hallucinated reference" unambiguous and testable; matches the spec contract.
- **Alternatives considered**: Soft-warn on unknown refs — rejected: defeats the safety purpose of the validator.

## D7 — Schema sample sourcing when live DB access is delayed

- **Decision**: If read-only SQL Server access is not yet available, author a **representative** `projects_db_metadata_schema.json` that strictly matches the asset contract (realistic projects + risk/status/priority/owner/department/progress/due-date tables), clearly labeled as representative, and swap in the real export later without parser changes.
- **Rationale**: M0 and on-device pipeline work are blocked only on *a* contract-conformant schema, not specifically the production one; the stable contract guarantees a later real export drops in cleanly (FR-011).
- **Alternatives considered**: Block all work on DB access — rejected: unnecessarily serializes the project.

## D8 — Reuse of 001 runtime (no interface change)

- **Decision**: Intent generation calls the existing `LocalSlmService.generateText(prompt, maxTokens, timeout)`; **no** `generateIntent` is added to the 001 interface, and `AiInferenceController` is not modified. A new `IntentInferenceController` wraps the Intent flow.
- **Rationale**: Keeps 001 byte-for-byte unchanged (FR-025), avoids a second runtime, and isolates all new behavior behind the new `intent/` folder.
- **Alternatives considered**: Extend `LocalSlmService` with an intent method — rejected: touches 001 surface and risks regression for no benefit (the prompt already encodes the JSON instruction).

---

## M0 Plan of Record (the gate)

1. Prepare/commit the schema sample asset (D7).
2. On S22 Ultra with current Qwen2.5 1.5B, measure context window and depth-2 slice size (D2/D3).
3. Run the probe set (a ~10–15 question subset spanning AR/EN/mixed, list/count/summarize, ambiguous, unsupported) through strict-JSON and (if available) structured output (D1).
4. Record: context fit, first fitting ladder step, parse-success per path, sample latency.
5. **G-M0 exit**: a fitting slice exists + a generation path clears the recorded parse-success threshold → proceed; record keep-current-model decision (larger-context build flagged only if depth-1+compact+reduced-caps still fails).

**Open numeric placeholders to fill during M0**: context window `[M0]`, depth-2 token estimate `[M0]`, chosen ladder step `[M0]`, strict-JSON vs structured parse rates `[M0]`, median latency `[M0]`.
