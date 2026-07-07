# Quickstart: Running the Raw Compact-Schema SLM Benchmark (dev-only)

> Manual, dev-only procedure for the `004-raw-compact-schema-slm-benchmark`
> experiment branch. Nothing here runs in production or CI. Raw model output is preserved verbatim;
> no validation, parsing, repair, or normalization is performed.

## Entry Point

The benchmark runs through the normal AI assistant chat screen.

There is no separate dev page, no debug route, and no debug button/card. The tester types a question
into the existing chat input and sends it like an ordinary AI assistant message.

When `kRawSchemaBenchmarkEnabled == true`, the chat send flow is overridden and routes the typed
message through `RawSchemaBenchmarkRunner`. The assistant reply is the raw SLM output exactly as
returned by the runner.

When `kRawSchemaBenchmarkEnabled == false`, the normal assistant behavior remains active and this
benchmark is inert.

## On-device prerequisites

- Be on the `004-raw-compact-schema-slm-benchmark` experiment branch in a debug build.
- Set `kRawSchemaBenchmarkEnabled = true`
  (`.../ai_assistant/benchmark/raw_schema_benchmark_flags.dart`; default is `false`).
- Set `kPocDemoRealChat = true`
  (`.../ai_assistant/local_slm/poc_demo_flags.dart`; default may differ by branch state).
- Download/load a local model through the existing local-SLM path.
- Confirm the compact schema asset is present and declared in the module `pubspec.yaml`:
  `assets/ai/schema/nawah_compact_schema_no_terms.slim.v1.txt`.

If `kPocDemoRealChat` is `false` or no local model is loaded, the chat may show the local AI
unavailable fallback instead of real inference. Do not treat that fallback as a benchmark result.

## Run one question

1. Launch the debug build and open the normal AI assistant chat screen.
2. Type one of the six benchmark questions into the existing chat input exactly as written below.
3. Send the message.
4. The benchmark path loads the compact schema, resets the local SLM session, builds the prompt, and
   runs the SLM single-shot through `RawSchemaBenchmarkRunner`.
5. Read the assistant reply. It must contain only `rawOutput`, exactly as returned.
6. Capture the console metrics logged with the `[RAW_SCHEMA_BENCHMARK]` prefix.
7. Record the raw output and metrics in a manual run report or external team note.

Do not run all six questions until T013/T018. This quickstart is the template/instructions only.

## Benchmark question set

| # | Question |
|---|----------|
| 1 | `مشاريع عالية الخطورة` |
| 2 | `give me low priorities projects` |
| 3 | `what is the budget of أتمتة العقود والقوانين` |
| 4 | `من المسؤول عن مشروع مختبر التميز المؤسسي` |
| 5 | `اكثر المشاريع تقدما من حيث المخرجات` |
| 6 | `ما وصف اجتماع لجنة المتابعة` |

## Metrics

Metrics are logged to the dev console with this prefix:

```text
[RAW_SCHEMA_BENCHMARK]
```

Each run logs:

- `questionText`
- `schemaCharCount`
- `promptCharCount`
- `estimatedTokens`
- `latencyMs`

The assistant message itself contains only `rawOutput`. It does not include metrics, explanations,
wrappers, validation results, or transformed output.

## Scorecard (fill manually — human judgement only)

| # | Question text | Schema chars | Prompt chars | Estimated tokens | Latency (ms) | Tables ✓ | Columns ✓ | Relationships ✓ | Filters/Entities/Sort reasonable | 6 sections present & ordered | Failure notes |
|---|---------------|--------------|--------------|------------------|--------------|----------|-----------|-----------------|----------------------------------|------------------------------|---------------|
| 1 |               |              |              |                  |              |          |           |                 |                                  |                              |               |
| 2 |               |              |              |                  |              |          |           |                 |                                  |                              |               |
| 3 |               |              |              |                  |              |          |           |                 |                                  |                              |               |
| 4 |               |              |              |                  |              |          |           |                 |                                  |                              |               |
| 5 |               |              |              |                  |              |          |           |                 |                                  |                              |               |
| 6 |               |              |              |                  |              |          |           |                 |                                  |                              |               |

Keep raw output for each question alongside this table in a manual run report, verbatim and unedited.
Do not paste raw benchmark outputs into this quickstart.

Manual run outputs should go into:

```text
specs/004-raw-compact-schema-slm-benchmark/manual-results/benchmark_run_<date>.md
```

An external team note is also acceptable. Do not commit raw run outputs unless explicitly requested.

## Summary (fill after all six)

- Sections-present rate: __ / 6
- Tables-correct rate: __ / 6
- Columns-correct rate: __ / 6
- Relationships-correct rate: __ / 6
- Plain-language findings (where the SLM succeeds / fails at raw schema understanding): ...

## Guardrails reminder

Do **not** add validation, parsing, repair, SQL, DB, backend, MCP, routing, lookup values, business
terms, QuerySpec, or JSON intent while running this. The experiment measures the SLM's raw ability
only. Do not use production telemetry for raw prompt/response content.
