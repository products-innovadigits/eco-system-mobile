# Feature Specification: Schema-Aware Intent JSON Extraction (Projects POC)

**Feature Branch**: `002-slm-db-schema-intent-json`

**Created**: 2026-06-30

**Status**: Draft

**Input**: User description: "Schema-aware Intent JSON extraction from the on-device SLM for the projects domain (POC). First version uses a manually executed SQL Server export script (no automation tooling). Builds the Intent JSON / schema-awareness layer that feature 001 deferred. Reuses the on-device runtime and existing local SLM service from 001 and must not regress the existing offline free-text chat. Keep the current Qwen2.5 1.5B model. Produce validated Intent JSON only — no SQL generation, no DB connection from Flutter, no DB retrieval, no MCP, no backend handoff, no real data answer in chat, no Python CLI automation."

> **Scope note (POC):** This feature proves a single idea — *can a local small language model, given exported database schema metadata, understand a projects question (Arabic / English / mixed) and produce useful, validated Intent JSON?* The database schema is exported **manually** with a SQL Server script in this version; the on-device pipeline parses that exported file, builds a schema-aware prompt, generates Intent JSON, and validates/repairs it. Nothing connects to a live database, generates SQL, or returns real data. This is the layer feature [001](../001-local-slm-ai-assistant/spec.md) explicitly deferred.

---

## Clarifications

### Session 2026-06-30

- Q: First version of the schema extractor? → A: **Manually executed SQL Server export script** (SSMS / sqlcmd), developer-run, read-only. No Python CLI / automation in this spec.
- Q: Root table assumption? → A: **Single selected project root table for v1.** Developer discovers candidates manually and sets the chosen root at the top of the script. Do not assume the table is named "projects". JSON format must stay open to multiple roots/domains later.
- Q: JSON emission method? → A: Prefer SQL Server **`FOR JSON PATH`** where practical; it is acceptable to generate smaller JSON sections and manually assemble/review, or document a copy-out step. The final reviewed file must follow the **stable JSON contract** at `assets/ai/schema/projects_db_metadata_schema.json`.
- Q: Intent JSON contract — define now or later? → A: **Define the exact contract now** in this spec; parser, validator, repair, debug screen, golden set, and scorecard all depend on it. Include `needs_clarification` and `clarification_options` in the contract now, but **do not** build the clickable clarification UI here (deferred to `003-ai-clarification-loop`).
- Q: Context/token budget? → A: **No reliable number exists yet — measure empirically (M0)** with the current Qwen2.5 1.5B. Test FK depth 2, reduced lookup caps, compact formatting, and FK depth 1 fallback. Do not switch model at the start; a larger-context build (e.g. ekv4096) is a recorded fallback only if a clear issue appears.
- Q: Lookup cap and sensitive-data exclusion defaults? → A: **`maxLookupRows = 50`** by default; raw sample rows OFF by default. A documented, easy-to-edit **denylist** excludes sensitive tables/columns (password, token, secret, credential, national_id, email, phone, salary, etc.).
- Q: Multi-domain / multi-root extraction? → A: **Out of scope** — projects domain only, single root in v1; format designed to allow expansion later.

---

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Local SLM produces validated Intent JSON from a projects question (Priority: P1)

A developer/evaluator opens the dev-only Intent Debug screen, types a projects question in Arabic, English, or mixed language (e.g. "show me the high-risk projects that are delayed"), and the on-device model returns a structured Intent JSON object that correctly identifies the intent type, the relevant tables/columns/filters drawn from the exported schema, and is validated against that schema — with no live database involved.

**Why this priority**: This is the core hypothesis of the whole feature. If the local model cannot turn a natural-language projects question into useful, schema-grounded Intent JSON, nothing downstream (clarification loop, DB retrieval) is worth building. It is the minimum viable, independently demonstrable slice.

**Independent Test**: Place a valid exported schema JSON in assets, run the app on a Samsung Galaxy S22 Ultra, type a question on the Intent Debug screen, and confirm a parseable Intent JSON conforming to the contract is produced and shown — without any SQL, DB connection, or real data.

**Acceptance Scenarios**:

1. **Given** a valid projects schema JSON is loaded, **When** the evaluator asks "كم عدد المشاريع المتأخرة؟" (how many delayed projects), **Then** the output Intent JSON has `language: "ar"`, `intent: "count_records"`, a `root_table` and `filters` referencing only existing schema tables/columns, and `status: "ok"`.
2. **Given** a valid schema is loaded, **When** the evaluator asks an English question about project owners, **Then** the output references the correct owner/responsible-person table and column via an existing FK relationship path.
3. **Given** a question mixes Arabic and English, **When** it is submitted, **Then** `language: "mixed"` and the intent fields are still populated from the schema.

