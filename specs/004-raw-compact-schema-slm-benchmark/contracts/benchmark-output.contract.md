# Contract: Benchmark Output (raw, plain text)

This is the **expected shape** the model is asked to produce. It is a *human-judged reference*, not a
machine-validated schema. The harness shows the raw response verbatim and never enforces or repairs
this shape (per FR-005, FR-010).

## Required sections (exact labels, exact order)

```
Table(s):
- ...

Column(s):
- ...

Relationship(s):
- ...

Filter(s):
- ...

Sort(s):
- ...

Entity(s):
- ...
```

## Rules (as instructed to the model, judged by humans)

- Plain text only. **No JSON, no SQL, no code fences required.**
- Each section lists plain bullet lines; a section may be empty (recorded as empty).
- Relationship items use inline foreign-key form: `Parent.Column -> Referenced.Column`.
- Filter items reference the **raw phrase** from the question (e.g. exact project name / lookup
  phrase), never a normalized code, synonym, or invented value.
- Only schema references present in the compact schema file may be used; hallucinated tables/columns
  are recorded as failures, not corrected.

## Example reference (question 1: `مشاريع عالية الخطورة`)

*Illustrative human reference for judging "reasonable" — NOT an answer key, NOT injected into the prompt.*

```
Table(s):
- Projects
- RiskLevels

Column(s):
- Projects.Id
- Projects.Name
- Projects.RiskLevelId
- RiskLevels.Id
- RiskLevels.Name

Relationship(s):
- Projects.RiskLevelId -> RiskLevels.Id

Filter(s):
- RiskLevels.Name = "عالية الخطورة"

Sort(s):
- None

Entity(s):
- None
```

## Non-contract

The harness makes **no guarantee** the model conforms. Deviations (missing sections, extra prose,
wrong references) are captured as-is and scored by a human reviewer.
