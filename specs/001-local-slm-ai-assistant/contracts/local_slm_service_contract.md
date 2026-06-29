# Contract — LocalSlmService (Phase 1, Text-Only)

**Feature**: 001-local-slm-ai-assistant | **Date**: 2026-06-29

The phase-1 "contract" is the in-app interface boundary (not a network API). It defines what the UI/controller can rely on, and keeps the door open for future providers without committing to them now.

---

## Interface (Dart, illustrative — not implemented in this step)

```dart
abstract class LocalSlmService {
  Future<void> load();
  bool get isReady;

  /// Phase 1: streamed FREE-TEXT generation only.
  Stream<String> generate(
    String prompt, {
    int maxTokens = 256,
    Duration? timeout,
  });

  Future<String> generateText(
    String prompt, {
    int maxTokens = 256,
    Duration? timeout,
  });

  Future<void> cancel();
  Future<void> dispose();

  // ── Future Scope (NOT in phase 1) ──────────────────────────────
  // Future<IntentResult> generateIntent(String prompt, MetadataBundle meta);
  // Strict JSON / schema-validated output belongs to a later spec.
}
```

## Behavioral guarantees (phase 1)
- **Active-model precondition.** Chat/generation is only reachable after the user has explicitly selected an installed model via the Model Selection UI; the active model is read from `ActiveModelStore`. `LocalSlmService` **never triggers a download** — installs happen only through `ModelManager.downloadSelectedModel(id)` on user action.
- **Free-text only.** Output is natural language; no JSON contract, no schema validation.
- **Non-blocking.** `generate` runs off the UI thread (handled inside `flutter_gemma`); the UI must not freeze.
- **Single in-flight generation.** Caller (UI) gates concurrency via `_isSending`; `cancel()` stops the current stream.
- **Bounded.** `maxTokens` caps output; `timeout` aborts long generations with a fallback.
- **Language.** Replies in the dominant language of the prompt (Arabic / English / mixed); prompt assembly is `PromptBuilder`'s job.
- **No-hallucination posture.** System instruction directs the model to avoid inventing facts and to say it lacks information when unsure. Phase-1 answers are **model-generated, not live system data**.
- **No persistence.** Conversation context is in-memory for the session only.

## Error modes (surface as UI fallback bubbles, never crashes)
- `NoActiveModel` (user has not selected/installed a model yet → route to Model Selection)
- `ModelNotReady` (selected model still loading)
- `ModelCorrupt` (checksum/version mismatch → offer repair/redownload)
- `DeviceUnsupported` (below 6GB tier)
- `InsufficientStorage`
- `ModelNotInstalledOffline` (selected model needs a one-time download, currently offline)
- `GenerationTimeout`
- `GenerationCancelled`

## Provider strategy (future-proofing, not implemented)
`AiInferenceController` selects a provider. Phase 1 ships exactly one: the local `FlutterGemmaLocalSlmService`. A future online/API-key provider or a future Intent-JSON-capable provider can be added behind the same controller without changing `AiAssistantBody` or the chat UI.

## Consumed by
- `AiInferenceController.generate(userText)` → single call site from `AiAssistantBody._onSend()`.

## Implementation status (M4, 2026-06-29)
- Interface implemented (text-only): `isReady`, `load(modelId, modelFilePath)`, `generate`, `generateText`, `cancel`, `dispose` + exceptions `LocalSlmUnavailable`/`LocalSlmCancelled`/`LocalSlmTimeout`.
- **Default binding = `UnavailableLocalSlmService`** (never runs inference; signals unavailability). The real `FlutterGemmaLocalSlmService` is **pending until the FU-1 (on-device spike) / FU-2 (model distribution) boundary** and is swapped in at M6. `flutter_gemma` is **not** yet a dependency.
- `AiInferenceController` returns typed results (`FreeTextResponse`/`NoActiveModel`/`ModelNotInstalled`/`ModelCorrupt`/`ModelLoadFailed`/`GenerationFailed`/`GenerationCancelled`/`GenerationTimeout`); never downloads, navigates, or persists chat.
