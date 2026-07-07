# Feature Specification: Raw No-Terms Compact Schema SLM Benchmark

**Feature Branch**: `004-raw-compact-schema-slm-benchmark`

**Created**: 2026-07-04

**Status**: Draft

**Input**: User description: "Raw No-Terms Compact Schema SLM Benchmark — Benchmark the local SLM's raw ability to take a single compact DB schema file plus a natural-language user question and return plain-text schema references: Table(s), Column(s), Relationship(s), Filter(s), Sort(s), Entity(s). Experiment/benchmark only, not production. No Flutter, no SLM wiring yet, no validation, no SQL, no DB, no MCP, no system routing, no lookup values, no business terms, no QuerySpec, no JSON intent."

## Overview

This feature is a **measurement experiment**, not a product capability. Its only purpose is to
measure how well a local Small Language Model (SLM) can read **one** compact database schema and a
natural-language question, and then name the relevant schema references and simple conditions in
plain text.

The benchmark deliberately isolates the SLM's raw comprehension. It removes every surrounding aid
that a production pipeline would normally provide — no schema routing, no candidate retrieval, no
lookup-value normalization, no business-term dictionary, no validation, no repair, no SQL, no
database, no backend. The compact schema file and the question go in; the raw model text comes out;
a human records whether it was right.

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Run a question through the raw benchmark (Priority: P1)

As a member of the product/AI team, I want to give the SLM a single compact schema file plus one
natural-language question and receive a plain-text answer that names the relevant tables, columns,
relationships, filters, sorts, and entities — so I can judge the model's raw schema-understanding
ability without any production scaffolding.

**Why this priority**: This is the entire experiment. Without the ability to feed one schema + one
question and capture the raw output, there is nothing to benchmark.

**Independent Test**: Provide the compact schema file and one of the six benchmark questions, capture
the model's raw text response, and confirm the response contains the six required sections. Delivers
value on its own because a single run already produces a recordable data point.

**Acceptance Scenarios**:

1. **Given** the compact schema file and a natural-language question, **When** the benchmark is run,
   **Then** the output is plain text containing exactly the sections `Table(s):`, `Column(s):`,
   `Relationship(s):`, `Filter(s):`, `Sort(s):`, and `Entity(s):`.
2. **Given** a question that maps to a lookup relationship (e.g. risk or priority), **When** the
   benchmark is run, **Then** the output names the relevant relationship in
   `Parent.Column -> Referenced.Column` form and a filter on the referenced lookup's `Name` column
   using the raw phrase from the question.
3. **Given** a question that names a specific project or meeting, **When** the benchmark is run,
   **Then** the output includes a filter on the appropriate `Name`/`Title` column using the exact
   phrase from the question, with no invented lookup value or business term.

---

### User Story 2 - Record and compare results across the six benchmark questions (Priority: P2)

As a member of the product/AI team, I want to record the raw output and a simple correctness
judgement for each of the six benchmark questions, so I can summarize the model's strengths and
failure patterns.

**Why this priority**: Individual runs are only useful if their outcomes can be captured and compared.
This turns single runs into a benchmark result set, but depends on User Story 1 existing first.

**Independent Test**: For each of the six questions, capture the raw output and fill in a manual
scorecard (tables correct? columns correct? relationships correct? filters/entities/sort reasonable?
failure notes). Delivers value by producing a comparable result table.

**Acceptance Scenarios**:

1. **Given** a completed run for a question, **When** a reviewer records the result, **Then** they can
   note raw output, table correctness, column correctness, relationship correctness,
   filter/entity/sort reasonableness, and free-text failure notes.
2. **Given** all six questions have been run, **When** results are collected, **Then** a single
   summary shows per-question pass/fail-style judgements without requiring any automated validation.

---

### Edge Cases

- **Missing/empty answer section**: The model omits one of the six required sections or leaves it
  blank. Recorded as a failure note; no automatic repair is attempted.
