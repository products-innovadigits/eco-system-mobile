# Quickstart — Schema-Aware Intent JSON (Projects POC)

**Feature**: `002-slm-db-schema-intent-json`

This is the do-first runbook: **prepare the schema sample**, **run the M0 gate**, then build the pipeline. Hard boundaries apply throughout: no SQL generation, no DB connection from Flutter, no retrieval, no MCP, no backend, no Python CLI, no clickable clarification UI, and the existing 001 free-text chat must keep working.

---

## 0. Prerequisites
- Feature 001 already provides the on-device runtime + an active **Qwen2.5 1.5B** model (do **not** switch model).
- Reference device: **Samsung Galaxy S22 Ultra** (for M0 + golden-set runs).
- Read-only SQL Server access **or** sign-off to use a contract-matching representative schema (see step 1).

---

## 1. Prepare the schema sample (DO FIRST)
1. Open `tools/schema_export/export_projects_schema.sql`.
2. Set the chosen **single root table** at the top (after manual discovery of candidates — do not assume it is named `projects`).
3. Run it **read-only** in SSMS/`sqlcmd`. It emits schema metadata (tables, columns, types, nullability, PKs, FKs, relationship paths) to **FK depth 2**, plus capped lookup values (`max_lookup_rows = 50`), with the denylist applied. Prefer `FOR JSON PATH`; assembling smaller sections and copying out is acceptable.
4. **Manually review** the output — confirm zero denylisted/sensitive fields and that it matches `contracts/schema_metadata_contract.md`.
5. Save the reviewed file to `systems/project_management/assets/ai/schema/projects_db_metadata_schema.json` and ensure it is listed under `pubspec.yaml` assets.
   - *No DB access yet?* Hand-author a representative file that matches the contract (label it representative); swap the real export in later — the stable contract makes this a drop-in.

---

## 2. Run the M0 Measurement Gate (mandatory, blocks the pipeline)
On the S22 Ultra with the current Qwen2.5 1.5B model, record answers in `research.md`:
1. **Context window**: measure/estimate the model's usable context (ekv) and the depth-2 slice size. Does depth-2 fit?
2. **Fallback ladder** (if depth-2 doesn't fit): apply in order — compact formatting → reduce lookup caps → **depth-1 slice**. Record the first step that fits.
3. **Generation path**: run the probe set through **strict-JSON prompting** and, if available, **structured output**; compare parse-success + schema-validity.
4. **Decision (G-M0)**: pick the generation path; confirm a fitting slice; record **keep current model** (a larger-context build is flagged only if depth-1 + compact + reduced caps still fails).

➡️ Do not build M2+ pipeline code until G-M0 is recorded.

---

## 3. Build the on-device pipeline (after G-M0)
Order: `schema_loader` → `schema_context_trimmer` → `intent_prompt_builder` + chosen `intent_generation_strategy` → `intent_parser` → `intent_validator` → `intent_repair` → `intent_service` → `intent_debug_view`. Register all via guarded lazy singletons in `project_management_locator.dart`. Reuse `LocalSlmService.generateText`; do not modify any 001 file.

---

## 4. Use the dev-only Intent Debug screen
1. Enable the Intent Debug flag (reuse the `poc_demo_flags.dart` style); the screen is not linked from production chat.
2. Type a projects question (AR / EN / mixed). Inspect the six panels: **trimmed schema context · raw model output · parsed Intent JSON · validation errors · repair result · latency**.
3. Try an ambiguous question → expect `needs_clarification` + well-formed `clarification_options`; an out-of-scope question → `unsupported` + reason.

---

## 5. Run the golden set + scorecard
1. Ensure `test/features/ai_assistant/intent/golden/intent_golden_set.json` has **≥50** questions across all categories (AR/EN/mixed, high-risk, delayed, status, owner, department, due-soon, count/list/summarize, ambiguous, unsupported).
2. Run them on the S22 Ultra; `intent_metrics.dart` produces the **scorecard** (validity rate, intent-match rate, repair rate, latency P50/P90, per-category).
3. Record the **Go/No-Go** decision with the scorecard.

---

## 6. Regression check (001 unaffected)
Open the normal AI Assistant chat and confirm offline free-text still works exactly as before. This must pass (SC-009).

---

## 7. CI tests (no real model, no network, no DB)
```bash
flutter test systems/project_management/test/features/ai_assistant/intent/
```
Uses a `FakeLocalSlmService` returning scripted outputs to cover loader, trimmer, parser, validator (hallucination + SQL-fragment cases), repair, service orchestration, and the debug widget. Real accuracy/latency are judged manually on-device, not in CI.

---

## Definition of done (POC)
- Reviewed schema asset committed; loads into a SchemaGraph.
- G-M0 recorded (context fit + generation path + keep-model decision).
- Pipeline produces contract-conforming Intent JSON; validator blocks hallucinated refs + SQL (100% on crafted cases).
- Dev Intent Debug screen shows all six panels.
- ≥50 golden questions scored on S22 Ultra; scorecard + Go/No-Go produced.
- No SQL generated, no DB connection from Flutter; 001 free-text chat unaffected.