---

### User Story 2 - Manual SQL Server schema export produces a reviewed, contract-compliant JSON asset (Priority: P1)

A developer with read-only SQL Server access runs the provided manual export script in SSMS/sqlcmd, sets the chosen project root table at the top, runs it, manually reviews the output, and saves a contract-compliant metadata JSON into the Flutter assets — with no credentials and no sensitive data in the file.

**Why this priority**: The on-device pipeline (Story 1) cannot exist without real schema context. The exported JSON is the contract boundary between the (manual, off-device) extraction and the (on-device) intent pipeline, and it must be reviewable and safe before it is committed.

**Independent Test**: Run the script against a SQL Server instance, confirm it emits the three separated sections (schema metadata, lookup/reference values, optional samples) with tables/columns/types/nullability/PKs/FKs/relationship paths to FK depth 2, capped lookups (≤ `maxLookupRows`), and zero denylisted/sensitive fields; validate the file parses against the documented contract.

**Acceptance Scenarios**:

1. **Given** read-only DB access and a chosen root table, **When** the developer runs the script, **Then** the output JSON contains schema metadata for the root and its FK-depth-2 neighbors, including risk/status/priority/owner/department/progress/due-date related tables where present.
2. **Given** lookup tables exist, **When** the script runs, **Then** lookup/reference values are included but capped at `maxLookupRows` (default 50) per table and placed in a separate section.
3. **Given** columns matching the denylist (e.g. `password`, `email`, `national_id`), **When** the script runs, **Then** those columns/tables are excluded from the output.
4. **Given** the exported file, **When** it is parsed by the on-device loader, **Then** it conforms to the stable contract (schema_version, generated_at, chosen root, extraction summary, three sections).

---

### User Story 3 - Validator blocks hallucinated schema references and SQL fragments (Priority: P1)

When the local model invents a table, column, relationship, or lookup value that is not in the exported schema — or emits raw SQL — the validator detects it, marks the result accordingly, and a single bounded repair attempt is made; failures are surfaced, never silently accepted.

**Why this priority**: A schema-grounded intent that contains hallucinated references is worse than no answer, because later phases would act on it. Trustworthy validation is what makes the Intent JSON safe to build on.

**Independent Test**: Feed the validator hand-crafted Intent JSON containing (a) a non-existent table, (b) a non-existent column, (c) a missing FK path, (d) a type-incompatible operator, (e) a non-existent lookup value, and (f) an embedded SQL fragment; confirm each is rejected with a specific validation error and the appropriate status.

**Acceptance Scenarios**:

1. **Given** an Intent JSON referencing a table absent from the SchemaGraph, **When** validated, **Then** `status: "invalid_schema_reference"` with a `validation_errors` entry naming the unknown table.
2. **Given** an operator incompatible with a column's type (e.g. `>` on a text status column), **When** validated, **Then** validation fails with a type-mismatch error.
3. **Given** an output containing a raw SQL fragment (e.g. `SELECT ... FROM ...`), **When** validated, **Then** it is rejected.
4. **Given** an initial invalid output, **When** the pipeline runs, **Then** exactly **one** repair retry is attempted before the result is finalized as failed-with-errors.

---

### User Story 4 - Ambiguous and unsupported questions are represented in the contract (Priority: P2)

When a question is ambiguous (e.g. could mean projects or tasks) the model marks `needs_clarification: true` and produces `clarification_options` (with friendly Arabic/English labels and internal schema references); when a question is outside the supported projects scope, it returns `status: "unsupported"` with a reason. No clickable UI is built in this spec — only the structured output.

**Why this priority**: These states make the contract complete and forward-compatible with the next spec (`003-ai-clarification-loop`), but they are not the core hypothesis, so they sit just below the P1 slices.

**Independent Test**: Submit a deliberately ambiguous question and an out-of-scope question; confirm the first yields `needs_clarification: true` with well-formed `clarification_options`, and the second yields `status: "unsupported"` with `unsupported_reason`.

**Acceptance Scenarios**:

1. **Given** an ambiguous question, **When** processed, **Then** `needs_clarification: true`, `clarification_question` is set, and each `clarification_options` entry has `id`, `type`, `table`, bilingual `display_label`, `reason`, and `confidence`.
2. **Given** an out-of-scope question (e.g. "what's the weather"), **When** processed, **Then** `status: "unsupported"` with a non-null `unsupported_reason` and `intent: "unknown"`.
3. **Given** clarification options are produced, **When** validated, **Then** every referenced table in the options exists in the SchemaGraph.