- **Hallucinated schema reference**: The model names a table or column not present in the compact
  schema file. Recorded as an incorrect-tables/columns failure; not corrected.
- **Invented lookup value or business term**: The model substitutes a normalized code or synonym for
  the user's raw phrase. Recorded as a failure note (out of scope to normalize).
- **Ambiguous question mapping** (e.g. "most advanced by outputs" could use `Projects.OutputCount` or
  `ProjectOutPutModels`): Either interpretation is recorded and judged "reasonable"; the benchmark
  does not enforce a single correct answer for optional cases.
- **Mixed-language question** (Arabic question, English schema identifiers): The raw phrase is expected
  to be preserved verbatim in the filter; translation is not required.
- **Extra prose around the sections**: The model wraps the six sections in additional commentary. The
  raw response is shown as-is; reviewers judge only the six sections.

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: The benchmark MUST accept exactly two inputs — one single compact schema file and one
  natural-language user question.
- **FR-002**: The benchmark MUST use the single compact schema file located at
  `systems/project_management/assets/ai/schema/nawah_compact_schema_no_terms.slim.v1.txt` as the only
  schema source.
- **FR-003**: The benchmark output MUST be plain text containing exactly these six sections, in this
  order: `Table(s):`, `Column(s):`, `Relationship(s):`, `Filter(s):`, `Sort(s):`, `Entity(s):`.
- **FR-004**: Each section MUST list its items as plain bullet lines; empty sections are permitted and
  recorded as such.
- **FR-005**: The raw SLM response MUST be shown and recorded as-is, without post-processing, parsing,
  or repair.
- **FR-006**: Relationship items MUST be expressed using the schema's inline foreign-key form
  `Parent.Column -> Referenced.Column`.
- **FR-007**: Filter items MUST reference the raw phrase from the user's question (e.g. the exact
  project name or lookup phrase) rather than a normalized code, synonym, or invented value.
- **FR-008**: The benchmark MUST be runnable manually against the six defined benchmark questions.
- **FR-009**: For each question, reviewers MUST be able to record: the raw output, whether tables are
  correct, whether columns are correct, whether relationships are correct, whether filters/entities/
  sort are reasonable, and free-text failure notes.
- **FR-010**: The benchmark MUST NOT perform any automatic validation, correctness enforcement, or
  SQL-readiness guarantee on the model's output.
- **FR-011**: The compact schema file MUST remain free of JSON, lookup values, business terms, sample
  data, audit columns, and security/authentication columns; it MUST use exact real table names, exact
  real column names, and inline foreign-key relationships.
- **FR-012**: The scope MUST be a single compact schema with no system routing and no per-system
  schema selection.

### Out of Scope / Non-Goals

The following are explicitly **not** part of this feature and MUST NOT be introduced by it:

- Production Flutter assistant behavior (any user-facing assistant feature in the app)
- Production natural-language-to-SQL pipeline
- Production SLM orchestration (any production wiring, chaining, or automated pipeline around the model)
- SQL generation or SQL execution
- Database access, database connection, backend integration, or backend calls
- MCP integration
- Answer generation from actual data rows
- Lookup-value normalization
- Business term / synonym dictionary
- Schema routing or per-system schema selection
- Candidate retrieval
- Deterministic validation, parsing, or repair
- QuerySpec pipeline
- JSON intent output schema (including the previous JSON intent pipeline from earlier specs)

### Allowed for This Experiment

A single **dev-only, manual benchmark harness** is permitted as the vehicle for running the
experiment. It is a developer tool, not a product feature, and its only responsibilities are to:

- load the single compact schema asset,
- build the benchmark prompt from that schema plus one question,
- send the prompt to the local SLM,
- show the raw SLM output as-is (no post-processing, parsing, validation, or repair),
- log prompt length, raw output, and latency.

This dev-only harness does **not** relax any of the Out of Scope / Non-Goals above — it invokes the
local SLM solely to display and log its raw response for benchmarking, and introduces none of the
production behaviors listed as non-goals.

