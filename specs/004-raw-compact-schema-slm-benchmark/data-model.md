# Phase 1 Data Model: Raw No-Terms Compact Schema SLM Benchmark

This experiment has **no database and no persistent storage**. The "entities" below are in-memory
dev-only value holders and the manual scorecard structure. Nothing here is a production data model.

## Entities

### CompactSchema (input, opaque text)

| Field | Type | Notes |
|-------|------|-------|
| text | String | Raw contents of `nawah_compact_schema_no_terms.slim.v1.txt`, unchanged |
| charCount | int | `text.length`, logged per run |

- Loaded via `compact_schema_loader.dart`. Treated as opaque — **not parsed**.

### BenchmarkQuestion (input)

| Field | Type | Notes |
|-------|------|-------|
| id | int | 1..6, stable index into the benchmark set |
| text | String | The question, stored **verbatim** (Arabic or English) |

- The six questions are fixed constants (see `benchmark_questions.dart`). No normalization/translation.

### BenchmarkResultRecord (dev-only output, not persisted)

| Field | Type | Notes |
|-------|------|-------|
| questionId | int | Which of the six questions |
| questionText | String | Verbatim question |
| schemaCharCount | int | From CompactSchema |
| promptCharCount | int | Length of the assembled prompt |
| estimatedTokens | int? | `chars/4` heuristic if no tokenizer; labeled estimate |
| rawOutput | String | The model's response **verbatim**, no post-processing |
| latencyMs | int | Wall-clock generation latency |

- Held in memory / shown in the dev UI / logged to the dev sink. **Separate** from production
  `PocMetric` (which forbids prompt/response content).

### ResultScorecardRow (manual, human-filled — lives in quickstart.md, not code)

| Field | Type | Notes |
|-------|------|-------|
| questionId | int | 1..6 |
| rawOutput | String | Pasted verbatim |
| tablesCorrect | bool/enum | Human judgement |
| columnsCorrect | bool/enum | Human judgement |
| relationshipsCorrect | bool/enum | Human judgement |
| filtersEntitiesSortReasonable | bool/enum | Human judgement |
| failureNotes | String | Free text |

## Relationships

- `BenchmarkResultRecord.questionId` → `BenchmarkQuestion.id` (1:1 per run).
- `ResultScorecardRow.questionId` → `BenchmarkQuestion.id` (1:1 per run).
- `CompactSchema` is shared (single, same file) across all runs.

## Validation rules

**None.** Per FR-010 and the spec non-goals, the benchmark performs no validation, correctness
enforcement, or SQL-readiness checks. The only structural expectations (six sections in order) are
*human-judged*, not machine-enforced.

## State transitions

None. Each run is stateless and independent (fresh session per question, per plan §7/R2).
