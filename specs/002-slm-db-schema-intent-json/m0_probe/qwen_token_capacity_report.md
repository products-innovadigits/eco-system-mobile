# Qwen2.5 1.5B — Token / Context Capacity Report (M0)

**Feature:** `002-slm-db-schema-intent-json` · **Runtime:** `flutter_gemma` 0.12.6 ·
**Model:** Qwen2.5 1.5B (`litert-community`) · **Device:** Samsung Galaxy S22 Ultra
**Status:** investigation only — **G-M0 still pending**, no device conclusions recorded.

---

## 1. Current confirmed facts (from logs + code + package)
- Probe ran with `MODE: INTENT JSON PROBE (depth=2)`, `prompt_len=4163` chars.
- Native error: `current_step(740) + input_size(1068) was not less than maxTokens(1024)` → SIGSEGV.
- `current_step(740)` = tokens already in the session (accumulated **chat history** + prior turn). `input_size(1068)` = tokens of the new (depth-2) prompt. Their sum (1808) exceeded `maxTokens(1024)`.
- Interpretation confirmed against the package: in `flutter_gemma`, **`maxTokens` is the total context window (KV cache), not an output-only budget.** The interface doc says: *"[maxTokens] — maximum context length for the model."*
- Two compounding causes: (a) the probe reused the chat session (history accumulation), and (b) even a fresh depth-2 prompt (~1068 tokens) is close to / over the configured window once output is reserved.

## 2. Where the `1024` comes from
- **Code-configured in our project.** `FlutterGemmaSpikeConfig.contextTokens = 1024`
  (`lib/features/ai_assistant/local_slm/flutter_gemma_local_slm_service.dart`).
- It is passed to `openChat(maxTokens: _config.contextTokens)` → `createModel(maxTokens: …)`
  (`flutter_gemma` `InferenceModel`). The native `maxTokens(1024)` in the crash is exactly this value.
- `flutter_gemma`'s own default for `createModel(maxTokens:)` is also `1024`, but here it is our explicit config.
- Both **normal chat and the one-shot probe use the same `contextTokens`** (the service is shared), so any change applies to both.

## 3. Code-configured vs runtime-defaulted vs model-file constrained
| Limit | Source | Value |
|---|---|---|
| Requested context window | **our code** `FlutterGemmaSpikeConfig.contextTokens` | **1024** |
| `flutter_gemma` default | package default for `createModel(maxTokens:)` | 1024 |
| **Model file built context (KV)** | **the `.task` filename / export** | **ekv = 1280** |
| Chat output reserve (`tokenBuffer`) | `createChat(tokenBuffer:)` default | 256 |

- **The active model file is `Qwen2.5-1.5B-Instruct_seq128_q8_ekv1280.task`** (our catalog
  `model_catalog.dart`, downloaded from `litert-community/Qwen2.5-1.5B-Instruct`).
- `ekv1280` = the model is exported with a **1280-token KV cache** (its real max context).
  `q8` = 8-bit weights. `seq128` = the prefill sequence shape used at export (chunked prefill);
  the crash shows `input_size(1068)` was prefilled fine, so **`seq128` is not a 128-token input cap** — the binding limit is `ekv` (1280).
- **Net:** the `1024` is *our* conservative code value, **256 tokens below what the model file actually supports (1280).** The model is currently under-utilized, not maxed out.

## 4. Is increasing `maxTokens` possible and safe?
- **Up to 1280: yes, supported by the current file** (it is built `ekv1280`). Raising
  `contextTokens` to 1280 should not require a new model and is the obvious first win.
  Requesting **> 1280 on this file** will fail or be clamped by MediaPipe/LiteRT (the KV cache
  shape is fixed at export).
- **2048 / 4096: NOT possible with this file.** It requires a **different `.task` export**
  built with a larger `ekv` (e.g. `…_ekv2048.task` / `…_ekv4096.task`), or a re-conversion with
  AI Edge Torch / LiteRT-LM at a larger context. That is a model-build task, a larger download,
  and more RAM — not a runtime flag.
