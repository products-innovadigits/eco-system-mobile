# Phase 0 Research — Schema-Aware Intent JSON (Projects POC)

**Feature**: `002-slm-db-schema-intent-json` | **Date**: 2026-06-30

This document records the M0 measurement design and the technical decisions that unblock implementation. Everything here precedes pipeline coding. The on-device numbers (context window, latency) are **to be filled by the M0 run on a Samsung Galaxy S22 Ultra** with the current Qwen2.5 1.5B model — placeholders below are marked `[M0]`.

---

## D1 — Generation path: strict-JSON prompting vs. structured output

- **Decision**: Default to **strict-JSON prompting** behind an `IntentGenerationStrategy` interface; trial structured-output/function-calling in M0 and switch only if it measurably wins.
- **Rationale**: `flutter_gemma`'s structured-output support for an arbitrary Qwen2.5 1.5B build is unconfirmed, and strict-JSON prompting (delimited output + stop sequence + tight `maxTokens`) works on any text-generation backend. Keeping it behind a strategy interface lets M0 pick the winner without reworking the pipeline.
- **Alternatives considered**: (a) Hard-commit to function-calling — rejected: availability unknown, would block the feature. (b) Grammar-constrained decoding (GBNF) — rejected for this POC: not exposed by the current runtime; recorded as a future option if strict-JSON parse rates are poor.
- **M0 measurement**: run the same probe set through both paths where available; compare parse-success and schema-validity. `[M0: strict-JSON parse rate = __ ; structured-output parse rate = __ ; chosen = __]`.

## D2 — Token-budget estimation on device

- **Decision**: Use a **heuristic char→token ratio** (start ~3.5 chars/token for mixed AR/EN, tunable) to size the trimmed slice against a configurable budget; calibrate the ratio against actual model behavior during M0.
- **Rationale**: An exact on-device tokenizer for the Qwen build may not be readily callable from Dart; a calibrated heuristic is sufficient to drive the depth-2→depth-1 fallback decision for a POC.
- **Alternatives considered**: Exact tokenizer count — preferred if cheaply available; M0 checks whether the runtime exposes a token count. Word-count heuristic — rejected: too coarse for Arabic.
- **M0 measurement**: `[M0: measured context window (ekv) = __ tokens ; depth-2 slice ≈ __ tokens ; fits? __ ]`.

## D3 — Schema slice trimming & fallback ladder

- **Decision**: Trimmer emits a **compact serialization** (table → `col:type[?]` lines, FK edges as `A.col→B.col`, lookups as `col:[v1,v2,…]` capped) and applies the fallback ladder **in order**: (1) compact formatting, (2) reduce `maxLookupRows`, (3) drop to FK **depth 1**. A larger-context model build is *out of scope* unless all three still fail.
- **Rationale**: Matches the spec's prescribed fallback order; each step sheds tokens with decreasing information loss before any model change is considered.
- **Alternatives considered**: Question-driven sub-graph selection (only tables relevant to detected keywords) — promising, recorded as an enhancement; v1 uses depth-based slicing for determinism and testability.
- **M0 measurement**: `[M0: first ladder step that fits = __ ]`.

## D4 — Tolerant JSON extraction before declaring parse failure

- **Decision**: `intent_parser` strips markdown fences, then extracts the **first balanced top-level `{…}`**, then `jsonDecode`. Only if that fails is the output a parse failure (→ repair retry).
- **Rationale**: Small models commonly wrap JSON in prose/fences; tolerant extraction materially raises usable-output rate without weakening validation (validation still runs on the parsed object).
- **Alternatives considered**: Strict `jsonDecode` of the whole output — rejected: needlessly fails recoverable outputs. Regex field scraping — rejected: brittle, bypasses the contract.

## D5 — Repair strategy (one bounded retry)

- **Decision**: On parse/validation failure, re-prompt **once** with a compact repair instruction that includes the original question, the trimmed schema, and the specific `validation_errors`; re-parse/re-validate; if still invalid, finalize as failed-with-errors (status reflects the failure, errors surfaced).
- **Rationale**: One retry captures most easily-correctable mistakes (wrong field name, stray SQL) without unbounded latency; aligns with FR-016/FR-019.
- **Alternatives considered**: N retries — rejected: latency/cost, diminishing returns. No retry — rejected: leaves easy wins on the table.

## D6 — Validation rule → status mapping

