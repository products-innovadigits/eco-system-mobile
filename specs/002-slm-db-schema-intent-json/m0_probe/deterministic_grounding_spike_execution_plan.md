# Deterministic-Grounding Spike — Execution Plan (dev-only, off-device)

**Feature:** `002-slm-db-schema-intent-json` · Corresponds to M0 task **T009d** · **Type:** measurement spike, NOT production.
**Status:** ready to execute. This is the runnable plan for the scope in
[deterministic_grounding_spike_scope.md](./deterministic_grounding_spike_scope.md).

> Hard gate: off-device dev harness only. No production Schema Router/Slicer/Validator/Repair/IntentService, no
> `intent/` folder, no Flutter wiring, no app UI, no SQL, no DB, no data retrieval, no `research.md` conclusions,
> G-M0 stays pending. The harness may be deleted after the findings are recorded.

## 0. Why (device evidence that motivates this)
On-device Qwen2.5 1.5B, question **"مشاريع عالية الخطورة"**, three identical greedy runs returned:
`filters=[{table:"", column:"PeriortyLevelId", value:"الهامة"}], relationships:[], confidence:1.0`.
Expected: `RiskLevels.Name="مخاطر عالية"`, `Projects→RiskLevels`. The depth-0 prompt rule did **not** fix it, and
decoding is greedy (topK=1) so re-running cannot help. Conclusion: grounding must be done deterministically, not by
the model. This spike measures how much a deterministic layer recovers **before** any production build.

## 1. Environment
- A throwaway dev script/notebook (language free — Python or Dart CLI), run on a laptop. **Not** added to the app.
- Read-only inputs from the repo; write outputs only to `specs/002-slm-db-schema-intent-json/m0_probe/spike_out/` (dev artifacts) or a scratch dir.
- No model call is required for the deterministic arm; the hybrid arm reuses **recorded** device SLM outputs.

## 2. Inputs
| Input | Source |
|---|---|
| Schema metadata (tables, columns, types) | `systems/project_management/assets/ai/schema/projects_db_metadata_schema.json` → `schema_metadata.tables[]` |
| Lookup values | same file → `lookup_values[]` (e.g. `RiskLevels.Name`, `PeriortyLevels.Name`, `DepartmentLookups.Name`) |
| FK relationships | same file → `schema_metadata.relationships[]` (e.g. `Projects.RiskLevelId → RiskLevels.Id`) |
| Golden questions + expected | `m0_golden_questions.md` (G01–G50) |
| Recorded raw SLM outputs | device logs / `result_recording_template.md` (start with G01; add more as captured) |

## 3. Components to prototype (deterministic, data-driven — dev-only)
Build these as small pure functions/modules in the harness (no app coupling):
1. **Question normalizer** — trim; normalize Arabic ( alef/hamza/ya/ta-marbuta), strip tashkeel; lowercase Latin; detect language.
2. **Business-vocabulary lexicon** (data file, editable): concept → synonyms → schema target. Seed:
   - `risk → {خطورة, مخاطر, خطر, risk, severity} → column RiskLevelId / table RiskLevels`
   - `priority → {أولوية, الأولوية, هام, الهامة, مهم, priority, importance} → column PeriortyLevelId / table PeriortyLevels`
   - `department → {إدارة, قسم, department} → DepartmentLookups`
   - `manager/responsible → {مدير, المسؤول, responsible, manager} → ManagerId / AspNetUsers`
   - `delayed/overdue → {متأخر, overdue, late, تأخر} → Projects.EndDate < today`
3. **Lookup-value matcher** — for each candidate lookup column, match question phrases to enumerated values via
   exact → normalized → fuzzy (e.g. token/edit similarity). Return the **verbatim** allowed value or "no match".
   (e.g. "عالية الخطورة" + risk concept → `RiskLevels.Name = "مخاطر عالية"`.)
4. **Schema / FK graph matcher** — build an adjacency map from `relationships[]`; resolve the `Projects → <table>` path;
   reject any table/column with no path or not in the schema.
5. **Simple candidate ranker** — score `(table, column, value, relationship)` tuples by: lexicon hit strength +
   lookup-match similarity + FK-path existence. Output a ranked shortlist + a confidence in [0,1].
