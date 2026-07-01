# Migration Plan: From Spike to Catalog-Driven Production Pipeline

**Feature**: `003-hybrid-grounded-intent`

Two migrations converge in this feature:

1. **Python spike → production Dart.** The deterministic grounding spike under `specs/002-slm-db-schema-intent-json/m0_probe/deterministic_grounding_spike/` proved normalization, lookup matching, schema-graph resolution, ranking, and validation. It is dev-only Python and must not be imported, executed, or shipped.
2. **"SLM drafts JSON → corrector" → "candidate-ID selection + deterministic assembler."** The earlier 003 draft asked the SLM to draft Intent JSON and then corrected it. This revision removes free-form schema generation from the SLM entirely: deterministic code builds a candidate menu, the SLM selects IDs, and a deterministic assembler produces the Final Intent JSON. The corrector is replaced by a validator + assembler.

## Migration Principles

1. Port **behavior**, not Python files.
2. Keep all production code under the Flutter feature module `grounded_intent/`.
3. Ground everything through the local **Schema Catalog** asset; retrieval reads only the catalog.
4. Preserve safety boundaries: no SQL, DB, backend, backend catalog API, MCP, or data retrieval.
5. Keep free-text chat separate from grounded intent mode.
6. The SLM never emits schema names — it selects candidate IDs only.
7. Exact entity values are placeholder-protected and never translated.

## Source-to-Target Mapping

| Python spike | Production Dart target |
|---|---|
| `normalizer.py` | `grounded_intent/question_normalizer.dart` |
| `lexicon.py` | enrichment data in `assets/ai/schema/schema_enrichment.json` + `retrieval/concept_matcher.dart` |
| `lookup_matcher.py` | `retrieval/lookup_matcher.dart` |
| `schema_graph.py` | `catalog/schema_graph.dart` (+ generated `schema_catalog.json`) |
| `ranker.py` | `retrieval/candidate_ranker.dart` |
| `validator.py` | `grounded_intent_validator.dart` |
| `raw_slm_outputs.py` | test fixtures under `test/.../grounded_intent/fixtures/` |
| `golden_questions.py` | `evaluation/golden_question_loader.dart` + JSON fixture |
| `run_spike.py` | `evaluation/grounded_intent_scorecard.dart` |
| (new) candidate menu + selection | `menu/`, `slm/`, `grounded_intent_assembler.dart` |

## Conceptual mapping: corrector → validator + assembler

| Old draft concept | New concept |
|---|---|
| SLM drafts full Intent JSON | SLM selects candidate IDs only |
| Corrector "snaps" model fields to deterministic candidates | Assembler expands validated candidate IDs; nothing to snap |
| `merge_safe_fields` / `accept_model` | Not applicable — model never supplies schema fields |
| Correction action distribution metric | Selection-validity + fully-grounded metrics |
| Trust boundary inside the JSON | Trust boundary at the candidate menu (grounded-by-construction) |

## Migration Phases

### Phase A — Catalog first

- Author `schema_enrichment.json`; build the catalog generator; generate and commit `schema_catalog.json`.
- Register assets in `pubspec.yaml`.
- Capture golden questions, recorded raw SLM outputs, expected final intents, and fake SLM selections as fixtures.

### Phase B — Catalog + graph + normalization + entities

- Port catalog loading and SchemaGraph (direct columns, outgoing FKs, incoming/reverse FKs, paths, aggregation targets).
- Port normalization; add entity extraction with `@ENTITY_n` placeholders.

### Phase C — Retrieval + menu

- Port concept and lookup matching (approved-value-only).
- Add candidate retrieval (typed, grounded-by-construction) and ranking.
- Add candidate menu rendering.

### Phase D — Selection + validation + assembly

- Add selection prompt builder and selection parser (IDs only).
- Port validator; add assembler that expands IDs, substitutes entities, and sets `fully_grounded`/`status`.

### Phase E — Mode boundary

- Add explicit grounded intent mode service/controller; prove free-text chat unchanged when disabled.
- Optional dev/evaluation UI only behind a debug flag.

### Phase F — Evaluation

- Implement golden scorecard; run CI-safe golden tests with fake SLM selections; run manual device evaluation for latency and real behavior.

## Do Not Migrate

- Python runner scripts and test harness.
- Any code that writes spike reports.
- Any behavior tuned to the full golden set without held-out validation.
- The earlier "SLM drafts JSON then correct" flow — it is superseded.

## Production Hardening Gaps

- Add a held-out question set before release.
- Add regression tests for additional Arabic spelling variants and entity-detection edge cases.
- Document confidence thresholds and the ambiguity rule.
- Add catalog-version compatibility handling and a stale/missing-catalog error UX for grounded intent mode.
- Decide catalog regeneration cadence when the source schema changes.
