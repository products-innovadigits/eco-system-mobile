# M0 Real-Device Run Runbook — T009b / T009c (dev-only, on-device capture)

**Feature:** `002-slm-db-schema-intent-json` · **Device:** Samsung Galaxy S22 Ultra · **Model:** Qwen2.5 1.5B
**Status:** G-M0 **pending**. This runbook does **not** flip the gate and does **not** update `research.md`.

> **Recommended measurement approach: Option C — semi-automated log capture + off-device auto-scorer.**
> No new app code is added. You reuse the **already-committed** dev-only M0 probe
> (`AiAssistantDevConfig` + `[AI_INTENT_PROBE]` logs) exactly as-is, capture the debug console with
> `adb logcat`, then run the off-device parser [`parse_probe_logs.py`](./parse_probe_logs.py) to extract
> and auto-score every question. The auto-scorer reuses the deterministic spike's `schema_graph.py` and
> `golden_questions.py`, so the raw-SLM arm is directly comparable to the deterministic/hybrid arms.

Why not a batch runner (Option B): it would re-introduce a dev screen / iteration controller into the
`ai_assistant` production tree — exactly the surface that T009a deliberately removed — for no measurement
benefit. The existing one-shot probe already logs every field T009b/T009c needs. Option A (fully manual)
is the fallback if `adb` is unavailable; use [`result_recording_template.md`](../result_recording_template.md).

---

## 0. What the existing probe already gives you (no code change)

Per chat send with `AiAssistantDevConfig.useIntentJsonProbe = true`, the probe emits to the debug console:

```
[AiAssistant] ║ Question : <the question you typed>
[AiAssistant] ║ MODE     : INTENT JSON PROBE (depth=N)
[AI_INTENT_PROBE] variant=depth-N mode=one_shot_fresh_session question_len=.. prompt_len=.. \
                  est_prompt_tokens=..(estimated) context_tokens=.. reserved_output_tokens=.. \
                  budget_tokens=.. est_available_output=..
[AI_INTENT_PROBE] latency=..ms
[AI_INTENT_PROBE] raw_output=<model output>
```

or, when the preflight guard blocks an oversized prompt (expected for depth-1/2 at 1024):

```
[AI_INTENT_PROBE] prompt_too_large native_call=BLOCKED est_prompt_tokens=.. budget_tokens=.. context=..
```

Every field T009b/T009c must record is present: question text, depth, contextTokens, prompt length,
estimated tokens, latency, raw output, and guard-block status. (Exact `sizeInTokens` is a separate
investigation — A5 in the checklist; the estimate is `chars / 3.5`.)

---

## 1. Config knobs (edit in source, then hot-restart)

File: `systems/project_management/lib/features/ai_assistant/m0_probe/ai_assistant_dev_config.dart`

| Knob | Values | Meaning |
|---|---|---|
| `useIntentJsonProbe` | `true` to run the probe / `false` to restore normal 001 chat | **Set `false` again when done.** |
| `intentProbeDepth` | `0`, `1`, `2` | prompt slice depth |
| `intentProbeContextTokens` | `1024`, `1280` | model context budget for the preflight guard |

`intentProbeOutputReserveTokens` (256) and `intentProbeCharsPerToken` (3.5) can stay at defaults.
Budget = `contextTokens - 256`. depth-0 ≈ 410 tok, depth-1 ≈ 895 tok, depth-2 ≈ 1226 tok (estimates).

Expected fit per the checklist:

| Config | Budget | depth est | Expected |
|---|---|---|---|
| depth-0 @ 1024 | 768 | ~410 | **runs** (A1) |
| depth-0 @ 1280 | 1024 | ~410 | **runs** (A2) |
| depth-1 @ 1280 | 1024 | ~895 | **runs / fits** (A3) |
| depth-1 @ 1024 | 768 | ~895 | **guard-blocked** |
| depth-2 @ 1024 | 768 | ~1226 | **guard-blocked** (A4) |
| depth-2 @ 1280 | 1024 | ~1226 | **guard-blocked** (A4) |

