# M0 Device-Run Support (T009b / T009c) — dev-only, off-device tooling

Support for running the **real-device** raw-SLM Intent JSON probe on the Samsung
Galaxy S22 Ultra and turning the captured logs into measurable, scored results
that are **directly comparable** to the deterministic-grounding spike.

**No Flutter/Dart code is added or changed by this tooling.** It reuses the
already-committed dev-only probe (`AiAssistantDevConfig` + `[AI_INTENT_PROBE]`
logs, commit `35609f0`) exactly as-is. It does **not** update `research.md` and
does **not** flip G-M0.

## Recommended approach: Option C (semi-automated)

| Option | Verdict |
|---|---|
| A — fully manual runbook | Fallback only (use if `adb` unavailable); record into [`../result_recording_template.md`](../result_recording_template.md). |
| B — in-app batch runner | **Rejected as too invasive** — re-introduces a dev screen / iteration controller into the `ai_assistant` production tree (the surface T009a deliberately removed) for zero measurement gain. |
| **C — log capture + off-device auto-scorer** | **Chosen.** Zero app-code change; reuses the existing one-shot probe + greppable logs; auto-scores with the spike's own schema graph → directly comparable arms. |

## Files

| File | Role |
|---|---|
| `m0_device_run_runbook.md` | Exact S22 Ultra steps: config knobs, `adb logcat` capture, capacity runs (A1–A4), golden-set run (D1–D3), revert. |
| `parse_probe_logs.py` | Off-device parser + auto-scorer. Extracts per-question fields from a captured logcat, maps question→golden id, and scores valid-JSON / schema-grounded / invented-value / relationship-correct / clarification-correct / risk-vs-priority-confusion using the **same** `schema_graph.py` + `golden_questions.py` as the deterministic spike. |
| `sample_logcat.txt` | Small synthetic capture (a grounded run, the known G01 failure output, and a depth-2 guard-block) so the parser can be demoed with no device. |
| `tests/test_parse_probe_logs.py` | 13 `unittest` cases (parsing, id mapping, JSON extraction, scoring, guard-block). |
| `out/` | Generated results land here. `device_run_results.sample_depth0@1024.{json,md}` is the committed demo; real `logcat_*.txt` captures and their outputs are dev scratch. |

## How to run (off-device)

```bash
cd specs/002-slm-db-schema-intent-json/m0_probe/device_run
python3 parse_probe_logs.py sample_logcat.txt --config-label sample_depth0@1024
python3 -m unittest discover -s tests -v
```

For a real run, capture with `adb logcat` per the runbook, then point the parser
at your capture file. See [`m0_device_run_runbook.md`](./m0_device_run_runbook.md).

## Per-question fields recorded

question id · question text · depth · contextTokens · prompt length · estimated
tokens (`chars/3.5`; exact `sizeInTokens` is checklist item A5) · latency ·
raw output · valid-JSON · schema-grounded · invented-value · relationship-correct
· clarification-correct · risk-vs-priority-confusion · guard-block / error status.

## Comparison to the deterministic spike

Because the scorer imports the spike's `schema_graph.py` and `golden_questions.py`,
the **raw-SLM** numbers it produces line up field-for-field with the spike's
`spike_report.md` (schema-grounded %, invented-value %, risk-vs-priority confusion,
relationship %, clarification %). The parser also prints a ready-to-paste
`RAW_SLM_OUTPUTS` dict for
[`../deterministic_grounding_spike/raw_slm_outputs.py`](../deterministic_grounding_spike/raw_slm_outputs.py),
so once the real 50-question device outputs are captured they can drive the spike's
**true three-arm** (raw / deterministic / hybrid) comparison — replacing the current
n=1 raw baseline.

## Guardrails

Off-device only. No app code, no production route, no SQL, no DB, no retrieval.
`research.md` untouched. G-M0 stays **pending** — a single run does not flip the gate.