- **Decision**: Any unknown table/column/FK-path/lookup reference → `status = invalid_schema_reference`; any embedded SQL fragment → rejected (invalid_schema_reference). Type-incompatible operator → validation error (invalid_schema_reference). Well-formed but ambiguous → `needs_clarification`. Out-of-scope → `unsupported`. Clean & grounded → `ok`.
- **Rationale**: Makes "hallucinated reference" unambiguous and testable; matches the spec contract.
- **Alternatives considered**: Soft-warn on unknown refs — rejected: defeats the safety purpose of the validator.

## D7 — Schema sample sourcing when live DB access is delayed

- **Decision**: If read-only SQL Server access is not yet available, author a **representative** `projects_db_metadata_schema.json` that strictly matches the asset contract (realistic projects + risk/status/priority/owner/department/progress/due-date tables), clearly labeled as representative, and swap in the real export later without parser changes.
- **Rationale**: M0 and on-device pipeline work are blocked only on *a* contract-conformant schema, not specifically the production one; the stable contract guarantees a later real export drops in cleanly (FR-011).
- **Alternatives considered**: Block all work on DB access — rejected: unnecessarily serializes the project.

## D8 — Reuse of 001 runtime (no interface change)

- **Decision**: Intent generation calls the existing `LocalSlmService.generateText(prompt, maxTokens, timeout)`; **no** `generateIntent` is added to the 001 interface, and `AiInferenceController` is not modified. A new `IntentInferenceController` wraps the Intent flow.
- **Rationale**: Keeps 001 byte-for-byte unchanged (FR-025), avoids a second runtime, and isolates all new behavior behind the new `intent/` folder.
- **Alternatives considered**: Extend `LocalSlmService` with an intent method — rejected: touches 001 surface and risks regression for no benefit (the prompt already encodes the JSON instruction).

---

## M0 Plan of Record (the gate)

1. Prepare/commit the schema sample asset (D7).
2. On S22 Ultra with current Qwen2.5 1.5B, measure context window and depth-2 slice size (D2/D3).
3. Run the probe set (a ~10–15 question subset spanning AR/EN/mixed, list/count/summarize, ambiguous, unsupported) through strict-JSON and (if available) structured output (D1).
4. Record: context fit, first fitting ladder step, parse-success per path, sample latency.
5. **G-M0 exit**: a fitting slice exists + a generation path clears the recorded parse-success threshold → proceed; record keep-current-model decision (larger-context build flagged only if depth-1+compact+reduced-caps still fails).

**Open numeric placeholders to fill during M0**: context window `[M0]`, depth-2 token estimate `[M0]`, chosen ladder step `[M0]`, strict-JSON vs structured parse rates `[M0]`, median latency `[M0]`.

---

## M0 Execution Record - 2026-06-30

### T001 - Manual SQL Server export script scaffold

- **Status**: Complete for M0 scaffold.
- **File**: `tools/schema_export/export_projects_schema.sql`
- **Notes**: Added a read-only SQL Server catalog script scaffold with editable `@RootSchema`, `@RootTable`, `@FkDepth`, `@MaxLookupRows`, `@SamplesEnabled`, and denylist terms. The script uses `sys.tables`, `sys.schemas`, `sys.columns`, `sys.types`, `sys.foreign_keys`, `sys.foreign_key_columns`, primary-key catalog metadata, and `FOR JSON PATH` guidance. It contains no credentials and no DML/DDL.

### T002 - Export runbook

- **Status**: Complete for M0.
- **File**: `tools/schema_export/README.md`
- **Notes**: Added the manual SSMS/sqlcmd runbook, review checklist, denylist, replacement flow, and representative-sample fallback instructions. The runbook explicitly keeps DB credentials outside the repository and keeps Flutter disconnected from SQL Server.

### T003 - Initial schema sample

- **Status**: Complete for M0 with a representative sample.
- **File**: `systems/project_management/assets/ai/schema/projects_db_metadata_schema.json`
- **Source**: Representative manual sample because real SQL Server access and the final project root table are not available in this environment.
- **Root table**: `Projects`
- **FK depth represented**: 2
- **Lookup cap represented**: 50
- **Samples enabled**: `false`
- **Sample values**: empty array
- **Tables included**: `Projects`, `ProjectStatus`, `RiskLevels`, `ProjectPriorities`, `ProjectOwners`, `Departments`, `OrganizationUnits`, `ProjectMilestones`
- **Lookup/reference values included**: project status, risk level, priority, department, and organization unit labels. These are representative safe labels, not real DB rows.

