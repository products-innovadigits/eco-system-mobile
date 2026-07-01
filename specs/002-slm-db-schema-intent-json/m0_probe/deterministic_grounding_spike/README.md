# Deterministic-Grounding Spike (T009d) — dev-only, off-device

**Do not confuse this with production code.** This is a throwaway measurement
harness for M0 task **T009d**. It is plain Python (stdlib only — no
dependencies to install), lives entirely under `specs/`, is **not** part of
the Flutter app, and is **not** wired into `intent/`, DI, or any UI. It makes
no SQL, no DB connection, no network call. See
[deterministic_grounding_spike_scope.md](../deterministic_grounding_spike_scope.md)
and
[deterministic_grounding_spike_execution_plan.md](../deterministic_grounding_spike_execution_plan.md)
for the scope this implements.

It does **not** update `research.md` and does **not** flip G-M0. G-M0 remains
pending until T007/T008 (real device measurements) are recorded.

## Components (matches the execution plan §3)

| File | Role |
|---|---|
| `normalizer.py` | Question normalizer — strips tashkeel, collapses alef/hamza/ya/ta-marbuta variants, lowercases Latin, detects ar/en/mixed. |
| `lexicon.py` | Business vocabulary lexicon — data-driven concept → synonyms → schema target map (risk, priority, department, manager, delayed, lifecycle, category, budget, dates), plus the ambiguous/status/unsupported/size term buckets. |
| `lookup_matcher.py` | Lookup-value matcher — exact → normalized → fuzzy (`difflib`) matching that only ever returns a value copied verbatim from the schema's enumerated lookup list, or no match. |
| `schema_graph.py` | Schema/FK graph matcher — loads `projects_db_metadata_schema.json`, builds table/column/FK adjacency, BFS path resolution, lookup-value access. |
| `ranker.py` | Simple candidate ranker — combines the above into candidate tables/filters/relationships + a confidence score + a clarification flag. This is the "deterministic grounding" arm. |
| `validator.py` | Schema validator — independent safety net: re-checks every table/column/FK/lookup-value reference against the SchemaGraph and rejects SQL fragments. |
| `golden_questions.py` | Parses `../m0_golden_questions.md` (G01-G50) into structured items. |
| `raw_slm_outputs.py` | The one recorded raw on-device SLM output currently available (G01, from the execution plan's documented failure case). Add more entries here as real device runs (T009b/T009c) are captured. |
| `run_spike.py` | Runner — produces the three-arm comparison (raw / deterministic / hybrid) over all 50 golden questions and writes `spike_out/spike_report.{json,md}`. |
| `tests/test_spike.py` | Lightweight `unittest` tests for the harness itself (not part of the project's Dart/Flutter CI-safe test set). |

## How to run

```bash
cd specs/002-slm-db-schema-intent-json/m0_probe/deterministic_grounding_spike
python3 run_spike.py                       # produces spike_out/spike_report.{json,md}
python3 -m unittest discover -s tests -v   # runs the lightweight spike tests
```

No dependencies beyond the Python 3 standard library. Reads the committed
asset at `systems/project_management/assets/ai/schema/projects_db_metadata_schema.json`
and `../m0_golden_questions.md`; writes only into `spike_out/` (safe to delete
and regenerate).

## Important caveats (read before trusting the numbers)

1. **Only one recorded raw on-device SLM output exists** (G01), because the
   full golden-set device run (T009b/T009c) has not been performed yet. The
   "raw SLM" column in the report is therefore evidence from a single
   documented failure case, not a 50-question baseline. Treat the 100%
   invented-value / 1-confusion-count raw-arm numbers as "what we saw once",
   not a statistically meaningful baseline.
2. **The ranker's heuristics were iteratively tuned against this same
   50-question golden set** while building the spike (e.g. adding the
   "group by" / "vague reference" / size-ambiguous term buckets after seeing
   which golden items failed). The 100% deterministic pass rate should be
   read as "the harness can be made to fit this specific golden set", not as
   a claim that a production deterministic router would hit 100% on unseen
   questions. A real production spec would need a held-out set.
3. The "hybrid" arm can only meaningfully snap a recorded raw SLM envelope
   for G01; for all other questions it is reported as "deterministic-only,
   no SLM envelope recorded" (clearly labeled in the JSON output).
4. Known, accepted gaps (left as-is rather than special-cased further):
   manager/department free-text name matching is best-effort (`AspNetUsers`
   full names are not enumerated in the schema export), and vague qualifiers
   outside the lexicon (e.g. "expensive", "outputs") are not recognized.

## Output

`spike_out/spike_report.json` — full structured per-question record (question
id, original + normalized question, matched concepts, candidate root/tables/
filters, matched lookup values, relationship path, validation result,
confidence, clarification flag, expected-result summary, pass/fail, raw SLM
output if recorded, hybrid output, schema-slice size-reduction estimate) plus
an aggregate `summary` block.

`spike_out/spike_report.md` — human-readable three-arm comparison table, the
G01 worked case in full, and a per-question pass/fail table.

This harness (and `spike_out/`) may be deleted once the findings have been
reviewed; nothing outside `specs/002-slm-db-schema-intent-json/m0_probe/`
depends on it.
