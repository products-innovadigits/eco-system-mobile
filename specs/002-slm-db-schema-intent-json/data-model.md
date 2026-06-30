# Phase 1 Data Model — Schema-Aware Intent JSON (Projects POC)

**Feature**: `002-slm-db-schema-intent-json` | **Date**: 2026-06-30

Entities for the on-device Intent path. All are plain Dart value types (no DB, no persistence). Field names are guidance for implementation; the **authoritative wire shapes** are in [contracts/](./contracts/).

---

## 1. Schema asset → SchemaGraph

### Schema Metadata File (asset, read-only)
`assets/ai/schema/projects_db_metadata_schema.json` — see `contracts/schema_metadata_contract.md`. Three sections (`schema_metadata`, `lookup_values`, `sample_values?`) + provenance.

### SchemaGraph (in-memory, parsed from the asset)
| Type | Fields | Notes |
|---|---|---|
| `SchemaGraph` | `rootTable: String`, `tables: Map<String,TableNode>`, `lookups: List<LookupSet>` | Built by `SchemaLoader`. |
| `TableNode` | `name`, `columns: List<ColumnNode>`, `primaryKey: List<String>`, `foreignKeys: List<FkEdge>` | |
| `ColumnNode` | `name`, `dataType: String`, `nullable: bool`, `isLookup: bool` | `dataType` drives operator compatibility. |
| `FkEdge` | `fromTable`, `fromColumns: List<String>`, `toTable`, `toColumns: List<String>` | Directed; traversed both ways for path checks. |
| `LookupSet` | `table`, `column`, `values: List<String>` (≤ cap) | Used for lookup-value validation. |

**Query helpers (used by trimmer + validator):**
- `bool hasTable(String t)` / `bool hasColumn(String t, String c)`
- `bool fkPathExists(String a, String b)` — BFS over FK edges (depth-bounded)
- `Set<String> neighbors(String table, {int depth})` — for slicing
- `bool operatorAllowed(ColumnNode c, String op)` — type→operator rules (D6)
- `bool lookupHasValue(String table, String col, String value)`

### Validation rules (load time)
- File must declare a supported `schema_version`; unknown major → reject with a clear error.
- `root_table` must exist in `schema_metadata`.
- Every FK `toTable`/`toColumns` must resolve within the file (else flagged, tolerated for slicing but reported).
- Lookup sets must not exceed the declared `max_lookup_rows`.

---

## 2. Intent JSON (model output)

Authoritative shape: `contracts/intent_json_contract.md`. Dart model mirrors it 1:1.

| Type | Fields |
|---|---|
| `Intent` | `schemaVersion`, `status: IntentStatus`, `language: IntentLanguage`, `intent: IntentType`, `rootTable: String?`, `targetTables: List<String>`, `selectedFields: List<FieldRef>`, `filters: List<Filter>`, `relationships: List<Relationship>`, `aggregations: List<Aggregation>`, `dateRange: DateRange?`, `sort: List<SortSpec>`, `limit: int?`, `confidence: double`, `needsClarification: bool`, `clarificationQuestion: String?`, `clarificationOptions: List<ClarificationOption>`, `unsupportedReason: String?`, `validationErrors: List<ValidationError>` |
| `FieldRef` | `table`, `column` |
| `Filter` | `table`, `column`, `operator`, `value` |
| `Relationship` | `fromTable`, `toTable` |
| `Aggregation` | `type` (count/sum/avg/min/max), `table?`, `column?` |
| `DateRange` | `field?`, `from?`, `to?`, `relative?` (e.g. "due_soon") |
| `SortSpec` | `table`, `column`, `direction` (asc/desc) |
| `ClarificationOption` | `id`, `type` (root_table/table/column/filter…), `table`, `displayLabel: {ar,en}`, `reason`, `confidence` |
| `ValidationError` | `code` (unknown_table/unknown_column/no_fk_path/operator_type_mismatch/unknown_lookup_value/sql_fragment/unknown_reference), `reference`, `message` |

### Enumerations
- `IntentStatus`: `ok | needs_clarification | unsupported | invalid_schema_reference`
- `IntentLanguage`: `ar | en | mixed`
- `IntentType`: `list_records | count_records | summarize_records | get_record_detail | compare_records | unknown`

### State / status derivation (validator)
```
parse fail (after 1 repair)            → status = invalid_schema_reference (parse_error in validationErrors)
unknown table/column/fk/lookup OR sql  → status = invalid_schema_reference
well-formed + grounded + ambiguous     → status = needs_clarification (needsClarification=true, options set)
out-of-scope                           → status = unsupported (unsupportedReason set, intent=unknown)
clean + grounded + answerable          → status = ok
```

---

## 3. Evaluation entities (golden set + scorecard)

| Type | Fields |
|---|---|
| `GoldenSetItem` | `id`, `question`, `language`, `category` (e.g. high_risk, delayed, status, owner, department, due_soon, count, list, summarize, ambiguous, unsupported), `expected` (`status` + optional `intent`/`rootTable`/key fields, or `unsupported`/`needs_clarification`) |
| `Scorecard` | `total`, `validityRate`, `intentMatchRate`, `repairRate`, `latencyP50Ms`, `latencyP90Ms`, `perCategory: List<CategoryScore>` |
| `CategoryScore` | `category`, `count`, `validityRate`, `intentMatchRate` |
| `IntentMetric` (per run) | `questionId?`, `language`, `status`, `repaired: bool`, `latencyMs`, `valid: bool` |

Scoring is computed by `intent_metrics.dart` over the golden-set run output; produced manually on the S22 Ultra (not CI).

---

## 4. Relationships (entity graph)

```
SchemaMetadataFile ──parsed by SchemaLoader──▶ SchemaGraph
SchemaGraph ──sliced by SchemaContextTrimmer──▶ trimmed schema text
trimmed schema text + question ──IntentPromptBuilder──▶ prompt
prompt ──IntentGenerationStrategy(LocalSlmService.generateText)──▶ raw text
raw text ──IntentParser──▶ Intent (candidate)
Intent + SchemaGraph ──IntentValidator──▶ Intent (validated) | errors
errors ──IntentRepair(one retry)──▶ Intent (final)
Intent (final) ──IntentMetrics──▶ IntentMetric ──aggregate──▶ Scorecard
GoldenSetItem.expected ⟷ Intent (final)  (scoring comparison)
```

All flow is orchestrated by `IntentService`; `IntentInferenceController` is the dev-only entry that wires it to the debug screen. None of these touch the 001 free-text path.
