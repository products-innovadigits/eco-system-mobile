# M0 Manual Runbook — On-Device Measurement (T007 / T008)

**Feature:** `002-slm-db-schema-intent-json` · **Device:** Samsung Galaxy S22 Ultra
**Model:** current **Qwen2.5 1.5B** from feature 001 (do **not** switch models).

This runbook lets you run the M0 measurement **by hand** using the existing local
AI Assistant chat from feature 001. It is **measurement only** — no new app code,
no `intent/` folders, no SchemaGraph/parser/validator. You paste prepared prompts,
record raw outputs and latency, and we analyze afterward. **Keep G-M0 pending.**

## Files in this pack
- `schema_slice_summary.md` — compact view of the real schema asset.
- `strict_json_prompt_depth_2.txt` — full prompt with the depth-2 schema slice.
- `strict_json_prompt_depth_1.txt` — smaller fallback prompt (depth-1 only).
- `m0_probe_questions.md` — 15 probe questions.
- `result_recording_template.md` — where you record everything.

## What we are measuring
- **T007 (context/budget):** Does the depth-2 prompt fit the model's context and
  produce coherent JSON? If not, does the depth-1 fallback fit and work?
- **T008 (generation path):** Is strict-JSON prompting reliable? If the runtime
  exposes a structured-output / function-calling mode, compare it; otherwise record
  it as "unavailable".

## Before you start
1. On the S22 Ultra, open the existing **AI Assistant** chat (feature 001).
2. Open the model selection and **confirm the active model is Qwen2.5 1.5B**
   (download/select it if needed). Record the app build/commit.
3. Open `result_recording_template.md` and fill the **Device / setup** section.
4. Have a stopwatch ready (phone clock/stopwatch) for manual latency.

## Running each probe (do this for all 15 questions, depth-2 first)
1. Open `strict_json_prompt_depth_2.txt`. Copy the **entire** file.
2. Replace the line `<<PASTE ONE PROBE QUESTION HERE>>` with **one** probe
   question from `m0_probe_questions.md` (e.g. Q01).
3. Paste the whole thing into the AI Assistant input and send.
4. **Start the stopwatch when you tap send; stop when the full reply finishes.**
   Record the seconds.
5. Copy the model's **raw output verbatim** into the "Raw outputs" section.
6. In the results table, fill:
   - **Valid JSON (Y/N)** — does the raw output parse as one JSON object? (If it
     has prose/markdown around it, mark N but note "JSON inside fences".)
   - **Schema-grounded (Y/N)** — do all tables/columns/lookup values it used exist
     in `schema_slice_summary.md`?
   - **Hallucinated table/col (Y/N + which)** — list any invented name.
   - **Latency (s)** and **Status returned** (`ok`/`needs_clarification`/`unsupported`/`invalid_schema_reference`).
   - **Notes** — anything notable (truncation, wrong language, refusal, SQL leakage).
7. Repeat for Q02 … Q15.

> Tip: start a **new chat** between questions so prior turns don't bias the model.

## When to use the depth-1 fallback
Use `strict_json_prompt_depth_1.txt` and record the depth-1 rows **if any** of:
- the depth-2 prompt is visibly **truncated** / the model ignores the tail,
- outputs are frequently **non-JSON** or **hallucinated** on depth-2,
- latency is unacceptably long on depth-2.
Re-run at least Q01, Q02, Q05, Q11, Q12, Q13 on depth-1 (Q12 especially — it needs
the depth-2 risk-status chain, so on depth-1 it should become `unsupported` or
`needs_clarification`; that contrast is the signal we want).

## Optional T008 — structured output
If the local runtime exposes a JSON/structured-output or function-calling mode for
this model, run the same questions through it and record parse-success vs. the
strict-JSON prompt. If it does **not**, write "structured-output: unavailable".

## Validity & schema-grounding quick rules
- **Valid JSON** = the whole reply is exactly one JSON object (no extra text).
- **Schema-grounded** = every `table`, `column`, and lookup `value` referenced is
  in `schema_slice_summary.md`. A reference like `Projects.Status` is a
  hallucination (Projects has no status column) → mark hallucinated + status should
  be `needs_clarification`/`unsupported`, not `ok`.
- **No SQL** must appear anywhere; if SQL appears, note it (the prompt forbids it).

## After the run — what to send back
Send the **filled `result_recording_template.md`** (results tables + raw outputs +
roll-up + draft decision). That's all we need. Do **not** edit `research.md`,
and do **not** mark T007/T008/T009 complete — we update the gate together once the
numbers are in.

## Guardrails (unchanged)
- No M2+ implementation; no Flutter `intent/` source; no SchemaGraph/loader/trimmer/
  prompt-builder/parser/validator/repair/debug-UI/golden-runner.
- Do not touch the 001 free-text chat path.
- **G-M0 stays pending** until these results are analyzed and the gate is explicitly flipped.