---

## 2. Start log capture

Connect the S22 Ultra (USB debugging on), then from the repo root:

```bash
# clear old logs, then stream flutter/probe lines to a file
adb logcat -c
adb logcat -v time | grep --line-buffered -E '\[AiAssistant\]|\[AI_INTENT_PROBE\]' \
  > specs/002-slm-db-schema-intent-json/m0_probe/device_run/out/logcat_<config>.txt
```

Use a distinct filename per config, e.g. `logcat_depth0_1024.txt`, `logcat_depth1_1280.txt`.
Leave this running in one terminal while you drive the app.

> If you prefer, capture the raw full logcat without `grep`; the parser filters the two prefixes itself.

---

## 3. Capacity runs (checklist A1–A4)

For each config row you want to confirm:
1. Edit `AiAssistantDevConfig` (`useIntentJsonProbe=true`, set `intentProbeDepth`, `intentProbeContextTokens`).
2. Hot-restart the app (full restart, not hot-reload, so consts re-read).
3. Open AI Assistant chat, type **one** probe question (e.g. `مشاريع عالية الخطورة`), send.
4. Watch the capture file: confirm either a `raw_output=` line (fit) or `prompt_too_large native_call=BLOCKED`
   (guard) — and **no crash**.
5. Note first-run vs second/third-run latency (A7): send the same question 3× in the session.

---

## 4. Golden-set run (T009c, checklist D1–D3)

1. Pick the best-fitting config from §3 (start **depth-0 @ 1024**; then re-run key items at **depth-1 @ 1280**).
2. Keep the capture running to a single file for that config.
3. In the chat, type each `m0_golden_questions.md` question **G01 → G50, in order**, one at a time,
   waiting for each response bubble before the next. Each send is a fresh history-free one-shot, so order
   does not accumulate context. (Typing in order lets the parser fall back to positional mapping if a
   question's text is ambiguous.)
4. If a `raw_output` line looks truncated in logcat, copy the full JSON from the chat bubble into the
   results file manually — the bubble always shows the complete output.
5. When finished, stop the `adb logcat` capture (Ctrl-C).
6. **Restore `AiAssistantDevConfig.useIntentJsonProbe = false`** and hot-restart to return to normal chat.

---

## 5. Parse + auto-score (off-device)

```bash
cd specs/002-slm-db-schema-intent-json/m0_probe/device_run
python3 parse_probe_logs.py out/logcat_depth0_1024.txt --config-label depth0@1024
# writes out/device_run_results.<label>.json and .md
```

The parser extracts every per-question field, maps each question to its golden id, and **auto-scores**
valid-JSON / schema-grounded / invented-value / relationship-correct / clarification-correct using the
same schema graph and golden expectations as the deterministic spike. It also prints a ready-to-paste
`RAW_SLM_OUTPUTS` snippet you can drop into
[`../deterministic_grounding_spike/raw_slm_outputs.py`](../deterministic_grounding_spike/raw_slm_outputs.py)
to run the spike's true three-arm comparison on real device data.

---

## 6. Record, do not conclude

- Fill measured numbers into [`m0_measurement_checklist.md`](../m0_measurement_checklist.md) (A/B/C/D/E) and
  [`result_recording_template.md`](../result_recording_template.md).
- **Do not** edit `research.md` conclusions or flip G-M0 from a single run. The gate decision is made
  separately after the raw-vs-deterministic comparison is reviewed together.

---

## 7. Safety checklist for this runbook

- [ ] `useIntentJsonProbe` set back to `false` after the run (normal 001 chat restored).
- [ ] No production route, screen, or pipeline was added — only config flips + log capture.
- [ ] No SQL, no DB connection, no data retrieval anywhere in the run.
- [ ] `research.md` untouched; G-M0 still pending.
