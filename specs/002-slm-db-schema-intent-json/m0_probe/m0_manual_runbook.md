# M0 Manual Runbook — On-Device Measurement (T007 / T008)

**Feature:** `002-slm-db-schema-intent-json` · **Device:** Samsung Galaxy S22 Ultra
**Model:** current **Qwen2.5 1.5B** from feature 001 (do **not** switch models).

You run the M0 Intent JSON measurement through the **normal AI Assistant chat
screen** — no separate screen, no `--dart-define`. You flip a **code-level config**
in source, run the app normally from Android Studio, and type only the question.
When the probe is on, the chat send flow internally loads the fixed Intent JSON
prompt template, injects your question into `{{USER_QUESTION}}`, calls the existing
`LocalSlmService.generateText`, and logs the raw output + latency.

This is a measurement harness only — **not** the Intent pipeline (no SchemaGraph /
loader / trimmer / parser / validator / repair / IntentService). **Keep G-M0 pending.**

## Files in this pack
- `m0_probe_questions.md` — 15 probe questions (type these one at a time).
- `result_recording_template.md` — where you record outputs/latency/checks.
- `schema_slice_summary.md` — compact view of the real schema (for grounding checks).
- `strict_json_prompt_depth_2.txt` / `strict_json_prompt_depth_1.txt` — reference
  copies of the templates the app uses (FYI; you never paste these).

> The app loads the live templates from assets:
> `assets/ai/prompts/m0_strict_json_depth_2.txt` and `…_depth_1.txt`.

## Where the switch lives (code-level config)
`systems/project_management/lib/features/ai_assistant/m0_probe/ai_assistant_dev_config.dart`
```dart
class AiAssistantDevConfig {
  static const bool useIntentJsonProbe = false; // true = M0 probe, false = normal chat
  static const int  intentProbeDepth   = 1;     // 0 = minimal, 1 = depth-1, 2 = depth-2
  static const int  intentProbeContextTokens = 1024;      // Qwen build context
  static const int  intentProbeOutputReserveTokens = 256; // room left for output
}
```
The normal chat send passes the first two into the controller method that
receives the question
(`AiInferenceController.generate(..., useIntentJsonProbe:, intentProbeDepth:)`).

> **Read first:** [qwen_token_capacity_report.md](./qwen_token_capacity_report.md) explains
> where the 1024 limit comes from (our code, not the model), that the active `.task` is built
> **ekv1280** (real max 1280), and the safe capacity-experiment order. To test the model's real
> max, set `AiAssistantDevConfig.intentProbeContextTokens = 1280` (one knob; the guard budget and
> `createModel` context both follow it). Do **not** request 2048/4096 on the current file.

## Important: context window (Qwen2.5 1.5B = our code 1024; model file ekv1280)
- The probe runs as a **fresh, history-free one-shot** — it does NOT reuse the
  normal chat session, so a prior conversation can never push the prompt over the
  context window.
- A **preflight size guard** estimates the prompt tokens and, if it won't fit
  (prompt + output reserve > context), returns a controlled Flutter error and logs
  `[AI_INTENT_PROBE] prompt_too_large …`. **The native engine is never called for
  an oversized prompt**, so it cannot crash (no SIGSEGV).
- On a 1024-token build, **depth-2 (~1226 tok) and depth-1 (~895 tok) do NOT fit**
  → expect `prompt_too_large`. **depth-0 (~410 tok) fits** and produces a real
  one-shot generation. This is itself a key M0 finding (depth-1/2 need a
  larger-context model build).

## Steps
1. Open the project normally in **Android Studio**.
2. Set `AiAssistantDevConfig.useIntentJsonProbe = true`.
3. Set `AiAssistantDevConfig.intentProbeDepth = 1` (initial recommended).
4. **Run the app normally** (no special flags). Confirm the active model is
   **Qwen2.5 1.5B** in the AI Assistant.
5. Open the **normal AI Assistant chat**.
6. Type the natural-language question **only** (one question from
   `m0_probe_questions.md`, e.g. Q01).
7. **Send.**
8. Watch the terminal / Logcat for:
   - `[AI_INTENT_PROBE] variant=depth-1 question_len=… prompt_len=… est_tokens=… budget_tokens=…`
   - either `[AI_INTENT_PROBE] prompt_too_large …` (too big for 1024 ctx), **or**
   - `[AI_INTENT_PROBE] latency=…ms` and `[AI_INTENT_PROBE] raw_output=…`.
   (The chat bubble may also show the raw output / the controlled error during M0 testing.)
9. Record in `result_recording_template.md`: raw output (or `prompt_too_large`),
   latency, **valid JSON (Y/N)**, **schema-grounded (Y/N)** (check against
   `schema_slice_summary.md`), **hallucinated table/column (Y/N + which)**, status
   returned, notes.
10. **If you see `prompt_too_large` (expected for depth-1/2 on a 1024 model):** set
    `AiAssistantDevConfig.intentProbeDepth = 0`, hot-restart, and run the questions
    again — depth-0 fits the 1024 context and will actually generate. Record both
    outcomes (the too-large result for depth-1/2 IS a valid measurement).
11. Run all 15 questions at the depth that fits (depth-0). **Q12** especially
    (ambiguous/unsupported) is a key behavior signal.
12. When done, set `AiAssistantDevConfig.useIntentJsonProbe = false` to return to
    normal chat behavior.

> Note: the probe one-shot rebuilds a clean model session each send, so the first
> probe send after a normal chat may take longer (model session re-init). Record
> latency as observed; note any first-call warm-up separately.

## Optional T008 — structured output
If the local runtime exposes a JSON/structured-output or function-calling mode for
this model, run the same questions through it and compare parse-success vs. the
strict-JSON prompt. If not available, write "structured-output: unavailable".

## Validity & schema-grounding quick rules
- **Valid JSON** = the whole reply is exactly one JSON object (no extra prose).
- **Schema-grounded** = every `table`/`column`/lookup `value` is in
  `schema_slice_summary.md`. A reference like `Projects.Status` is a hallucination
  (Projects has no status column).
- **No SQL** must appear anywhere (the prompt forbids it). Note it if it does.

## After the run — what to send back
Send the **filled `result_recording_template.md`** (results tables + raw outputs +
roll-up + draft decision). Do **not** edit `research.md`, and do **not** mark
T007/T008/T009 complete — we update the gate together once the numbers are in.

## Guardrails
- The probe is M0 measurement only; it reuses the existing `LocalSlmService` and
  the normal chat send flow.
- When `useIntentJsonProbe == false`: no intent template is loaded, no
  `[AI_INTENT_PROBE]` logs are emitted, and the 001 free-text chat behaves exactly
  as before.
- No SchemaGraph / loader / trimmer / parser / validator / repair / IntentService /
  production Intent Debug UI was implemented.
- **G-M0 stays pending** until results are analyzed and the gate is explicitly flipped.
