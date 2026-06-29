# Phase 1 Data Model — Local SLM Layer (Free-Text POC)

**Feature**: 001-local-slm-ai-assistant | **Date**: 2026-06-29

These are in-app entities (Dart classes/interfaces) for the phase-1 free-text local SLM. **No database, no Intent JSON, no persistent chat history.** **Model state IS persisted** (installed/active model). Entry is via a **user-initiated Model Selection UI** — no automatic download. All live in `systems/project_management/lib/features/ai_assistant/local_slm/` (plus `view/model_selection_view.dart`).

---

## Entities

### LocalSlmService (interface) — text generation only
- `Future<void> load()` — ensure model is loaded into memory (lazy).
- `bool get isReady`
- `Stream<String> generate(String prompt, {int maxTokens, Duration? timeout})` — streamed free-text tokens.
- `Future<String> generateText(String prompt, {int maxTokens, Duration? timeout})` — convenience full-string.
- `Future<void> cancel()` — cancel in-flight generation.
- `Future<void> dispose()` — release model/session.
- **Future Scope (NOT implemented in phase 1)**: `generateIntent(...)` → documented in the contract only.

### FlutterGemmaLocalSlmService (implementation of LocalSlmService)
- Wraps `flutter_gemma` install/model/session APIs.
- Holds the active model + a single chat session (in-memory).
- Maps `flutter_gemma` text responses to the `generate` stream.
- Honors `maxTokens`, timeout, cancellation.

### AiInferenceController (strategy/orchestration)
- `Stream<String> generate(String userText)` — the single entry the chat UI calls.
- Resolves the **active** provider/model from `ActiveModelStore` (phase 1: local only). **Does not download** — chat is only reachable with an active installed model.
- Calls `LocalSlmService.load()` (load only, no download) → `PromptBuilder.build(...)` → `LocalSlmService.generate(...)`.
- Emits load/error states for the UI.
- Records `PocMetrics`.

### ModelCatalog + ModelCatalogEntry (in `model_catalog.dart`, loaded from `assets/ai/model_catalog.json`)
- `ModelCatalogEntry`: `id` (e.g. `gemma3-1b`), `displayName`, `version`, `url`, `format` (`task`/`litertlm`), `sizeBytes`/`estimatedSizeLabel`, `sha256`, `minRamMb`, `role` (`primary`/`challenger`/`fallback`), `recommendationLabel`, `shortDescription`.
- `ModelCatalog` exposes the curated 2–3 entries: Gemma 3 1B (`primary`), Qwen2.5 1.5B (`challenger`, conditional), optional Qwen3 0.6B (`fallback`).
- **App bundles the manifest only — no model files.**

### ModelInstallationState (in `model_installation_state.dart`)
- Enum/value type per model: `notInstalled` · `downloading(progress)` · `installed` · `corrupt` (checksum/version mismatch) · `unsupported` (device below tier).

### ActiveModelStore (persists MODEL STATE only — e.g. shared_preferences)
- Persisted per model: `installed model id`, `version`, `checksum`, `localPath`, `installedStatus`.
- Persisted globally: `activeModelId` (active/last-selected).
- `setActiveModel(id)`, `activeModelId`, `installedModels()`, `markInstalled(...)`, `markCorrupt(id)`, `clear(id)`.
- **Never persists chat history.**

### ModelSelectionController (routing)
- `installationStateOf(id)` (uses `ActiveModelStore` + `ModelManager` validation).
- `onSelect(id)`: if installed → validate (file/version/checksum) → `setActiveModel(id)` → open chat (no download); if not installed → open chat/loading state → `ModelManager.downloadSelectedModel(id)`; on corrupt → repair/redownload.
- Switching between installed models sets active and enters chat without re-download.

### ModelManager (user-initiated lifecycle)
- `Future<bool> deviceMeetsTier(ModelCatalogEntry)` — RAM ≥ minRamMb, free storage ≥ size + headroom.
- `Stream<DownloadProgress> downloadSelectedModel(String id)` — **only called after explicit user selection**; download + SHA256 verify + version validate (+ resume/retry/cancel). On success → `ActiveModelStore.markInstalled` + `setActiveModel`.
- `Future<bool> validateInstalled(String id)` — checksum/version check for an installed model.
- `Future<void> load(String id)` / `Future<void> deleteModel(String id)` — load into memory / reset + clear persisted state.

