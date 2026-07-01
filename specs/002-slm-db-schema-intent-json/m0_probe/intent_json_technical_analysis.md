# On-Device Intent JSON — Technical Analysis (M0, consultant-ready)

**Feature:** `002-slm-db-schema-intent-json` · **Phase:** M0 measurement (not the final Intent pipeline)
**Runtime:** Flutter + `flutter_gemma` 0.12.6 · **Model:** Qwen2.5 1.5B `.task` (ekv1280, run at 1024 ctx) · **Device:** Samsung Galaxy S22 Ultra
**Status:** G-M0 **pending** — no production pipeline, no DB, no SQL, no data retrieval.

---

## 1. Executive summary
We can already run a small language model fully on the phone, offline, and get **well-formed Intent JSON** back from an Arabic question — the crash and format problems are solved. The remaining problem is **accuracy of meaning**: for "high-risk projects" the model chose the *priority* field instead of the *risk* field and **invented a value** ("الهامة") that was not in the data we gave it. In business terms: the plumbing works, but the model's *understanding* is not yet trustworthy enough to drive real data queries. This is expected for a 1.5B model and is **not** something we should paper over with per-question rules in the prompt. The durable fix is to move the "which table / which value" decisions **out of the model** into deterministic, data-driven components (a business vocabulary, a lookup-value matcher, a schema graph, and a validator), and let the model do only what small models are actually good at.

## 2. Problem categories

**a) SLM capability / model quality.** A 1.5B instruction model has limited semantic precision and weak "copy-exactly-from-the-list" discipline. It paraphrases and free-associates. This is the single biggest contributor to the wrong output.

**b) Context window / maxTokens.** The model runs at 1024 tokens (file supports 1280). Only the *minimal* schema (depth-0) fits with output headroom. depth-1/2 are blocked by our guard. So we can only ever show the model a **tiny slice** of the schema — which forces us to pre-select the right slice deterministically.

**c) Schema size and slicing.** Even the projects domain alone is 61 tables / 104 relationships. That will never fit a small on-device context. Slicing is mandatory, and *what* we slice determines whether the model can succeed.

**d) Arabic/English semantic ambiguity.** "عالية الخطورة" (high risk) vs "الأولوية العالية / الهامة" (high priority / important) are close in everyday Arabic. Risk and priority are conceptually adjacent ("important" ≈ "high priority" ≈, loosely, "serious/risky"). A small model conflates them.

**e) Lookup-value grounding.** We provided the exact allowed values (`RiskLevels.Name=[…]`, `PeriortyLevels.Name=[…]`). The model did not copy an allowed value; it produced "الهامة", which is in *neither* list. Nothing in the current setup **forces** the value to be one of the enumerated options.

**f) Hallucinated schema/value risk.** The model can emit table/column/value names that don't exist. This is the core safety risk: acting on a hallucinated field/value later (when we do retrieval) would produce wrong answers with false confidence.

