# Phase 0 Research: Raw No-Terms Compact Schema SLM Benchmark

All Technical Context unknowns are resolved below. This file is **new** to Spec 004 and does not
modify or reference the research of Spec 001 / 002 / 003.

## R1. Local SLM invocation point

- **Decision**: Reuse the existing `LocalSlmService.generateText(prompt, {maxTokens, timeout})`
  abstraction (real impl `FlutterGemmaLocalSlmService`), resolved via the existing
  `project_management_locator` DI.
- **Rationale**: The engine (`flutter_gemma 0.12.6`) is already wired for on-device inference. Reusing
  the interface avoids introducing a new inference path and keeps the benchmark from touching
  production wiring. The interface is explicitly free-text only ("no `generateIntent`, no Intent JSON,
  no JSON validation, no backend fallback"), which matches the benchmark's raw-output requirement.
- **Alternatives considered**: (a) call `flutter_gemma` directly — rejected: duplicates existing
  session management and bypasses DI; (b) build a new engine — rejected: out of scope and wasteful.

## R2. Fresh one-shot session per question

- **Decision**: Run each question in a fresh session (dispose/reopen or a new chat) so no context
  carries between questions.
- **Rationale**: The benchmark measures raw comprehension of a single schema + single question;
  shared session state would contaminate later questions with earlier prompts/answers.
- **Alternatives considered**: One long-lived session across all six questions — rejected: introduces
  cross-question memory and makes results non-independent.

## R3. Compact schema asset loading

- **Decision**: Load the slim schema via Flutter `rootBundle.loadString` and declare the asset in the
  `project_management` module `pubspec.yaml`.
- **Rationale**: It is a bundled text asset in an existing Flutter module; `rootBundle` is the standard
  mechanism. An additive pubspec line is the minimal change required.
- **Alternatives considered**: `dart:io` filesystem read — rejected: not reliable on-device and not the
  Flutter-idiomatic path for bundled assets.

## R4. Prompt construction strategy

- **Decision**: A pure function assembles a fixed instruction block + verbatim schema block + verbatim
  question block. Instruction pins the exact six output sections, inline-FK relationship form, and
  raw-phrase preservation; forbids SQL/JSON/lookup normalization.
- **Rationale**: Purity makes prompt structure deterministic and unit-testable without a model. Pinning
  the output format is what the benchmark measures the model's ability to follow. Keeping schema and
  question verbatim avoids leaking terms or altering inputs.
- **Alternatives considered**: Few-shot examples — rejected: examples could leak lookup values/business
  terms and would confound "raw" ability; also inflates prompt length.

## R5. Token estimation

- **Decision**: If the wired engine exposes no tokenizer/token count, log an estimated token count via
  a simple `chars/4` heuristic, clearly labeled "estimated".
- **Rationale**: Exact token counts are nice-to-have, not required. A labeled estimate satisfies the
  "estimated tokens if available" logging goal without adding a tokenizer dependency.
- **Alternatives considered**: Add a standalone tokenizer library — rejected: extra dependency for a
  dev-only metric; risk of mismatch with the model's actual tokenizer.

## R6. Result logging vs. existing telemetry

- **Decision**: The benchmark records its own dev-only result (question, schema chars, prompt chars,
  estimated tokens, raw output, latency ms). It does **not** reuse `PocMetric`.
- **Rationale**: `PocMetric` explicitly forbids prompt/response content ("No PII, no prompt/response
  contents"). The benchmark, by definition, must capture the raw output. A separate dev-only record
  keeps the production telemetry contract intact.
- **Alternatives considered**: Extend `PocMetric` to carry content — rejected: violates its stated
  contract and would touch production telemetry.

## R7. Testing boundary

- **Decision**: Unit-test only the pure/deterministic pieces (prompt builder, asset loader, question
  set). Treat inference and output correctness as manual/human-judged.
- **Rationale**: Inference requires a downloaded model and capable device; correctness is a human
  judgement per the spec (SC-002, SC-005). Automated correctness would contradict the "no validation"
  non-goal.
- **Alternatives considered**: Integration test with a stub SLM — deferred: a stub can be added later
  for the runner's plumbing, but is not required to satisfy the spec's success criteria.

## Resolved unknowns summary

| Technical Context item | Resolution |
|------------------------|------------|
| Language/Version | Dart/Flutter, `project_management` module |
| Primary Dependencies | `flutter_gemma 0.12.6`, `rootBundle`, `get_it` DI |
| Storage | N/A (one text asset; manual scorecard) |
| Testing | `flutter test` for pure units; manual on-device inference |
| Target Platform | On-device Android/iOS, dev/debug only |
| Performance Goals | None asserted; latency measured/logged only |
| Constraints | Dev-only flag (default off); raw-output-only; single schema |
| Scale/Scope | 1 schema, 6 questions, 1 harness, 3 unit tests |

No `NEEDS CLARIFICATION` markers remain. Open *product* questions (dev-page entrypoint, streaming vs.
single-shot, Arabic log rendering) are tracked in `plan.md` §10 and deferred to `/speckit-tasks`.
