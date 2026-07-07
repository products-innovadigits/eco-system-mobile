# Contract: Benchmark Prompt Structure

Defines the deterministic structure produced by `buildBenchmarkPrompt(schema, question)`. This is what
the unit tests assert. It is internal to the dev harness.

> **Revision note (device-tuning phase):** the prompt is now **schema-first** and includes **one worked
> example**, and its six sections are framed as the parts of a SQL query (the output is intended to be
> consumed by a downstream SQL generator). This intentionally overrides the original spec non-goals
> "no few-shot examples" and "no SQL orientation" — a deliberate, user-approved change to improve
> small-model format adherence and downstream usability.

## Structure (fixed order)

```
SCHEMA:
<compact schema text, verbatim>

<instruction block: six SQL-oriented sections + rules>

Example
QUESTION: <illustrative question>
Table(s): ...
Column(s): ...
Relationship(s): ...
Filter(s): ...
Sort(s): ...
Entity(s): ...

QUESTION:
<question text, verbatim>

ANSWER:
```

Rationale for the order: the schema comes first, and the format instruction + example sit **immediately
before** the real `QUESTION:`/`ANSWER:` cue. Instructions closest to the generation point are the ones
small models follow best.

## Instruction block requirements

The instruction block MUST direct the model to:

1. Use **only** the provided schema.
2. Output **exactly** these six sections, in order, framed as SQL-query parts:
   - `Table(s):` — tables for `FROM`
   - `Column(s):` — columns to `SELECT`, as `Table.Column`
   - `Relationship(s):` — joins as inline FK `Parent.Column -> Referenced.Column`
   - `Filter(s):` — `WHERE` conditions as `Table.Column = <raw phrase from the question>`
   - `Sort(s):` — `ORDER BY` as `Table.Column asc|desc`
   - `Entity(s):` — the main entity
3. Keep the **raw phrase** from the question verbatim in `Filter(s)`.
4. Never normalize or invent values; leave a section empty when it does not apply.
5. Produce plain text only — **no SQL, no JSON** (the SLM emits the parts; a separate downstream
   generator builds the actual SQL).

## Example block requirements

Exactly **one** worked example is included, using only schema-style identifiers (no lookup values, no
business synonyms). It demonstrates every section, including a join (`Parent.Column -> Referenced.Column`),
a filter that preserves a raw phrase, and a sort. The example question is **not** one of the six
benchmark questions (to avoid leaking their answers).

## Determinism rules (test-asserted)

- Same `(schema, question)` inputs → byte-identical prompt output.
- Schema text embedded **verbatim**, and it appears **before** the real question.
- Question text embedded **verbatim** (Arabic/English preserved); the prompt ends with the `ANSWER:` cue.
- Section labels appear in the required order.
- The prompt includes the **prohibition** `no SQL, no JSON` and includes no directive to *generate* SQL
  or JSON.
- The prompt includes the worked example (the `Projects.ManagerId -> AspNetUsers.Id` join line).

## Out of contract

Generation parameters (temperature, topK, topP, `maxTokens`, timeout) are applied by the runner/engine,
not encoded in the prompt string, and are therefore not part of this contract.