- We made the context a **single knob** for testing: DI now passes
  `FlutterGemmaSpikeConfig(contextTokens: AiAssistantDevConfig.intentProbeContextTokens)`.
  Change `intentProbeContextTokens` (default 1024) → 1280 to test the model's real max. The
  preflight guard budget auto-tracks this value.

## 5. Values worth testing
- **1024** — current baseline (already crashing for depth-1/2; depth-0 fits).
- **1280** — the model's built max (ekv1280); **the realistic ceiling on the current file.**
- **2048 / 4096** — only if/after we obtain a larger-`ekv` Qwen `.task` (separate spec/task).
  Do **not** request these on the current file.

## 6. Exact vs estimated token counting
- **Exact counting IS available.** `flutter_gemma` exposes `InferenceModelSession.sizeInTokens(text)`
  (and `PlatformService.sizeInTokens`). The package itself uses it for history trimming.
- **We currently use an ESTIMATE** (`chars / 3.5`) in the preflight guard and `[AI_INTENT_PROBE]`
  logs — clearly labeled `(estimated)`.
- **Recommended:** wire `session.sizeInTokens` through our `LocalSlmService` (an optional
  `Future<int?> countTokens(String)`), and use it for an **exact** preflight when the engine is
  loaded (fall back to the estimate otherwise). This removes guesswork from the guard. (Not done
  yet — proposed; it touches the interface + fakes, so it is left for review.)

## 7. Recommended safe preflight guard threshold
- Keep: **reject if `estPromptTokens + outputReserve > contextTokens`.**
- Current numbers: context 1024, reserve 256 → **prompt budget 768 tokens** (~2688 chars).
- If context is raised to 1280: budget becomes **1024 tokens** (~3584 chars) with the same reserve.
- Keep the reserve at **≥ 256** (Intent JSON answers run ~120–256 tokens). The guard must stay
  **client-side and mandatory** — never rely on native to reject oversize input (it SIGSEGVs).
- Once exact `sizeInTokens` is wired, replace the char estimate with the exact count and keep the
  same inequality.

## 8. Recommended prompt depth for the current runtime
| Depth | Est. prompt tokens | Fits 1024 (budget 768)? | Fits 1280 (budget 1024)? |
|---|---|---|---|
| depth-2 (~4292 chars) | ~1226 | ❌ no | ❌ no |
| depth-1 (~3135 chars) | ~895 | ❌ no | ✅ yes (tight) |
| **depth-0 (~1425 chars)** | **~410** | ✅ **yes** | ✅ yes |
- **On the current 1024 config: use depth-0.** It is the only slice that fits with output room.
- **If context is raised to 1280: depth-1 becomes usable** (≈895 + ~120 output < 1280), which is
  the main practical reason to bump to the model's real max. depth-2 still won't fit even at 1280.

## 9. Risk assessment for increasing context
| Change | RAM | Latency | Heat | Crash risk | Quality |
|---|---|---|---|---|---|
| 1024 → **1280** (same file) | small KV-cache bump (~+25%) | slightly higher prefill/decode | mild | low — within the file's built ekv | enables depth-1 (more schema → better grounding) |
| → **2048 / 4096** (new file) | **large** KV-cache + bigger model variant download | notably higher (longer prefill), first-token slower | higher sustained, possible throttling on long sessions | medium — OOM risk on 6–8GB devices for long prompts; must measure | best schema coverage, but diminishing returns vs cost for a 1.5B model |
- S22 Ultra (8/12GB) can likely hold a 1.5B int8 model + a 1280–2048 KV cache, but **2048+ needs a real export and on-device measurement** (RAM headroom with the rest of the app, thermal behavior over repeated sends).
- The fresh one-shot already removes history accumulation, so the main remaining risk is a single oversized prompt — handled by the guard.

## 10. Future AI Assistant context strategy
**Principle: never send "everything." Budget tokens explicitly and slice context to the question.**
- **Separate prompts by job:** (a) *intent extraction* (fresh one-shot, schema slice, no chat
  history) vs (b) *answer generation* (small, after data is retrieved). Different budgets.