**g) JSON format reliability.** Good news: JSON structure is reliable, but the model wraps it in ```json fences. That is easily handled by a tolerant parser (strip fences, extract first balanced object). Format is a *solved* concern.

**h) Latency & mobile performance.** CPU/XNNPack inference of a 1.5B model is slow. The first run measured ~17 s, inflated by a double model-load; after the fresh-session fix the model loads once and subsequent one-shots are inference-only — but decode of a few hundred JSON tokens on CPU is still several seconds. Latency is a UX risk for an "executive" feature.

**i) Offline constraints.** Everything must run on-device with no network. That rules out large models and server tokenizers for phase 1 and caps model size/context.

**j) Future chat-history / context management.** Today the probe is deliberately history-free. When conversational context returns (follow-ups, "and by department?"), naive history reuse re-creates the exact overflow that caused the original crash. Context must be **budgeted and summarized**, never appended raw.

**k) Backend/data-retrieval integration (later).** Once Intent JSON drives real queries, an unvalidated hallucinated field/value becomes a data-integrity and security problem. A validation + authorization gate is mandatory before any retrieval.

## 3. Root cause of the latest wrong output
Question: "مشاريع عالية الخطورة" (high-risk projects). Output: `column: PeriortyLevelId`, `value: "الهامة"`, `relationships: []`.

Most likely a **combination**, in order of impact:
1. **Small-model semantic drift.** "high risk" → the model's nearest concept was importance/priority ("الهامة" = *important*), so it selected `PeriortyLevelId` (priority) instead of `RiskLevelId` (risk). Risk and priority are adjacent concepts; a 1.5B model does not reliably separate them.
2. **Parallel, near-duplicate lookups in the prompt.** `RiskLevels.Name` and `PeriortyLevels.Name` share the identical shape (عالية/متوسطة/منخفضة). Two look-alike option sets are a classic small-model confusion trap.
3. **No forced copy / no constrained decoding.** The model was *asked* to use a listed value but nothing *enforced* it, so it generated a plausible new word ("الهامة") instead of copying "مخاطر عالية". Free-form decoding permits value invention.
4. **No deterministic pre-selection.** The model had to do keyword→table→value mapping itself. That mapping is exactly what small models are worst at and what deterministic matching is best at.
5. **Missing relationship** is a secondary symptom of the same weak instruction-following.

Note: this is *not* a context-overflow problem (depth-0 fit fine, ~461 tokens). It is a **reasoning/grounding** problem.

## 4. Would a stronger model solve it?
**What a stronger model (7B–14B, or a server model) improves:** it would very likely map "high risk" → `RiskLevels`, copy the exact value "مخاطر عالية", follow the "copy from the list" instruction, and populate the relationship. Semantic precision and instruction-following jump substantially above ~7B.

**What it does *not* solve:**
- **Schema still won't fit** as coverage grows (many modules × many tables × many lookups) → slicing/retrieval still required.
- **Hallucination is reduced, not eliminated** → validation still required before any data retrieval.
- **On-device limits** (RAM/latency/heat) make 7B+ impractical offline on a phone → either a bigger model is server-side (breaks the offline goal) or you accept a smaller on-device model with deterministic scaffolding.
- **Auditability/security**: an LLM answer is never a substitute for a deterministic check that the referenced table/column/value exists and the user is allowed to see it.

**Conclusion:** a stronger model raises the floor and would make demos look good, but the **router + schema slicer + lookup matcher + validator are required regardless of model strength**. Model choice changes *how often* we hit the validator, not *whether* we need it.

## 5. Is this hardcoding?
There is a spectrum from brittle to scalable. The trap is fixing this by writing risk/priority rules into the prompt or into `if` statements — that is bad hardcoding. The scalable equivalents are **data-driven** and **general**:

| Approach | What it is | Verdict |
|---|---|---|
| **Bad hardcoding** | `if question contains "خطورة" → RiskLevels` in code, or per-question prompt rules | ❌ Brittle, per-question, doesn't scale across modules/languages |
| **Business vocabulary / synonym lexicon** | A maintained map: concept "risk" ↔ {خطورة, مخاطر, risk, severity}; "priority" ↔ {أولوية, الهامة, priority} — as **data** | ✅ Acceptable and necessary; scales; edited by domain experts, not devs |
| **Schema ontology / semantic tags** | Tag each table/column with a role (`RiskLevels` = risk dimension, `PeriortyLevels` = priority dimension) — **data** | ✅ Scales; generated once per schema export |
| **Deterministic router** | Algorithm that matches the question (via lexicon + embeddings) to candidate tables/lookups | ✅ General; no per-question code |
| **Lookup-value index/matcher** | Exact + fuzzy/embedding match of question phrases against enumerated lookup values | ✅ Deterministic value grounding; kills invented values like "الهامة" |
| **Validation layer** | Reject/repair any table/column/value not in the schema/lookups | ✅ Mandatory safety net |

So: **prompt rules for risk vs priority = bad hardcoding**; a **synonym lexicon + ontology + lookup matcher + validator = scalable engineering**, not hardcoding.

## 6. Scalable architecture recommendation
```
User question
  → Normalizer            (trim, unify Arabic forms/diacritics, detect language)
  → Business-vocabulary matcher   (synonym lexicon: خطورة→risk, أولوية→priority)  [deterministic]
  → Schema graph / FK graph       (which tables/columns exist, how they join)      [deterministic]
  → Lookup-value matcher          (snap "high risk" → RiskLevels.Name="مخاطر عالية") [deterministic]
  → Schema slicer                 (build the smallest relevant slice)             [deterministic]
  → Token-budget manager          (fit slice + question + output in ctx)          [deterministic, exact sizeInTokens]
  → SLM Intent JSON generation    (intent type, which dimension, structure)       [model]
  → JSON parser / strip fences    (tolerant extraction)                           [deterministic]
  → Schema validator              (table/column/FK/operator/value all exist)      [deterministic]
  → Repair or clarification       (one bounded retry, else ask user)              [model + deterministic]
  → Backend query gateway (LATER) (validated Intent → server executes; not Flutter)
