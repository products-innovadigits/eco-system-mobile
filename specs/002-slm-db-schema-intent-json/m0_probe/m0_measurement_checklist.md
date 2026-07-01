# M0 Measurement Checklist

**Feature:** `002-slm-db-schema-intent-json` · **Device:** Samsung Galaxy S22 Ultra · **Model:** Qwen2.5 1.5B (`ekv1280`, run at 1024/1280)
**Status:** G-M0 **pending**. Fill this in during manual device runs; record raw outputs in `result_recording_template.md`.
**How to run:** set `AiAssistantDevConfig.useIntentJsonProbe = true`, pick `intentProbeDepth` / `intentProbeContextTokens`, run normally, type only the question, watch `[AI_INTENT_PROBE]` logs. Set `useIntentJsonProbe = false` when done.

> Scoring keys (per question): **Valid JSON** Y/N · **Schema-grounded** Y/N (all table/column/value exist) · **Invented value** Y/N (value not in lookups) · **Relationship correct** Y/N · **Crash** Y/N · latency ms.

---

## A. Runtime / capacity runs

- [ ] **A1 — depth-0 @ 1024 (baseline).** `intentProbeDepth=0`, `intentProbeContextTokens=1024`. Confirm no crash, guard allows, valid JSON. Record prompt est_tokens, latency.
- [ ] **A2 — depth-0 @ 1280.** `intentProbeContextTokens=1280`. Confirm loads/runs on the `ekv1280` file; compare output quality + latency vs A1.
- [ ] **A3 — depth-1 @ 1280.** `intentProbeDepth=1`, `intentProbeContextTokens=1280`. Confirm the richer slice now fits (was blocked at 1024). Compare grounding quality vs depth-0.
- [ ] **A4 — depth-2 guard-block confirmation.** `intentProbeDepth=2` at 1024 and at 1280. Confirm `[AI_INTENT_PROBE] prompt_too_large native_call=BLOCKED` and **no** native call / **no** crash both times.
- [ ] **A5 — exact token counting (investigation/wiring task).** Confirm `flutter_gemma` `sizeInTokens` is callable; plan wiring it into the preflight guard to replace the `chars/3.5` estimate. Record exact tokens for depth-0/-1/-2 prompts vs the estimate (do not implement production Validator).
- [ ] **A6 — decoding parameters investigation.** Check whether `flutter_gemma` `createSession`/`createChat` exposes `temperature`, `topK`, `topP` in our wiring (interface shows `temperature=.8, topK=1, topP`). Plan a probe of low-temperature / greedy (topK=1, temp≈0) vs default to measure JSON/grounding stability. **Investigation + plan only — do not build a production config.**
- [ ] **A7 — repeated latency test.** Same question ×3 in one session: record **first run** (includes model load) vs **second/third run** (inference only, after the fresh-session one-shot fix). Confirm the model is loaded once, not per send.

## B. Output-quality observations (per run)

- [ ] **B1 — markdown fence stripping observation.** Record whether output is wrapped in ```json fences (expected). Confirm a tolerant parser (strip fences + first balanced object) would recover it. (No parser built in M0.)
- [ ] **B2 — valid JSON score.** % of golden questions returning one parseable JSON object (after fence strip).
- [ ] **B3 — schema grounding score.** % where every referenced table/column/value exists in the schema/lookups.
- [ ] **B4 — invented value score.** % where a filter value is **not** in the enumerated lookups (lower is better) — e.g. the "الهامة" failure.
- [ ] **B5 — relationship correctness score.** % where the expected `Projects → <lookup/table>` relationship is present and correct.
- [ ] **B6 — risk-vs-priority confusion count.** Count of risk questions answered with priority (or vice-versa) — the known failure mode.
- [ ] **B7 — clarification behavior.** % of ambiguous/unsupported questions that correctly produce `needs_clarification` / `unsupported` (not a confident wrong answer).

## C. Device health

- [ ] **C1 — crash / no crash** across the whole run (must be no crash; guard + one-shot).
- [ ] **C2 — memory notes** (if observable via Android Studio profiler / `adb shell dumpsys meminfo`).
- [ ] **C3 — heat / thermal notes** over a full golden-set run (any throttling, device warmth).

## D. Golden-set execution

- [ ] **D1 — run the full `m0_golden_questions.md` set** at the chosen best-fitting config (start depth-0 @ 1024; then re-run key items at depth-1 @ 1280).
- [ ] **D2 — record every raw output** + the B2–B7 scores per category (risk, priority, delayed, manager, department, lifecycle, budget, count/list, compare, summary, ambiguous, invalid, AR/EN/mixed).
- [ ] **D3 — produce the aggregate scorecard** (validity %, grounding %, invented-value %, relationship %, clarification %, latency P50/P90) — record only; do not update `research.md` conclusions yet.

## E. G-M0 decision criteria (record, do not flip the gate here)

Capture measured numbers against these targets so the gate decision is evidence-based:

| Criterion | Target (POC) | Measured |
|---|---|---|
| No native crash across the run | 100% | |
| Valid JSON (after fence strip) | ≥ 80% | |
| Schema-grounded (no hallucinated table/column) | ≥ 80% | |
| Invented lookup value | ≤ 10% | |
| Risk-vs-priority confusion | ≤ 10% | |
| Ambiguous/unsupported → clarification | ≥ 80% | |
| Median latency (steady-state, model warm) | record (target for discussion) | |
| Context config chosen | 1024 or 1280 | |
| Prompt depth chosen | 0 / 1 | |

**Decision inputs beyond raw scores:** whether deterministic grounding (see `deterministic_grounding_spike_scope.md`) is required to hit the grounding/invented-value targets, and whether a larger-context or stronger model is warranted. **G-M0 remains pending** until these are reviewed together; do not mark it passed from a single good run.