### T004 - Sensitive-field review

- **Status**: Complete for the representative M0 sample.
- **Review result**: PASS for representative sample.
- **Reviewed denylist**: `password`, `pass`, `pwd`, `token`, `secret`, `api_key`, `access_key`, `refresh_token`, `connection`, `connection_string`, `credential`, `private`, `ssn`, `national_id`, `passport`, `phone`, `mobile`, `email`, `address`, `salary`, `payment`, `card`, `tenant_secret`, `auth`, `otp`, `session`, `cookie`.
- **Findings**: No table names, column names, lookup values, or provenance strings in the representative asset match the denylist. The asset contains no credentials, tokens, passwords, connection strings, private URLs, tenant secrets, salary/payment fields, or sensitive personal data. `sample_values` is empty.
- **Required before real export commit**: Repeat this review after running the SQL Server scaffold against the actual database.

### T005 - Flutter asset registration

- **Status**: Complete for M0.
- **File**: `systems/project_management/pubspec.yaml`
- **Registered asset**: `assets/ai/schema/projects_db_metadata_schema.json`

### T006 - Export provenance

- **Status**: Complete for M0 representative sample.
- **Provenance type**: Representative manual schema sample.
- **Reason**: Real SQL Server access and final project root confirmation are unavailable in this environment.
- **Chosen representative root**: `Projects`
- **Extraction shape represented**: root plus FK-depth-2 project-domain neighbors.
- **Lookup cap**: 50.
- **Denylist applied**: Yes, manually reviewed against the contract denylist.
- **Manual assembly**: The JSON was hand-authored to match `contracts/schema_metadata_contract.md`; it is intended to be replaced by a reviewed output from `tools/schema_export/export_projects_schema.sql`.

### T007 - Context/token-budget measurement on Samsung Galaxy S22 Ultra

- **Status**: Pending manual device run. Do not fake this result.
- **Required device**: Samsung Galaxy S22 Ultra.
- **Required model**: Current Qwen2.5 1.5B. Do not switch model at the start.
- **Required input**: `systems/project_management/assets/ai/schema/projects_db_metadata_schema.json` or the later reviewed real export.
- **Manual instructions**:
  1. Confirm the current Qwen2.5 1.5B model is active using the existing 001 model flow.
  2. Estimate or measure usable context window for the active build, including any `ekv`/context metadata exposed by the runtime.
  3. Prepare a depth-2 schema slice from the M0 asset using compact formatting.
  4. Estimate prompt size using the D2 heuristic starting point of about 3.5 chars/token for mixed Arabic/English, or replace with exact tokenizer counts if the runtime exposes them.
  5. Record system instruction size, schema slice size, question size, max output budget, and total prompt estimate.
  6. If depth 2 does not fit, apply the fallback ladder in order: compact formatting, reduced lookup caps, FK depth 1.
  7. Record the first fitting ladder step and sample latency.
- **Pending fields**:
  - measured context window: `[M0 pending]`
  - depth-2 token estimate: `[M0 pending]`
  - depth-2 fits: `[M0 pending]`
  - first fitting fallback step: `[M0 pending]`
  - median latency: `[M0 pending]`

### T008 - Strict JSON vs structured-output comparison

- **Status**: Pending manual device run. Do not fake this result.
- **Probe set**: Use 10-15 project-domain questions spanning Arabic, English, mixed language, list/count/summarize, ambiguous, and unsupported cases.
- **Strict JSON path**: Prompt the model to return only the Intent JSON contract object with no prose, no SQL, and no real data answer.
- **Structured-output path**: Run only if the current `flutter_gemma`/Qwen runtime exposes structured output or function-calling style constraints for this model. If unavailable, record `unavailable` rather than simulating it.
- **Metrics to record**:
  - parse-success count/rate
  - schema-validity count/rate against the reviewed schema
  - repair-needed count/rate
  - unsupported/clarification behavior
  - latency per probe and median latency
- **Pending fields**:
  - strict JSON parse rate: `[M0 pending]`
  - strict JSON schema-validity rate: `[M0 pending]`
  - structured-output availability: `[M0 pending]`
  - structured-output parse rate: `[M0 pending or unavailable]`
  - selected generation path: `[M0 pending]`

