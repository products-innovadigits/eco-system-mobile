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
  static const int  intentProbeDepth   = 2;     // 2 = depth-2, 1 = depth-1 fallback
}
```
The normal chat send passes these into the controller method that receives the
question (`AiInferenceController.generate(..., useIntentJsonProbe:, intentProbeDepth:)`).

## Steps
1. Open the project normally in **Android Studio**.
2. Set `AiAssistantDevConfig.useIntentJsonProbe = true`.
3. Set `AiAssistantDevConfig.intentProbeDepth = 2`.
4. **Run the app normally** (no special flags). Confirm the active model is
   **Qwen2.5 1.5B** in the AI Assistant.
5. Open the **normal AI Assistant chat**.
6. Type the natural-language question **only** (one question from
   `m0_probe_questions.md`, e.g. Q01).
7. **Send.**
8. Watch the terminal / Logcat for:
   - `[AI_INTENT_PROBE] variant=depth-2 question_len=… prompt_len=…`
   - `[AI_INTENT_PROBE] latency=…ms`
   - `[AI_INTENT_PROBE] raw_output=…`
   (The chat bubble may also show the raw output temporarily during M0 testing.)
9. Record in `result_recording_template.md`: raw output, latency, **valid JSON
   (Y/N)**, **schema-grounded (Y/N)** (check against `schema_slice_summary.md`),
   **hallucinated table/column (Y/N + which)**, status returned, notes.
10. Repeat Q02 … Q15. If **depth-2** outputs are truncated / non-JSON /
    hallucinated, set `AiAssistantDevConfig.intentProbeDepth = 1`, hot-restart, and
    repeat the key questions (at least Q01, Q02, Q05, Q11, Q12, Q13). **Q12**
    especially should differ between depth-2 and depth-1.
11. When done, set `AiAssistantDevConfig.useIntentJsonProbe = false` to return to
    normal chat behavior.

> Tip: the default chat token cap is modest; if Intent JSON looks cut off, note it
> in the template — that itself is a useful M0 signal for the depth/format decision.

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
