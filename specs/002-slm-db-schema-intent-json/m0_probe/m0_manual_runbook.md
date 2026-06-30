# M0 Manual Runbook — On-Device Measurement (T007 / T008)

**Feature:** `002-slm-db-schema-intent-json` · **Device:** Samsung Galaxy S22 Ultra
**Model:** current **Qwen2.5 1.5B** from feature 001 (do **not** switch models).

You run the M0 measurement using a **dev-only M0 Probe screen** inside the app.
You type **only the natural-language question** — the harness assembles the fixed
prompt internally (injects your question into `{{USER_QUESTION}}`), calls the
existing `LocalSlmService`, and shows the raw output + latency. **You never paste
the full prompt.** This is a measurement harness only — it is **not** the Intent
pipeline (no SchemaGraph/loader/trimmer/parser/validator/repair/IntentService).
**Keep G-M0 pending.**

## Files in this pack
- `m0_probe_questions.md` — 15 probe questions (type these one at a time).
- `result_recording_template.md` — where you record outputs/latency/checks.
- `schema_slice_summary.md` — compact view of the real schema (for grounding checks).
- `strict_json_prompt_depth_2.txt` / `strict_json_prompt_depth_1.txt` — reference
  copies of the templates the app uses (you do NOT paste these; they are FYI).

> The app loads the live templates from assets:
> `assets/ai/prompts/m0_strict_json_depth_2.txt` and `…_depth_1.txt`.

## What we are measuring
- **T007 (context/budget):** Does the depth-2 prompt fit the model's context and
  produce coherent JSON? If not, does the depth-1 fallback fit and work?
- **T008 (generation path):** Is strict-JSON prompting reliable? If the runtime
  exposes structured-output/function-calling, compare it; else record "unavailable".

## One-time setup
1. Build/install a **measurement build** with the probe flag on:
   ```
   flutter run --dart-define=AI_M0_PROBE=true
   ```
   (or your release-to-device equivalent with the same `--dart-define`). With the
   flag **off** the probe screen does not exist and nothing changes.
2. Open the **AI Assistant**. On the model-selection screen, **confirm the active
   model is Qwen2.5 1.5B** (select/download it if needed).
3. Tap **“M0 Probe (dev)”** (appears only in the flag-on build) to open the harness.
4. Open `result_recording_template.md` and fill the **Device / setup** section.

## Running each probe (all 15 questions, depth-2 first)
1. In the M0 Probe screen, set **Schema slice = depth-2**.
2. Type **one** question from `m0_probe_questions.md` (e.g. Q01) into the question
   field. Type only the question — nothing else.
3. Tap **Run**. The harness shows **Latency (ms)** and the **Raw model output**.
4. Tap **Copy** to copy the raw output; paste it into the template’s “Raw outputs”.
5. Record in the results table:
   - **Valid JSON (Y/N)** — is the raw output one JSON object?
   - **Schema-grounded (Y/N)** — do all tables/columns/values exist in
     `schema_slice_summary.md`?
   - **Hallucinated table/col (Y/N + which)**.
   - **Latency (s)** (the screen shows ms — convert), **Status returned**, **Notes**.
   - You can also use the on-screen Yes/No/— and Notes fields as a scratchpad.
6. Repeat for Q02 … Q15.

> The screen does **not** judge pass/fail — you record your own judgement. The
> `[AI_M0_PROBE]` terminal logs (variant, question length, prompt size, start/finish,
> latency, errors) are available in `flutter run` if you want to cross-check timing.

## When to use the depth-1 fallback
Switch **Schema slice = depth-1 fallback** and re-run if, on depth-2, any of:
- outputs are visibly **truncated** / the model ignores the schema tail,
- outputs are frequently **non-JSON** or **hallucinated**,
- latency is unacceptably long.
Re-run at least Q01, Q02, Q05, Q11, Q12, Q13 on depth-1. **Q12** especially: it
needs the depth-2 risk-status chain, so on depth-1 it should become `unsupported`
or `needs_clarification` — that contrast is a key signal.

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

## Guardrails (unchanged)
- The M0 Probe harness is measurement-only and lives in
  `lib/features/ai_assistant/m0_probe/`. It is **not** the Intent pipeline.
- No SchemaGraph/loader/trimmer/parser/validator/repair/IntentService/production
  Intent Debug UI was implemented.
- The 001 free-text chat path is untouched; the probe entry is flag-gated and
  invisible in normal builds.
- **G-M0 stays pending** until results are analyzed and the gate is explicitly flipped.