### Key Entities *(include if feature involves data)*

- **Compact Schema File**: The single plain-text pseudo-object schema
  (`nawah_compact_schema_no_terms.slim.v1.txt`) that is the sole schema input. Contains exact real
  table and column names with inline foreign-key relationships and no terms, lookup values, audit, or
  security columns.
- **Benchmark Question**: One natural-language question (Arabic or English) submitted alongside the
  compact schema. Six predefined questions form the benchmark set.
- **Raw SLM Output**: The plain-text response returned by the model, containing the six required
  sections, recorded verbatim.
- **Result Record**: A manual scorecard per question capturing raw output plus human judgements
  (tables/columns/relationships correct; filters/entities/sort reasonable; failure notes).

### Benchmark Question Set

Each question below lists the expected intent shape used only as a **human reference** for judging
"reasonable" — it is not an automated answer key.

1. **Question**: `مشاريع عالية الخطورة`
   - Projects
   - RiskLevels
   - `Projects.RiskLevelId -> RiskLevels.Id`
   - Filter on `RiskLevels.Name` using the raw phrase from the question.

2. **Question**: `give me low priorities projects`
   - Projects
   - PeriortyLevels
   - `Projects.PeriortyLevelId -> PeriortyLevels.Id`
   - Filter on `PeriortyLevels.Name` using the raw phrase from the question.

3. **Question**: `what is the budget of أتمتة العقود والقوانين`
   - Projects
   - `Projects.Budget`
   - Filter `Projects.Name` = exact Arabic project name.

4. **Question**: `من المسؤول عن مشروع مختبر التميز المؤسسي`
   - Projects
   - AspNetUsers
   - `Projects.ManagerId -> AspNetUsers.Id`
   - `AspNetUsers.FullName`
   - Filter `Projects.Name` = exact Arabic project name.

5. **Question**: `اكثر المشاريع تقدما من حيث المخرجات`
   - Projects
   - `Projects.OutputCount`
   - Sort `Projects.OutputCount` desc
   - Optionally `ProjectOutPutModels` if the model chooses output records instead.

6. **Question**: `ما وصف اجتماع لجنة المتابعة`
   - Meetings
   - `Meetings.Description`
   - Filter `Meetings.Title` using the raw meeting title phrase from the question.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: All six benchmark questions can be run manually against the single compact schema, each
  producing a recorded raw output.
- **SC-002**: For 100% of the six questions, a reviewer can record the four correctness judgements
  (tables, columns, relationships, filters/entities/sort) plus failure notes without needing any
  automated validation tool.
- **SC-003**: Each recorded output is judged on whether it contains all six required sections in the
  specified order; the proportion that do is reported as a benchmark metric.
- **SC-004**: The experiment produces a single comparison summary across all six questions that lets
  the team state, in plain language, where the SLM succeeds and where it fails at raw schema
  understanding.
- **SC-005**: No output is altered, validated, or "made SQL-ready" during the benchmark; raw
  responses are preserved verbatim for every question.

## Assumptions

- The compact schema file at
  `systems/project_management/assets/ai/schema/nawah_compact_schema_no_terms.slim.v1.txt` already
  exists (created in prior work) and is the only schema used; if absent it will be provided before a
  run, but this spec does not regenerate it.
- The benchmark is executed and scored by a human reviewer; no automated harness is required by this
  spec.
- Questions may be in Arabic or English; the raw phrase from the question is preserved verbatim in
  filters, and translation/normalization is not expected.
- "Correct" and "reasonable" are human judgements for this experiment; there is no machine-checkable
  answer key, and optional interpretations (e.g. question 5) are both acceptable.
- This feature is fully independent of Spec 001 / 002 / 003; it does not modify, reuse, or depend on
  their JSON intent pipeline, QuerySpec, research, or milestones.
- The purpose is strictly to measure SLM ability; no production readiness is claimed or required.