### PromptBuilder
- `String build({required String userText, MetadataBundle? metadata, required String systemInstruction})`.
- Detects language (Arabic Unicode range → `ar`, else `en`, mixed → dominant script).
- Assembles: system instruction + optional compact metadata context + user text.
- Enforces no-hallucination guidance and "answer in user's language".

### MetadataBundle + MetadataLoader
- `MetadataLoader.load()` reads `assets/ai/metadata.sample.json` → `MetadataBundle`.
- `MetadataBundle`: `version`, `generatedAt`, `domain`, `terms` (label AR/EN), `concepts`, `enums`.
- Validation rejects forbidden keys (`sql`, `dsn`, `credentials`, `tenant`, `permission`, raw table/column names) — mobile-safe guard.

### PocMetric (in-memory/log only, POC)
- `model`, `latencyFirstTokenMs`, `latencyFullMs`, `approxRamMb`, `deviceTier`, `lang`, `promptId`, `qualityScore?` (manual 1–5).
- `PocMetrics.record(...)` appends to an in-memory list / debug log (no DB).

---

## State transitions — Model lifecycle (user-initiated)

```
Entry ──open──▶ MODEL_SELECTION (show 2–3 catalog cards; NO download)
MODEL_SELECTION ──tap installed (Use)──▶ VALIDATE
    VALIDATE ──ok──▶ ACTIVE ──load──▶ LOADED ──generate──▶ (stream tokens)
    VALIDATE ──checksum/version mismatch──▶ CORRUPT (repair/redownload offered)
MODEL_SELECTION ──tap not-installed (Download)──▶ CHECK_TIER
    CHECK_TIER ──unsupported──▶ UNSUPPORTED (fallback message, no crash)
    CHECK_TIER ──insufficient storage──▶ NO_STORAGE (clear message, no download)
    CHECK_TIER ──offline──▶ OFFLINE_NOT_INSTALLED (clear "needs one-time download")
    CHECK_TIER ──ok + online──▶ DOWNLOADING ──progress/checksum/version──▶ INSTALLED → set ACTIVE → LOADED
    DOWNLOADING ──fail/cancel──▶ NOT_INSTALLED (clean state; retry available)
ACTIVE/LOADED ──select another installed model──▶ ACTIVE (switch, NO re-download)
LOADED ──screen exit──▶ DISPOSED (model state persisted; active id remembered)
```
> No transition downloads a model without an explicit user tap. `activeModelId` + installed state persist across app restart.

## State transitions — Chat send (reuses existing UI state)

```
idle ──_onSend(text)──▶ _isSending=true, append user _ChatEntry + thinking entry
  ──model not ready──▶ show readiness/progress or fallback bubble, _isSending=false
  ──ready──▶ stream free-text → replace thinking with result _ChatEntry
  ──timeout/error──▶ fallback bubble
  ──done──▶ _isSending=false
startNewChat() ──▶ clear _entries (in-memory only; no persistence)
```

## Relationships
- AI Assistant entry → `ModelSelectionController` → `model_selection_view.dart` (catalog cards).
- `ModelSelectionController` → `ModelCatalog`, `ActiveModelStore`, `ModelManager`.
- On active model set → chat (`AiAssistantBody`) becomes reachable.
- `AiAssistantBody._onSend()` → `AiInferenceController` (1 call site).
- `AiInferenceController` → `ActiveModelStore` (active model), `LocalSlmService`, `PromptBuilder`, `PocMetrics` (no download here).
- `PromptBuilder` → `MetadataLoader`/`MetadataBundle` (optional).
- DI registers `ModelCatalog`, `ActiveModelStore`, `ModelSelectionController`, `ModelManager`, `LocalSlmService`, `AiInferenceController` as lazy singletons in `project_management_locator.dart`.

## Explicitly excluded (Future Scope)
IntentResult, IntentParser, JSON schema, backend handoff, **persisted ChatSession/ChatMessage (chat history)**, LoRA adapter descriptors. (Persisted **model state** is in scope; persisted **chat history** is not.)