---

### User Story 5 - Golden set + scorecard measure POC accuracy on-device (Priority: P2)

An evaluator runs a project-focused golden set of at least 50 questions through the pipeline on a real device and produces a scorecard summarizing intent accuracy, schema-reference validity, language handling, repair rate, and latency — to support a Go/No-Go decision.

**Why this priority**: The POC's purpose is a measured decision, not just a working demo. The scorecard converts Stories 1–4 into evidence, but it depends on them existing first.

**Independent Test**: Execute the golden set on a Samsung Galaxy S22 Ultra and confirm a scorecard is produced with per-category results (Arabic/English/mixed, high-risk, delayed, status, owner, department, due-soon, count/list/summarize, ambiguous, unsupported).

**Acceptance Scenarios**:

1. **Given** a golden set of ≥ 50 questions with expected fields, **When** run, **Then** a scorecard reports validity rate, intent-match rate, repair rate, and latency distribution.
2. **Given** the golden set covers all listed categories, **When** scored, **Then** each category has at least one representative item and a recorded result.

---

### Edge Cases

- **Schema too large for context**: If the FK-depth-2 schema slice exceeds the measured model context budget, the pipeline trims harder (reduce lookup caps, compact formatting) and falls back to an FK-depth-1 slice for the prompt; the behavior is observable in the debug screen.
- **Malformed / missing schema asset**: If the schema JSON is absent or fails contract validation, the pipeline reports a clear error and does not attempt generation; the existing free-text chat is unaffected.
- **Model returns non-JSON or truncated JSON**: The parser fails gracefully; one repair retry is attempted; if still unparseable, the result is surfaced as a parse failure with the raw output visible in the debug screen.
- **Empty / whitespace question**: Rejected before generation with a clear message.
- **Lookup value referenced that doesn't exist**: Treated as a hallucinated reference → `invalid_schema_reference`.
- **Sensitive data accidentally present in exported file**: Caught during manual review; denylist documented and easy to edit; file is not committed until clean.
- **Device unsupported / model not active (from 001)**: The Intent flow requires an active local model; if none is active, the user is routed to the existing 001 model selection rather than crashing.
- **Concurrent requests**: A new generation cannot start while one is in progress (consistent with 001's send-gating).

## Requirements *(mandatory)*

### Functional Requirements — Manual Schema Export (Component A, off-device)

- **FR-001**: A manually executed SQL Server script MUST export project-related schema metadata using read-only access (SSMS / sqlcmd), and MUST NOT be invoked from the Flutter app.
- **FR-002**: The script MUST allow the developer to set a single chosen project **root table** at the top (manual discovery of candidates supported), and MUST NOT assume the root is named "projects".
- **FR-003**: Extraction MUST traverse foreign-key relationships to **depth 2** from the chosen root, prioritizing tables/columns related to risk, status, priority, owner/responsible person, department, progress, and due dates.
- **FR-004**: The exported metadata MUST include, per table: table identity, columns, data types, nullability, primary keys, foreign keys, and relationship paths.
- **FR-005**: The export MUST include capped DISTINCT **lookup/reference values** for small non-sensitive project-related reference tables (status, risk level, priority, workflow/status labels, non-sensitive department labels), with a configurable cap defaulting to **`maxLookupRows = 50`** per table.
- **FR-006**: Raw transactional **sample rows** MUST be OFF by default; if explicitly enabled they MUST be capped and explicitly reviewed before committing.
- **FR-007**: The export MUST apply a documented, easy-to-edit **denylist** that excludes sensitive tables/columns matching at least: password, pass, pwd, token, secret, api_key, access_key, refresh_token, connection, connection_string, credential, private, ssn, national_id, passport, phone, mobile, email, address, salary, payment, card, tenant_secret, auth, otp, session, cookie.
- **FR-008**: The export MUST NEVER include credentials, tokens, passwords, connection strings, secrets, private URLs, tenant secrets, or sensitive personal data, and DB credentials MUST stay outside the repository and outside Flutter.
- **FR-009**: The export MAY use SQL Server `FOR JSON PATH` where practical, and MAY generate smaller JSON sections that are manually assembled/reviewed or copied out; the developer MUST review the result before committing.
- **FR-010**: The final reviewed file MUST be saved at `assets/ai/schema/projects_db_metadata_schema.json` and MUST follow the stable JSON contract: top-level `schema_version`, `generated_at`, chosen root table, an extraction summary (depth, caps, denylist applied), and three clearly separated sections — (1) schema metadata, (2) lookup/reference values, (3) optional sample values (present only when enabled).
- **FR-011**: The JSON contract MUST be stable and future-ready so a later automated CLI or backend/API can generate an identical file without changing the on-device parser, and MUST be structured to allow multiple roots/domains in the future even though v1 uses a single root.

### Functional Requirements — On-Device Intent Pipeline (Component B, Flutter)

- **FR-012**: The app MUST load the schema JSON from assets at runtime and parse it into an in-memory **SchemaGraph** (tables, columns, types, FK paths, lookup values).
- **FR-013**: The app MUST build a **schema-aware prompt** consisting of a system instruction, a trimmed schema slice, and the user question, and MUST handle Arabic, English, and mixed input.
- **FR-014**: The app MUST select/trim the schema context to respect the model's measured token budget, including reducing lookup caps, using compact formatting, and falling back from FK depth 2 to FK depth 1 when needed.
- **FR-015**: The app MUST generate Intent JSON via the existing on-device local SLM service from feature 001 (active Qwen2.5 1.5B model), without switching models at the start.
- **FR-016**: The app MUST parse and validate the model output and, if invalid, perform exactly **one** bounded **repair** retry before finalizing.
- **FR-017**: The produced Intent JSON MUST conform to the **Intent JSON Contract** defined below (all listed fields present with valid value domains).
- **FR-018**: The validator MUST reject hallucinated schema references and MUST check: referenced table exists; every referenced column exists on its table; required FK/join paths exist; operator is compatible with the column type; referenced lookup/enum values exist where applicable; no raw SQL fragments anywhere; no unknown/invented schema references.
- **FR-019**: When hallucinated references are detected, the result MUST set `status: "invalid_schema_reference"` and populate `validation_errors`; validation failures MUST be surfaced (in the debug screen and metrics), never silently passed through.
- **FR-020**: The pipeline MUST support `needs_clarification` (with well-formed `clarification_options`) and `unsupported` (with `unsupported_reason`) outputs, generating and validating their structure only — **no** clickable clarification UI in this spec.
- **FR-021**: A **dev-only Intent Debug screen** (not shipped to end users) MUST display, for a typed question: the trimmed schema context sent to the model, the raw model output, the parsed Intent JSON, validation errors, the repair result, and the latency.
- **FR-022**: The feature MUST provide a project-focused **golden set of ≥ 50 questions** covering Arabic, English, mixed; high-risk; delayed/overdue; project status; owner/responsible person; department; due-soon; count/list/summarize intents; ambiguous (needs_clarification); and explicitly unsupported — each item recording its expected outcome.
- **FR-023**: Running the golden set MUST produce a **scorecard** summarizing intent accuracy, schema-reference validity, language handling, repair rate, and latency, supporting a Go/No-Go decision.
- **FR-024**: An **M0 measurement gate** MUST be completed before full implementation: empirically measure the context/token budget of the current model; test FK depth 2, reduced lookup caps, compact formatting, and FK depth 1 fallback; trial strict-JSON prompting versus function-calling/structured-output/constrained decoding if available and choose the more reliable; and decide whether the current model suffices (larger-context build recorded only as a fallback).
- **FR-025**: The feature MUST NOT regress feature 001: the existing offline **free-text local chat MUST keep working unchanged**.

### Hard Boundaries (Non-Goals enforced as requirements)

- **FR-026**: The Flutter app MUST NOT connect to SQL Server or any database, MUST NOT execute or generate SQL, MUST NOT retrieve real data, and MUST NOT display real database answers in chat in this spec.
- **FR-027**: This spec MUST NOT include Python CLI automation, backend APIs, a schema-metadata API, a chat-history API, MCP execution, a clickable clarification UI, multi-domain/multi-root extraction, model switching at the start, or a server-side baseline (all deferred to future specs).

### Intent JSON Contract *(authoritative — define exactly)*

The on-device pipeline MUST produce objects of this shape:

```json
{
  "schema_version": "0.1.0",
  "status": "ok | needs_clarification | unsupported | invalid_schema_reference",
  "language": "ar | en | mixed",
  "intent": "list_records | count_records | summarize_records | get_record_detail | compare_records | unknown",
  "root_table": null,
  "target_tables": [],
  "selected_fields": [],
  "filters": [],
  "relationships": [],
  "aggregations": [],
  "date_range": null,
  "sort": [],
  "limit": null,
  "confidence": 0.0,
  "needs_clarification": false,
  "clarification_question": null,
  "clarification_options": [],
  "unsupported_reason": null,
  "validation_errors": []
}
```

Each `clarification_options` entry MUST have this shape (generated and validated only in this spec — no clickable UI):

```json
{
  "id": "projects",
  "type": "root_table",
  "table": "Projects",
  "display_label": { "ar": "المشاريع", "en": "Projects" },
  "reason": "The question may refer to project records.",
  "confidence": 0.72
}
```

Contract rules:
- `status`, `language`, and `intent` MUST use only the enumerated values shown.
- `root_table`, `target_tables`, `selected_fields`, `filters` (column / operator / value), `relationships`, and any lookup values referenced anywhere MUST exist in the SchemaGraph, or the result is `invalid_schema_reference`.
- `confidence` is a 0.0–1.0 score.
- `validation_errors` MUST list each detected problem with enough detail to identify the offending reference.
- `needs_clarification` / `clarification_options` and `unsupported` / `unsupported_reason` are part of the contract now; their interactive handling is deferred to `003-ai-clarification-loop`.

### Key Entities *(include if feature involves data)*

- **Schema Metadata File**: The reviewed, committed JSON asset describing the projects schema slice — versioned, with three sections (schema metadata, lookup/reference values, optional samples) plus provenance (root table, depth, caps, denylist applied, generated_at).
- **SchemaGraph**: The in-memory representation parsed from the asset — tables, columns (name, type, nullability), primary keys, foreign-key edges / relationship paths, and lookup/reference values; used for prompt trimming and validation.
- **Intent JSON**: The structured, schema-grounded representation of the user's question, per the contract above.
- **Clarification Option**: A candidate interpretation surfaced when a question is ambiguous — friendly bilingual label plus internal schema reference and confidence.
- **Golden Set Item**: A test question plus its expected outcome (expected intent fields, or `needs_clarification` / `unsupported`) and category tags.
- **Scorecard**: The aggregated measurement output across the golden set, including validity, accuracy, language handling, repair rate, and latency.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: The manual SQL Server script produces a reviewed schema JSON that conforms to the stable contract (three separated sections + provenance) and contains zero denylisted/sensitive fields, verified on manual review.
- **SC-002**: The app loads and parses the schema asset into a SchemaGraph successfully for a valid file, and reports a clear error (without crashing or affecting free-text chat) for an invalid one.
- **SC-003**: The schema context is trimmed to fit the empirically measured model budget, demonstrably falling back from FK depth 2 to FK depth 1 when the depth-2 slice is too large.
- **SC-004**: For the golden set, at least **80%** of model outputs are parseable Intent JSON conforming to the contract (after at most one repair retry).
- **SC-005**: The validator catches **100%** of injected hallucinated references and SQL fragments in the validation test set (no false negatives on the crafted cases).
- **SC-006**: Ambiguous golden questions yield `needs_clarification: true` with well-formed `clarification_options`, and unsupported questions yield `status: "unsupported"` with a reason, in line with their expected outcomes.
- **SC-007**: A scorecard is produced for **≥ 50** golden questions covering all listed categories, with per-category results and latency distribution, on a Samsung Galaxy S22 Ultra.
- **SC-008**: Across the run, **no SQL is generated and no database connection is made from the app**, confirmed by inspection.
- **SC-009**: The existing 001 offline free-text chat continues to work unchanged (regression check passes).
- **SC-010**: The M0 measurement gate is completed and documented, yielding a clear keep-current-model vs. consider-larger-context decision before full implementation proceeds.

## Assumptions

- Feature 001's on-device runtime and local SLM service are present and provide an active Qwen2.5 1.5B model; this feature reuses them rather than introducing a new runtime.
- A developer has read-only SQL Server access in a controlled environment for the manual export; that access and its credentials live entirely outside the repository.
- The projects domain has a discoverable root table and meaningful FK relationships within depth 2 covering risk/status/priority/owner/department/progress/due-date concepts.
- The Samsung Galaxy S22 Ultra is the reference evaluation device for the POC.
- Arabic/English/mixed language handling reuses the language-detection approach established in 001 where applicable.
- "Validated Intent JSON" is the deliverable; acting on it (clarification UI, DB retrieval, real answers) is explicitly later work.

## Dependencies

- **Feature 001 (`001-local-slm-ai-assistant`)**: provides the on-device model runtime, local SLM service abstraction, model selection / active-model state, and the free-text chat that must remain unaffected.
- **Next feature (`003-ai-clarification-loop`)**: consumes the `needs_clarification` / `clarification_options` contract defined here; not implemented in this spec.
- A reachable SQL Server instance (read-only) for the one-time / manual schema export.