### T009 - G-M0 decision

- **Status**: Pending.
- **G-M0 result**: Not passed yet.
- **Reason**: The representative schema sample, sensitive-field review, asset registration, and provenance are complete, but the required Samsung Galaxy S22 Ultra context/token measurement and strict JSON vs structured-output comparison have not been run in this environment.
- **Gate rule**: No M2+ on-device pipeline implementation may start, land, or merge until this section is updated with real device measurements and a passed G-M0 decision.
- **Decision fields still required**:
  1. schema sample exists: yes, representative M0 sample
  2. context/token budget measured: pending
  3. current Qwen2.5 1.5B tested with trimmed projects schema: pending
  4. strict JSON vs structured output evaluated: pending
  5. generation path selected: pending
  6. keep-current-model or fallback-needed decision recorded: pending

### M0 manual probe questions

Use these questions for the pending T007/T008 device run:

1. `كم عدد المشاريع المتأخرة؟`
2. `اعرض المشاريع عالية المخاطر`
3. `show delayed high priority projects`
4. `which projects are due soon?`
5. `مين مسؤول عن المشاريع المتأخرة؟`
6. `summarize projects by department`
7. `list completed projects in Engineering`
8. `قارن المشاريع الحرجة بالمشاريع منخفضة المخاطر`
9. `projects on hold`
10. `show project milestones due this month`
11. `tasks ولا projects؟`
12. `what is the weather today?`

## Real SQL Server export — 2026-06-30 (supersedes the representative M0 sample)

The schema asset `systems/project_management/assets/ai/schema/projects_db_metadata_schema.json`
is now a **real, reviewed SQL Server export** (no longer representative).

- **Provenance**: live SQL Server export via `tools/schema_export/export_projects_schema.sql`
  (temporary stored procedure, read-only). Connection used the existing local
  developer configuration in `rag_first/.env` (`SQL_CONNECTION_STRING`, pyodbc +
  ODBC Driver 18). **No credentials were printed, hardcoded, or committed.**
- **Extraction time (UTC)**: `generated_at = 2026-06-30T09:34:04`.
- **Root**: `dbo.Projects`. **FK depth**: 2. **Method**: `manual_sql_export`.
- **Lookup cap**: 50 values/column; lookup-table size cap 500 rows.
- **Counts**: 61 tables, 104 relationships, 15 lookup sets, 5 excluded tables.
- **Sanitized `AspNetUsers` intentionally included** for manager/responsible
  questions ("who is responsible?", "show projects by manager", "مين المسؤول؟").
  Only safe allowlisted columns are present: `Id, FullName, IsActive, UserName,
  NormalizedUserName` (other allowlist columns do not exist in this table). The
  `Projects.ManagerId -> AspNetUsers.Id` FK (`FK_Projects_AspNetUsers_ManagerId`)
  is preserved in `schema_metadata.relationships`.
- **Sensitive-field review (real export)**: PASS. No forbidden identity/security
  columns present (no `PasswordHash/SecurityStamp/ConcurrencyStamp/Email/Phone/
  TwoFactor/Lockout/AccessFailed/*` etc.). `AppTokens` was dropped by the denylist
  (`token`). Other identity tables excluded with reason `identity_security`:
  `AspNetUserClaims, AspNetUserLogins, AspNetUserRoles, AspNetUserTokens`.
  `sample_values.enabled = false`; manager lookup values OFF
  (`@IncludeManagerLookup = 0`). No raw transactional/user rows exported.
- **Validation**: `python3 -m json.tool` passed; all 8 acceptance checks
  (root, AspNetUsers allowlist, ManagerId FK, forbidden columns, other identity
  tables, sample_values, lookup caps, valid JSON) passed.

### G-M0 current state

**G-M0 is STILL pending, not passed.** The schema asset is now real, but the
gate also requires the on-device measurements that have **not** been performed:
- **T007** — context/token-budget measurement on a **Samsung Galaxy S22 Ultra**
  with the current **Qwen2.5 1.5B** model: pending.
- **T008** — strict-JSON vs structured-output comparison on the real model: pending.

Do not implement `SchemaGraph`, `IntentParser`, `IntentValidator`,
`IntentDebugView`, or any other M2+ pipeline code until T007/T008 are run on the
device and the gate is explicitly changed to passed.