```
The model sits in the **middle**, surrounded by deterministic pre-selection (so it sees only the right slice) and deterministic post-validation (so nothing hallucinated escapes). This is what makes a *small* model usable and keeps a *large* model safe.

## 7. Deterministic vs model-based split
**Deterministic (never trust the model for these):**
- Does this table/column exist? Is there an FK path? → schema graph.
- Is this value a real lookup value? → lookup index (exact + fuzzy).
- Which tables/lookups are relevant to the words used? → vocabulary matcher + router.
- Does the prompt fit the context? → token-budget manager (exact `sizeInTokens`).
- Is the final Intent JSON internally valid and non-hallucinated? → validator.

**Model-based (play to its strengths):**
- Intent classification (list vs count vs summarize vs compare).
- Interpreting ambiguous/natural language and which *dimension* the user means (given a shortlist).
- Summarization and final answer phrasing (later, after retrieval).
- Deciding when to ask a clarifying question.

Rule of thumb: **the model proposes, deterministic layers dispose.** Values and references are *snapped to* and *validated against* real schema/lookups, never taken on the model's word.

## 8. M0 findings so far
- ✅ Crash fixed (fresh one-shot / session reset + preflight guard + depth-0).
- ✅ One-shot works; history is empty; no context carryover.
- ✅ Valid, parseable Intent JSON is achievable on-device offline.
- ⚠️ **Grounding is unreliable** (risk↔priority confusion; invented lookup value).
- ⚠️ Context is limited (1024 now, 1280 max on this file); only minimal schema fits.
- ⚠️ Latency is still a UX concern on CPU inference.
- ⏳ **G-M0 not passed** — accuracy bar not yet met; needs the full golden-set run + deterministic grounding experiments.

## 9. Risks for consultant discussion
- **Mobile context limit** — small on-device window caps how much schema the model can see; slicing is unavoidable.
- **Model quality** — 1.5B conflates adjacent concepts (risk/priority) and invents values.
- **Schema complexity** — 61 tables/104 FKs in projects alone; grows per module; cannot be shown wholesale to a small model.
- **Hallucinated fields/values** — the core correctness/safety risk; must be validated out.
- **Arabic semantic ambiguity** — near-synonyms and dialect increase confusion; needs a normalizer + lexicon.
- **Latency** — several seconds/query on-device; executive UX expectations.
- **Offline limitation** — rules out large models/server tokenizers for phase 1.
- **Backend retrieval later** — Intent JSON must be validated *and* authorized before any query runs (server-side, never from Flutter).
- **Validation/security before SQL/data** — no data retrieval on an unvalidated or unauthorized intent; injection/permission concerns move to the server gateway.

## 10. Recommended next steps
**Immediate M0 actions (cheap, measure):**
- Run the full ≥50 golden set at depth-0 / 1024 and record grounding accuracy per category (record, do not yet flip G-M0).
- Try two prompt *shaping* changes (not per-question rules): (i) present **only one dimension's** lookups at a time when the router is confident, and (ii) an explicit "copy the value **verbatim** from the list; if none matches, set needs_clarification" instruction — to measure how far prompt shaping alone gets us.
- Test context **1280** + depth-1 for a grounding-vs-latency comparison.
- Wire **exact token counting** (`sizeInTokens`) into the guard to replace the char estimate.

**Next technical spike (the real fix):**
- Build a small **deterministic grounding prototype** off-device/dev-only: business vocabulary lexicon (risk/priority/status/owner/department…), a lookup-value matcher (exact + fuzzy), and a validator that rejects non-enumerated values. Measure how much this alone fixes the risk/priority + invented-value failures **without** changing the model.
- Evaluate a **stronger model as a benchmark** (server-side or larger on-device) purely to quantify the model-quality ceiling — as a measurement, not a commitment.

**Future production architecture:**
- The section-6 pipeline: deterministic router + slicer + lookup matcher + token-budget manager around the model, then validator + repair, then a **server-side** query gateway that enforces validation + authorization before any data access.
- Treat chat history as **budgeted + summarized**, never raw-appended.

**What NOT to do:**
- ❌ Do not encode risk/priority (or any per-question) rules into the prompt or app code as the "solution."
- ❌ Do not generate SQL in Flutter or connect the app to the DB.
- ❌ Do not let the model's table/column/value choices reach data retrieval unvalidated.
- ❌ Do not re-enable raw chat-history reuse for intent extraction.
- ❌ Do not declare G-M0 passed on a single good demo; require the golden-set numbers.

---

## Final diagnosis
The pipeline (offline, one-shot, JSON, no-crash) is **working**; the failure is **semantic grounding** — a small model conflating risk with priority and inventing a lookup value. This is a predictable limitation of a 1.5B model combined with a schema that presents near-duplicate concepts and no deterministic value-grounding. It is a *grounding/architecture* problem, not a JSON or context-overflow problem.

**Is current Qwen 1.5B enough for phase 1?** Not on its own for reliable Intent JSON. It is enough to *prove feasibility* and to serve as the generation step **if** it is wrapped in deterministic grounding + validation. As a standalone "question → correct Intent JSON" engine, it is not reliable enough.

**Is a stronger model required?** Not strictly required to proceed, and it does not remove the need for the surrounding architecture. A stronger model (ideally server-side, given offline/mobile limits) would materially improve accuracy and is worth benchmarking — but it is an *accuracy lever*, not a substitute for the router/slicer/lookup-matcher/validator.

**What architecture is required regardless of model strength?** Deterministic **pre-selection** (normalizer → vocabulary matcher → schema graph → lookup matcher → slicer → token-budget manager) and deterministic **post-validation** (parser → schema validator → repair/clarify), with a **server-side** validated+authorized query gateway before any data retrieval. The model proposes; deterministic layers dispose.

**Key talking points for the consultant:**
1. Format and crash risks are solved; the open problem is *meaning*, and it is architectural, not cosmetic.
2. We will **not** hardcode risk/priority rules — we will move grounding into a data-driven lexicon + lookup matcher + validator that scale across modules and languages.
3. A small on-device model is viable **only** with deterministic scaffolding; a bigger model raises accuracy but still needs the same scaffolding and likely lives server-side (tension with the offline goal — a decision to make explicitly).
4. Schema will never fit a small context → retrieval/slicing is mandatory and is where most engineering value lies.
5. No data retrieval until a server-side validation + authorization gate is in place; this is a security/correctness boundary, not a nicety.
6. G-M0 stays open until the golden-set accuracy numbers (and a deterministic-grounding spike) tell us the realistic accuracy ceiling per approach.