- **Intent extraction = fresh one-shot, no chat history** (already implemented for the probe).
- **Schema slicing, not the full schema:** select only tables/columns relevant to the question
  (keyword/embedding match over the schema), depth-bounded; this is what M2's trimmer will do.
- **Token-budget manager:** a small component that, given the model's exact context (via
  `sizeInTokens`), packs system + schema-slice + question + output-reserve and drops the
  lowest-priority sections first (lookups → distant tables → depth) until it fits.
- **Conversation context (future, when chat history is backend-stored):**
  - **last-N messages only** for follow-ups, not the whole thread;
  - **rolling summary**: keep a compact running summary instead of raw history;
  - **local/offline summary cache** for the current session;
  - **backend retrieval**: pull only the relevant prior turns from the DB-stored history (a later spec), not the full conversation.
- **RAG-style retrieval** for schema/docs: retrieve the few relevant schema fragments per question rather than embedding the whole DB metadata.
- **Compact result-to-answer prompt:** after backend data retrieval (future), feed only the
  retrieved rows/summary + question into a short answer prompt — keep it well under context.
- **Fallbacks:**
  - prompt too large → drop to a smaller schema depth (depth-1 → depth-0), then shorten lookups,
    then summarize, then return a controlled "need narrower question" message — never crash;
  - if the task genuinely needs more context than the model supports → **model/runtime fallback**:
    a larger-`ekv` Qwen `.task`, a larger-context model build, or a server-side model (a later spec).

## 11. Open questions requiring physical-device testing (S22 Ultra)
1. Does `contextTokens = 1280` load and generate cleanly on the current file (no clamp/error)?
2. At 1280, does **depth-1** fit and return valid Intent JSON, and at what latency?
3. Exact `sizeInTokens` for depth-0/-1 prompts (to replace the char estimate)?
4. RAM headroom + thermal behavior over ~15 consecutive one-shot sends at 1024 and 1280?
5. Does the litert-community repo offer a larger-`ekv` Qwen2.5 1.5B `.task` (2048/4096), and its size/quantization?
6. First-call warm-up cost of the fresh-session one-shot (session re-init per probe send)?

## 12. Clear recommendation for next action
1. **Keep depth-0 as the working probe depth at 1024** for the first measurement pass (it fits and won't crash).
2. **Then set `AiAssistantDevConfig.intentProbeContextTokens = 1280`** (one knob) and re-test
   depth-0 and **depth-1** on the S22 Ultra — this is the model's real ceiling and is the cheapest
   capacity win (enables depth-1 grounding).
3. **Do not request 2048/4096 on the current file.** If depth-1 quality is insufficient, open a
   separate task to obtain/convert a larger-`ekv` Qwen `.task` and measure RAM/latency/heat.
4. **(Recommended) wire exact `session.sizeInTokens`** into the preflight guard to remove estimate
   error before broader testing.
5. Run the experiment in [m0_manual_runbook.md](./m0_manual_runbook.md) order; record results in
   [result_recording_template.md](./result_recording_template.md). **Do not flip G-M0** until the
   numbers are in and reviewed.

---

### Appendix — capacity experiment plan (run manually on S22 Ultra; stop on any native error / memory pressure / excessive latency)
For each row: record configured context, depth, est input tokens, reserved output, native-call allowed?, output completed?, latency, crash?, RAM/heat (if available), valid JSON?, notes.

| # | contextTokens | depth | expected |
|---|---|---|---|
| 1 | 1024 | depth-0 | should run (≈410 tok), valid-ish JSON |
| 2 | 1024 | depth-1 | guard → `prompt_too_large` (no native call) |
| 3 | 1024 | depth-2 | guard → `prompt_too_large` (no native call) |
| 4 | **1280** | depth-0 | should run, more output headroom |
| 5 | **1280** | depth-1 | should run (≈895 tok < 1024 budget) — key test |
| 6 | 1280 | depth-2 | guard → `prompt_too_large` (still too big) |
| 7 | 2048/4096 | — | **only with a larger-ekv file**; otherwise skip |

Stop immediately and record if any send: SIGSEGVs, reports OUT_OF_RANGE, spikes RAM, throttles, or exceeds an acceptable latency you define (e.g. > 30 s).