6. **Schema validator** — assert every referenced table/column/value/FK exists; drop/flag anything that fails.

## 4. Three arms (per golden question)
- **Arm 1 — Raw SLM:** the model's Intent JSON as recorded from the device (fence-stripped). No changes.
- **Arm 2 — Deterministic:** harness output only (no model; model may still supply `intent`/`language` if desired,
  but tables/columns/values/relationships come from the deterministic components).
- **Arm 3 — Hybrid:** take the SLM's envelope (`intent`, `root_table`, `language`, JSON shape) but **snap** every
  filter table/column/value and relationship to the deterministic result; run the validator; if a value can't be
  snapped to a real lookup → set `needs_clarification` instead of emitting an invented value.

## 5. Output per question (all arms)
`{ candidate_tables[], candidate_filters[{table,column,operator,value}], exact_lookup_matches[], relationship_path[], confidence, ambiguity_flag }`

## 6. Metrics (aggregate across the run)
Per arm: **schema-grounded %**, **invented-value %**, **risk-vs-priority confusion count**, **relationship-correct %**,
**clarification-correctness %** (ambiguous/unsupported handled right), and for hybrid, **prompt-size reduction** (tokens
saved by sending only the router-selected slice vs depth-0/-1). Compare arms side by side.

## 7. Worked example — G01 "مشاريع عالية الخطورة" (the failure case)
| Step | Result |
|---|---|
| Normalize | `مشاريع عاليه الخطوره` (tashkeel/hamza normalized), lang=ar |
| Vocabulary | matches `risk` concept (خطورة) → RiskLevelId / RiskLevels; does NOT match priority |
| Lookup match | "عالية الخطورة" vs `RiskLevels.Name` → best = **"مخاطر عالية"** (high similarity); vs `PeriortyLevels.Name` → low |
| FK graph | `Projects.RiskLevelId → RiskLevels.Id` exists |
| Ranker | top candidate: filter `RiskLevels.Name eq "مخاطر عالية"`, rel `Projects→RiskLevels`, confidence high |
| Validator | value ∈ RiskLevels.Name ✅ |
| **Deterministic/Hybrid output** | `RiskLevels.Name eq "مخاطر عالية"` + `Projects→RiskLevels` ✅ (vs Raw SLM: PeriortyLevelId + "الهامة" ❌) |
Expected pass: risk/priority confusion → resolved; invented value "الهامة" → rejected (not in lookups) and replaced by the real match.

## 8. Execution steps
1. Load inputs (§2); build the lexicon data file (§3.2).
2. Implement §3 components as pure functions in the harness.
3. For each golden question: run Arm 2 (deterministic) and, where a recorded SLM output exists, Arm 1 (raw) and Arm 3 (hybrid).
4. Emit per-question §5 output + compute §6 metrics.
5. Write a **findings note** (dev-only) with the three-arm comparison table and a recommendation:
   - how much deterministic grounding closes the gap (target: risk/priority confusion → ~0, invented values → 0 passing validation);
   - what the SLM should still own (intent classification, language, JSON envelope, ambiguity interpretation given a shortlist);
   - whether a larger-context or stronger model is still warranted after grounding is deterministic;
   - prompt-size reduction achievable via router-selected slices.

## 9. Success criteria (from scope §7)
- Risk-vs-priority confusion **reduced to ~0** in deterministic/hybrid.
- **No invented lookup value passes validation** ("الهامة" rejected or snapped).
- Invalid table/column/value **rejected**.
- Ambiguous questions **return clarification** (not a confident wrong answer; kills the false `confidence:1.0`).
- **Prompt size reduced** via better slice selection.

## 10. Explicitly NOT in this spike
- No production Schema Router / Slicer / Validator / Repair / IntentService.
- No `intent/` folder, no DI, no Flutter wiring, no UI.
- No SQL, no DB, no data retrieval.
- No embeddings-infra decision (a simple similarity suffices; production choice is a later spec).
- No G-M0 flip; no `research.md` conclusions.

## 11. Decision this spike feeds
If the spike hits its success criteria, it justifies the production architecture in
[intent_json_technical_analysis.md](./intent_json_technical_analysis.md) §6–7 (deterministic pre-selection + validation
around the SLM) as a separate, post‑G‑M0 spec — **not** implemented now.
