# M0 Result Recording Template

Fill one row per (question × prompt variant). Run all 15 questions on **depth-2**
first; if depth-2 does not fit context or quality is poor, repeat on **depth-1**.
**Do not edit `research.md` or mark T007/T008/T009 yet** — record here, then we
analyze together and update the gate.

## Device / setup (fill once)
- Device: Samsung Galaxy S22 Ultra
- App build / commit: `__________`
- Active model (confirmed in AI Assistant): `Qwen2.5 1.5B`  → confirmed? [ ]
- Generation path tested: [ ] strict-JSON prompt   [ ] structured-output (if available)
- Date/time of run (local): `__________`
- Approx. context window observed / known for this model build: `__________` tokens
- Approx. prompt size — depth-2: `~_____` tokens · depth-1: `~_____` tokens
  (rough estimate = characters ÷ 3.5; the depth-2 prompt file is ~`_____` chars)

## Results table

| QID | Variant (d2/d1) | Valid JSON (Y/N) | Schema-grounded (Y/N) | Hallucinated table/col (Y/N + which) | Latency (s) | Status returned | Notes |
|-----|-----------------|------------------|-----------------------|--------------------------------------|-------------|-----------------|-------|
| Q01 | d2 |  |  |  |  |  |  |
| Q02 | d2 |  |  |  |  |  |  |
| Q03 | d2 |  |  |  |  |  |  |
| Q04 | d2 |  |  |  |  |  |  |
| Q05 | d2 |  |  |  |  |  |  |
| Q06 | d2 |  |  |  |  |  |  |
| Q07 | d2 |  |  |  |  |  |  |
| Q08 | d2 |  |  |  |  |  |  |
| Q09 | d2 |  |  |  |  |  |  |
| Q10 | d2 |  |  |  |  |  |  |
| Q11 | d2 |  |  |  |  |  |  |
| Q12 | d2 |  |  |  |  |  |  |
| Q13 | d2 |  |  |  |  |  |  |
| Q14 | d2 |  |  |  |  |  |  |
| Q15 | d2 |  |  |  |  |  |  |

### Depth-1 fallback (only if depth-2 doesn't fit or quality is weak)

| QID | Variant (d2/d1) | Valid JSON (Y/N) | Schema-grounded (Y/N) | Hallucinated table/col (Y/N + which) | Latency (s) | Status returned | Notes |
|-----|-----------------|------------------|-----------------------|--------------------------------------|-------------|-----------------|-------|
| Q01 | d1 |  |  |  |  |  |  |
| Q02 | d1 |  |  |  |  |  |  |
| Q12 | d1 |  |  |  |  |  |  |
| … | d1 |  |  |  |  |  |  |

## Raw outputs
Paste the model's raw output verbatim per question (so we can check JSON parsing
and schema-grounding precisely).

```
Q01 (d2):
<paste raw output>

Q02 (d2):
<paste raw output>
...
```

## Roll-up (fill after the run — for analysis, NOT a gate decision)
- Valid-JSON rate (d2): `____ / 15`
- Schema-grounded rate (d2): `____ / 15`
- Hallucination count (d2): `____`
- Median latency (d2): `____ s`
- Did depth-2 fit the context window? [ ] yes  [ ] no → depth-1 used
- If depth-1 used: valid-JSON rate (d1): `____ / __`, hallucination count (d1): `____`
- Strict-JSON vs structured-output (if both tried): which parsed more reliably? `______`

## Decision (DRAFT only — do not set G-M0 here)
- Proposed generation path: `strict-JSON` / `structured-output`
- Proposed schema depth for prompts: `depth-2` / `depth-1 fallback`
- Keep current Qwen2.5 1.5B? `yes` / `needs larger-context build (e.g. ekv4096)`
- Open concerns: `__________`

> G-M0 stays **pending** until these results are reviewed and `research.md` is
> updated with the final decision in a separate step.
