# Deterministic-Grounding Spike — Scope (dev-only, off-device)

**Feature:** `002-slm-db-schema-intent-json` · **Type:** measurement spike, **NOT** production implementation
**Status:** proposed (M0 support). Does not build the production Schema Router / Slicer / Validator / Repair / IntentService.

> Guardrails: dev-only/off-device experiment. No SQL, no DB connection, no data retrieval, no production pipeline code, no `research.md` conclusions, does not affect the app. G-M0 stays pending.

---

## 1. Purpose
The M0 device runs show the SLM produces valid JSON but **grounds unreliably** — e.g. "high risk" → `PeriortyLevelId` + invented value "الهامة". This spike tests, **before** committing to app implementation, whether **deterministic grounding** (data-driven matching, not prompt rules) reduces schema/value hallucination and risk-vs-priority confusion. It quantifies how much of the accuracy gap can be closed *without* changing the model, and what the SLM should still be responsible for.

## 2. Where it runs
A throwaway dev harness (e.g. a small local script / notebook, off-device) that reads the committed artifacts. It is **not** added to the Flutter app and **not** wired into the chat flow. No model call is required for the deterministic part; the "hybrid" comparison may reuse recorded device SLM outputs (from the golden-set runs) rather than calling the model live.

## 3. Inputs
- **Exported schema metadata JSON** — `assets/ai/schema/projects_db_metadata_schema.json` (tables, columns, types).
- **Lookup values** — the `lookup_values` section (e.g. `RiskLevels.Name`, `PeriortyLevels.Name`, `DepartmentLookups.Name`).
- **FK relationships** — the `schema_metadata.relationships` (e.g. `Projects.RiskLevelId → RiskLevels.Id`).
- **Golden questions** — `m0_golden_questions.md` (with expected fields), AR/EN/mixed.

## 4. Components to prototype (deterministic, data-driven)
1. **Question normalizer** — trim; normalize Arabic (alef/hamza/ya/ta-marbuta forms, strip tashkeel); lowercase Latin; detect language. No per-question logic.
2. **Business vocabulary lexicon** — a **data** map from concepts to synonyms/columns, e.g. `risk ↔ {خطورة, مخاطر, risk, severity} → RiskLevelId/RiskLevels`; `priority ↔ {أولوية, الهامة, هام, priority, importance} → PeriortyLevelId/PeriortyLevels`; `delayed/overdue ↔ {متأخر, overdue, late} → Projects.EndDate < today`; `manager ↔ {مدير, مسؤول, responsible, manager} → ManagerId/AspNetUsers`; `department ↔ {إدارة, قسم, department} → DepartmentLookups`. Editable by domain experts; the anti-hardcoding answer.
3. **Lookup-value matcher** — match phrases in the question to enumerated lookup values via exact + normalized + fuzzy/embedding similarity; return the **verbatim** allowed value (e.g. "عالية الخطورة" → `RiskLevels.Name = "مخاطر عالية"`). Never emits a value that isn't in the list.
4. **Schema / FK graph matcher** — given candidate columns/tables, resolve the `Projects → <lookup/table>` relationship path from the FK graph; reject references with no path.
5. **Simple candidate ranker** — score candidate (table, column, value, relationship) tuples by lexicon hit strength + lookup-match similarity + FK-path existence; produce a ranked shortlist and a confidence.
6. **Schema validator** — confirm every candidate table/column/value/FK exists; drop or flag anything that doesn't (the deterministic safety net).

## 5. Output (per question)
- Grounded **candidate table(s)** (e.g. `Projects`, `RiskLevels`).
- Candidate **filters** (`table.column operator value`) with **exact** lookup values only.
- **Exact lookup match(es)** (verbatim from the enumerated set) or "no match".
- **Relationship path** (`Projects → RiskLevels`) from the FK graph.
- **Confidence** score.
- **Ambiguity / clarification flag** (e.g. "important/الهامة" maps to both priority and, loosely, risk → needs_clarification).

## 6. Comparison (three arms, same golden questions)
- **Raw SLM** — the model's Intent JSON as-is (from device runs).
- **Deterministic grounding** — the harness output above (no model, or model only for intent-type).
- **Hybrid** — SLM proposes intent-type + structure; deterministic layer snaps values, tables, and relationships to real schema/lookups and validates.

Record per arm: schema-grounded %, invented-value %, risk-vs-priority confusion count, relationship-correct %, clarification correctness %, and (for hybrid) how much prompt/schema could be **reduced** because the router pre-selects the slice.

## 7. Success criteria
- **Risk-vs-priority confusion reduced** (target: near-zero in deterministic/hybrid arms vs the raw-SLM baseline).
- **No invented lookup value passes validation** (the "الهامة" class of error is rejected or snapped to a real value).
- **Invalid table/column/value rejected** by the validator (0 hallucinated references pass).
- **Ambiguous questions produce a clarification** flag rather than a confident wrong answer.
- **Reduced prompt size** — deterministic slice selection lets us send a smaller, more relevant schema slice to the model (helps the 1024/1280 budget), measured as tokens saved vs depth-0/-1.

## 8. Explicitly out of scope
- No production Schema Router / Schema Slicer / Validator / Repair / IntentService.
- No `intent/` production folder, no DI wiring, no app UI.
- No SQL, no DB connection, no data retrieval.
- No embeddings infra decision (a simple similarity is fine for the spike; production choice is later).
- No G-M0 decision; no `research.md` conclusions.

## 9. Deliverable
A short findings note (dev-only) with the three-arm comparison table and a recommendation: how much deterministic grounding closes the gap, what the SLM should still own, and whether a stronger/larger-context model is still warranted. Feeds the G-M0 discussion and the future production architecture (see `intent_json_technical_analysis.md` §6–7).
