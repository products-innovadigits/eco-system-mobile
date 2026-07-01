# Test Strategy: Hybrid Grounded Intent Pipeline

**Feature**: `003-hybrid-grounded-intent`

## Inputs

First regression sources:

- `systems/project_management/assets/ai/schema/projects_db_metadata_schema.json` (source schema metadata for the catalog)
- `specs/002-slm-db-schema-intent-json/m0_probe/m0_golden_questions.md`
- `specs/002-slm-db-schema-intent-json/m0_probe/schema_slice_summary.md`
- `specs/002-slm-db-schema-intent-json/m0_probe/device_run/out/device_run_results.depth0_1024_real.md`
- `specs/002-slm-db-schema-intent-json/m0_probe/deterministic_grounding_spike/spike_out/spike_report.md`

## Four mandatory failure classes

Every level below MUST prove these grounded outputs (see `contracts/final_intent_json_contract.md`):

1. **Lookup via outgoing FK** — `give me low priorities projects` → `PeriortyLevels.Name eq "أولوية منخفضة"` via `Projects → PeriortyLevels`. Also `مشاريع عالية الخطورة` → `RiskLevels.Name eq "مخاطر عالية"` via `Projects → RiskLevels`.
2. **Entity detail** — `what is the budget of أتمتة العقود والقوانين` → `get_record_detail`, `selected_fields=[Projects.Budget]`, `Projects.Name eq "أتمتة العقود والقوانين"` (exact Arabic), `entities["@ENTITY_1"]` verbatim.
3. **Reverse-FK aggregation** — `اكثر المشاريع تقدما من حيث المخرجات` → `count(ProjectOutPutModels.Id) as output_count` via `Projects.Id → ProjectOutPutModels.ProjectId`, `sort output_count desc`.
4. **Ambiguity / concept confusion** — `المهمة` / `الهامة` → `needs_clarification` (risk vs priority), never an arbitrary pick.

## Test Levels

### Unit Tests

- `schema_catalog_loader_test`: version match, exclusions honored, lookups present, relationship/lookup/path referential integrity, offline (no network).
- `schema_graph_test`: direct columns; outgoing FK (`Projects → PeriortyLevels`, `Projects → RiskLevels`); incoming/reverse FK (`Projects.Id → ProjectOutPutModels.ProjectId`); depth-1 path (v1; depth-N is future scope); aggregation targets; refusal to synthesize undeclared edges.
- `question_normalizer_test`: tashkeel stripping, alef/hamza/ya variants, Latin casing, `ar`/`en`/`mixed` detection.
- `entity_extractor_test`: quoted and heuristic spans, `@ENTITY_n` numbering, verbatim preservation, no translation, correct entity map.
- `concept_matcher_test`: synonym/tag matching for priority/risk/budget/outputs/etc.; risk↔priority conflict flag.
- `lookup_matcher_test`: exact/normalized/fuzzy-safe approved-value matching; rejection of invented values (`الهامة`) and raw FK IDs (`1`).
- `candidate_retriever_test`: typed candidates with correct IDs for all four classes; every candidate grounded-by-construction.
- `candidate_ranker_test`: single-candidate selection, ambiguous handling, thresholds.
- `candidate_menu_renderer_test`: compact format, placeholder shown (never raw value), relationship aliases, menu smaller than full schema.
- `slm_selection_parser_test`: bare-string and object ID forms, ignored/flagged stray free-form schema text, invalid intent handling.
- `grounded_intent_validator_test`: every error code — `empty_table`, `empty_column`, `unknown_table`, `unknown_column`, `missing_relationship`, `invalid_lookup_value`, `invented_lookup_value`, `raw_lookup_id`, `operator_type_mismatch`, `entity_value_modified`, `aggregation_unrelated_table`, `ungrounded_sort_or_group`, `sql_fragment`, `invented_reference`, `candidate_not_found`, `ambiguous_concept`, `unsupported_request`, `parse_error`.
- `grounded_intent_assembler_test`: candidate-ID expansion, entity substitution, relationships implied by filters/aggregations, `fully_grounded` and `status` selection.
- `grounded_intent_mode_separation_test`: free-text chat path unchanged unless grounded mode is explicitly selected.

### Golden Regression Tests

Convert `m0_golden_questions.md` + the four failure classes into a CI-safe fixture of expected Final Intent JSON. Mandatory pass cases:

- Lookup: low priority (ar/en), high risk (ar/en), other lookup concepts (department, category, lifecycle).
- Entity detail: budget-of-named-project (exact Arabic entity).
- Reverse-FK aggregation: most/least outputs.
- Ambiguity: `المهمة`, `الهامة` → clarification.
- Unsupported: weather, poetry, salaries, delete, SQL, schema introspection.

### Recorded Raw SLM Regression Tests

Use the parsed depth-0 @ 1024 real device outputs as **inputs the pipeline must not trust**:

- Empty table/column + copied lookup value → pipeline still emits the grounded filter + relationship from candidates.
- `PeriortyLevelId` with raw value `1` → pipeline emits the approved lookup value, never the raw id.
- Translated entity → pipeline uses the placeholder-preserved original; validator would reject a modified value.
- Fabricated `EndDate` filter → pipeline emits the reverse-FK aggregation instead.

Because the new architecture drives the SLM through a candidate menu, these tests use **fake SLM selections** (candidate IDs) rather than free-form JSON; the recorded free-form outputs are used to assert that even a pathological legacy output cannot inject an ungrounded reference.

### Manual Device Evaluation

Manual runs remain for latency and real selection behavior:

- Run a subset before release candidate; full golden set before production decision.
- Record p50/p90 latency, selection validity, grounding accuracy, entity-preservation rate, clarification/unsupported correctness.

## Scorecard Metrics

- total questions
- selection validity rate (all referenced IDs exist)
- fully-grounded rate (`grounding.fully_grounded=true`, zero errors)
- invented-reference rate (target: 0%)
- entity-modification rate (target: 0%)
- raw-lookup-id acceptance rate (target: 0%)
- relationship correctness rate (incl. reverse-FK aggregation)
- risk-vs-priority confusion count (target: 0)
- clarification correctness rate
- unsupported correctness rate
- free-text chat regression status
- p50/p90 latency

## CI Safety

CI MUST NOT run real model inference, connect to a database, generate SQL, use network, depend on a backend catalog, or require MCP. Use fake SLM selections and committed catalog/golden fixtures only.
