---
description: "Phase-1 task list — Local SLM AI Assistant (offline free-text POC)"
---

# Tasks: Local SLM for AI Assistant (Phase 1 — Offline Free-Text POC)

**Input**: Design documents from `specs/001-local-slm-ai-assistant/`
**Source of truth**: [plan.md](./plan.md) (updated — user-initiated model selection). Also: [spec.md](./spec.md), [research.md](./research.md), [data-model.md](./data-model.md), [contracts/local_slm_service_contract.md](./contracts/local_slm_service_contract.md), [quickstart.md](./quickstart.md).

## Locked scope (phase 1)
Local **free-text only** · `flutter_gemma` runtime · Gemma 3 1B first · Qwen2.5 1.5B Arabic challenger (conditional) · llama.cpp/GGUF = conditional fallback only · Android-first, 6GB RAM · **user-initiated model download from a Model Selection UI (no auto-download)** · installed-model badge + use-without-redownload · **model state persisted, chat history NOT persisted**.

**Future Scope — NO tasks generated**: IntentParser, IntentResult, JSON schema validation, backend handoff, MCP, SQL/DB access, API-key baseline, persistent chat history, LoRA/fine-tuning, llama.cpp implementation (deferred conditional fallback only).

## Conventions
- **Module root**: `systems/project_management/`
- **Feature root**: `systems/project_management/lib/features/ai_assistant/`
- **Local SLM root**: `…/ai_assistant/local_slm/`
- `[P]` = parallelizable (different files, no dependency). `[COND]` = conditional task.
- Each task lists: **Milestone · Files · Depends on · Acceptance · Conditional**.

---

## ⭐ POC_DEMO_REAL_CHAT (2026-06-29) — immediate objective: real end-to-end demo NOW

**Goal:** run the app → open AI Assistant → Model Selection → tap Download → real progress → install → chat → ask Arabic/English → **real on-device `flutter_gemma` responses**. Working demo prioritized over production hardening.

**Wired (behind `kPocDemoRealChat = true` in `local_slm/poc_demo_flags.dart`):**
- **Demo model = Qwen2.5 1.5B** (`qwen_2_5_1_5b`), public & ungated (Apache-2.0). Shows "Demo ready", size ~1.57 GB.
  - URL: `https://huggingface.co/litert-community/Qwen2.5-1.5B-Instruct/resolve/main/Qwen2.5-1.5B-Instruct_seq128_q8_ekv1280.task`
  - **Gemma 3 1B stays gated** (no URL) so it does not block the demo.
- **Real downloader** `FlutterGemmaNetworkDownloader` (flutter_gemma network install + progress + resume/foreground service) — runs only on explicit Download tap.
- **ModelManager.allowUnverifiedInstall = true** → installs with a public URL and **no SHA256** (checksum verify skipped in demo).
- **Real engine** `FlutterGemmaLocalSlmService(assumeAlreadyInstalled: true)` bound as `LocalSlmService` → loads the network-installed model, free-text only.
- **Download CTA → progress UI → chat** wired in `AiAssistantView`.

**Deferred production hardening (TODO — do NOT mark complete):**
- Restore mandatory SHA256 (set `allowUnverifiedInstall = false`; populate catalog `sha256`).
- Resolve Gemma gated distribution / final production URL + access strategy (FU-2).
- Durable `ModelStateStore` (replace `InMemoryModelStateStore`) — state still resets on restart.
- Android 6GB physical-device validation (FU-1) — not closed by an iOS/Simulator run.
- Production download error-handling, cancel/resume UX, repair/redownload.

**Restore production:** flip `kPocDemoRealChat` to `false` (DI falls back to `Noop`/`Pending`/`Unavailable`), or delete `poc_demo_flags.dart` + `flutter_gemma_network_downloader.dart` and revert the catalog URL.

---

## M0 — Model File Verification (MANDATORY GATE) 🚦

> Spike/verification milestone. **No UI work may start until T001 passes for Gemma 3 1B.** Records the Phase-0 decision gate in `research.md`.
>
> **M0 status (2026-06-29): desk verification DONE; on-device spike PENDING (FU-1).** Both model files confirmed on `litert-community`: Gemma 3 1B `gemma3-1b-it-int4.task` (~529 MB, gated) and Qwen2.5 1.5B `dynamic_int8 .task` (~1.6 GB, Apache-2.0, ready — no conversion). **G0 = PASS (desk)**, **G1 = PASS (conditional, size caveat)** → proceed to M1. See `research.md` → "M0 Execution Findings". Follow-ups: FU-1 (device spike before M6), FU-2 (Gemma hosting before M3), FU-3 (Qwen int8 size decision at M5/M7).

### T001 — Verify Gemma 3 1B file for `flutter_gemma` — ◑ DESK-VERIFIED (device spike pending → FU-1)
- **Milestone**: M0
- **Files**: `specs/001-local-slm-ai-assistant/research.md` (findings recorded)
- **Depends on**: —
- **Acceptance**: A `flutter_gemma`-compatible Gemma 3 1B file is identified (format `.task`/`.litertlm`, Android arm64, ~0.5 GB, reachable URL, SHA256 captured, storage path confirmed); installs via `flutter_gemma`, opens a chat session, and returns a coherent free-text reply (AR + EN) on a **6GB Android device** within ~5s for a short prompt. Findings + **G0 outcome** written to `research.md`.
- **Status (2026-06-29)**: Desk portion ✅ — `litert-community/Gemma3-1B-IT` → `gemma3-1b-it-int4.task` (~529 MB, MediaPipe `.task`, arm64, Gemma-gated), URL pattern + checksum strategy + install path recorded. **On-device install/generation NOT run here → FU-1.** **G0 = PASS (desk).**
- **Conditional**: No — gate.

### T002 [P] [COND] — Verify Qwen2.5 1.5B availability/conversion for `flutter_gemma` — ◑ DESK-VERIFIED (ready file, no conversion)
- **Milestone**: M0
- **Files**: `specs/001-local-slm-ai-assistant/research.md` (findings recorded)
- **Depends on**: — (parallel with T001)
- **Acceptance**: Determine whether a ready `.task`/`.litertlm` Qwen2.5 1.5B file exists; if not, document the conversion path + risk. If usable/convertible with acceptable effort → marked Arabic challenger. **G1 outcome** recorded.
- **Status (2026-06-29)**: ✅ Ready file found — `litert-community/Qwen2.5-1.5B-Instruct` → `dynamic_int8 .task` (~1.6 GB, Apache-2.0, arm64). **No conversion needed.** ⚠️ Size ~1.6 GB exceeds ~1.2 GB soft cap (no int4 `.task` found). **G1 = PASS (conditional — size caveat).** Marked benchmark challenger; final inclusion at M5/M7 (FU-3). llama.cpp/GGUF stays deferred fallback only.
- **Conditional**: Yes — challenger; not the first integration model.

### T003 — Record Step 0 decision gate (dependency add deferred to M1) — ◑ DECISION RECORDED
- **Milestone**: M0
- **Files**: `specs/001-local-slm-ai-assistant/research.md`, `specs/001-local-slm-ai-assistant/tasks.md`
- **Depends on**: T001 (T002 informs challenger row)
- **Acceptance**: Decision table (G0/G1) finalized in `research.md`; `flutter_gemma` dependency pinned in module `pubspec.yaml`.
- **Status (2026-06-29)**: Decision gate ✅ recorded (G0 PASS desk, G1 PASS conditional → proceed to M1). **`pubspec.yaml` NOT modified** — adding the `flutter_gemma` dependency is deferred to the start of **M1** to honor the strict "M0-only, no production changes" scope of this run.
- **Conditional**: No.

**Checkpoint M0**: ◑ **Desk verification complete → G0/G1 PASS → M1 may begin.** On-device spike (FU-1) scheduled before M6; Gemma hosting (FU-2) before M3.

---

## M1 — Model Catalog + Model State Persistence ✅ DONE (2026-06-29)

> No model files bundled — manifest only. Persist **model state** only; never chat history. All M1 tasks implemented; 19 unit tests pass; `flutter analyze` clean. No pubspec/asset/UI changes this run.

### T004 [P] — Add `ModelCatalogEntry` + `ModelCatalog` from manifest — [X]
- **Milestone**: M1
- **Files**: `…/local_slm/model_catalog.dart`
- **Depends on**: T003
- **Acceptance**: `ModelCatalogEntry` holds id, displayName, role, shortDescription, recommendationLabel, format, expectedFileName, expectedSizeBytes, estimatedSizeLabel, version, gated, accessNote, supportStatus, downloadUrl?, sha256?. `ModelCatalog` exposes 2 entries: Gemma 3 1B (primary) + Qwen2.5 1.5B (challenger). No model files.
- **Status**: ✅ Implemented as an immutable **in-code seed** (not a JSON asset) to avoid bundling/pubspec changes this run; download URL + SHA256 are null placeholders (FU-2). Externalizing to `model_catalog.json` is an optional refinement deferred to M2.
- **Conditional**: No.

### T005 [P] — Add `ModelInstallationState` — [X]
- **Milestone**: M1
- **Files**: `…/local_slm/model_installation_state.dart`
- **Depends on**: T003
- **Acceptance**: enum + helpers, pure, unit-testable.
- **Status**: ✅ `notInstalled · downloading · installed · failed · corrupt` (corrupt = checksum/version mismatch). Device-tier `unsupported` is a ModelManager (M3) concern, not a persisted state. `isUsable`/`isDownloadable`/wire round-trip covered by tests.
- **Conditional**: No.

### T006 — Add `ActiveModelStore` (persist model state only) — [X]
- **Milestone**: M1
- **Files**: `…/local_slm/active_model_store.dart`
- **Depends on**: T004, T005
- **Acceptance**: per-model `{id, version, checksum, localPath, status}` + global `activeModelId`; API `setActiveModel/activeModelId/installedModels/markInstalled/markCorrupt/clear`; survives restart; never persists chat.
- **Status**: ✅ Implemented against an injectable `ModelStateStore` abstraction with `InMemoryModelStateStore` binding (JSON-serialized records). Durable backend (Hive via core_system / shared_preferences) is a one-line DI swap deferred to M2/M3 — **persist note**: in-memory binding is not cross-restart durable yet; the contract/serialization is complete and the "reopen over same backing" test proves persistence semantics.
- **Conditional**: No.

### T007 — Register M1 components in DI — [X]
- **Milestone**: M1
- **Files**: `lib/core/di/project_management_locator.dart`
- **Depends on**: T004, T006
- **Acceptance**: `ModelCatalog`, `ActiveModelStore` (+`ModelStateStore`) registered via guarded `registerLazySingleton`; no existing registration broken.
- **Status**: ✅ Registered; `flutter analyze` clean.
- **Conditional**: No.

### T008 [P] — Unit tests: catalog + active-model store + installation state — [X]
- **Milestone**: M1
- **Files**: `test/features/ai_assistant/local_slm/model_catalog_test.dart`, `…/active_model_store_test.dart`, `…/model_installation_state_test.dart`
- **Depends on**: T004, T005, T006
- **Acceptance**: catalog 2 entries/no files; store persists/reads all fields + simulated restart; chat history NOT persisted.
- **Status**: ✅ **19 tests pass** (`flutter test test/features/ai_assistant/local_slm/`).
- **Conditional**: No.

**Checkpoint M1**: catalog + persisted model state available to UI/controllers.

---

## M2 — Model Selection UI / Entry Flow (user-initiated)

> Entry routes to Model Selection first. **No automatic download.**

> **M2 status (2026-06-29): DONE (UI + controller).** 12 new tests pass (31 total); `flutter analyze` clean. **No download, no inference, no navigation, no new deps, no durable persistence.** Storage stays in-memory (`InMemoryModelStateStore`) by decision → durable backend deferred (see **FU-DURABLE-STORE**). Active-model is set/read **in the current session only**; cross-restart persistence is **NOT** claimed in M2.

### T009 — Add `ModelSelectionController` — [X]
- **Milestone**: M2
- **Files**: `…/local_slm/model_selection_controller.dart`
- **Depends on**: T006, T007
- **Acceptance**: `buildCards()` reflects install/active state; `onSelect(id)` → installed: `setActiveModel` + `OpenChatRequested`; not-installed: `DownloadRequired` (**no download, no active change**); corrupt: `RepairRequired`; switching installed models re-points active with no re-download.
- **Status**: ✅ Pure controller emitting sealed `ModelSelectionAction` (`OpenChatRequested`/`DownloadRequired`/`RepairRequired`). Never downloads, never runs inference, never navigates.
- **Conditional**: No.

### T010 — Build Model Selection view — [X]
- **Milestone**: M2
- **Files**: `…/local_slm/model_selection_view.dart`
- **Depends on**: T009
- **Acceptance**: 2 cards; each: name, estimated size, recommendation label, short description, installed/active status, CTA = Download/Use (+Repair); installed shows check mark + Installed badge; gated badge. No download on render.
- **Status**: ✅ Self-contained (standard Material theming, optional `onOpenChat`/`onDownloadRequired`/`onRepairRequired` callbacks; defaults to placeholder SnackBars — no navigation). Deliberate: uses standard theme + fixed sizing (not `context.color`/ScreenUtil) for testability; AR/EN localization is a later polish (strings are literals).
- **Conditional**: No.

### T011 — Route AI Assistant entry through Model Selection — [X] (M6-A safe route)
- **Milestone**: M2 → **moved to M6-A**
- **Files**: `…/view/ai_assistant_view.dart`, `…/local_slm/model_selection_view.dart`
- **Status**: ✅ The live AI Assistant entry now shows Model Selection first. Rendering the entry/selection screen does **not** download, infer, or activate a model. Tapping a not-installed model shows a pending-distribution message because FU-2 URL/checksum is unresolved. Tapping an installed/test-installed model sets it active and opens the local chat path safely.
- **Conditional**: No.

### T012 — Register M2 components in DI — [X]
- **Milestone**: M2
- **Files**: `lib/core/di/project_management_locator.dart`
- **Depends on**: T009
- **Acceptance**: `ModelSelectionController` registered (guarded lazy singleton); no regressions.
- **Status**: ✅ Registered; analyzer clean.
- **Conditional**: No.

### T013 [P] — Unit + widget tests: selection routing — [X]
- **Milestone**: M2
- **Files**: `test/features/ai_assistant/local_slm/model_selection_controller_test.dart`, `…/model_selection_view_test.dart`
- **Depends on**: T009
- **Acceptance**: installed → active + OpenChatRequested, no download; not-installed → DownloadRequired, no active change, no record; corrupt → RepairRequired; switch installed → no re-download; view shows cards/sizes/CTAs, opening screen triggers **no** download, tap emits planned action.
- **Status**: ✅ 12 tests pass (6 controller + 3 view + reuses M1).
- **Conditional**: No.

### FU-DURABLE-STORE [COND] — Durable `ModelStateStore` backend (DEFERRED by decision)
- **Milestone**: post-storage-strategy (not M2/M3-blocking)
- **Acceptance**: Replace `InMemoryModelStateStore` DI binding with a durable backend (dedicated DB / shared storage layer, or Hive/shared_preferences) **after the project's storage strategy is decided**; then active-model + installed-model state persists across app restart.
- **Note**: model **files** still must exist locally for offline inference (separate concern, M3); only model-**state metadata** durability is deferred.
- **Conditional**: Yes — awaiting storage-layer decision.

**Checkpoint M2**: ✅ User can see/select models (standalone screen); CTAs reflect Download/Use/Repair; nothing downloads without an explicit tap; active model tracked in-session. Durable persistence + live-entry routing deferred (FU-DURABLE-STORE, T011→M6).

---

## M3 — ModelManager Download/Install Lifecycle (user-initiated) ✅ DONE (lifecycle) / ⛔ real download BLOCKED on FU-2

> **M3 status (2026-06-29):** lifecycle implemented + 15 tests pass (46 total); `flutter analyze` clean. Built behind injectable abstractions (`ModelDownloader`/`ChecksumVerifier`/`ModelFilePathResolver`/`DeviceCapabilityProbe`). **No auto-download; no inference; no durable persistence; no new deps** (`flutter_gemma` intentionally NOT added yet). **FU-2 unresolved → real production download is gated behind `pendingDistribution`** (catalog URLs/SHA256 still null). DI registers `Noop`/`Pending`/`Permissive` defaults.

### T014 — Implement `ModelManager` (device tier + storage pre-flight) — [X]
- **Milestone**: M3
- **Files**: `…/local_slm/model_manager.dart`, `…/local_slm/model_downloader.dart` (probe abstraction), `…/local_slm/model_catalog.dart` (added `minRamMb`, default 6144)
- **Depends on**: T004, T006
- **Acceptance**: RAM/storage pre-flight before any download; unknown → non-blocking; below-tier → `failed(unsupportedDevice)`, low space → `failed(insufficientStorage)`, **no bytes fetched**.
- **Status**: ✅ `DeviceCapabilityProbe` (permissive default) + pre-flight in `downloadSelectedModel`.
- **Conditional**: No.

### T015 — Implement user-initiated `downloadSelectedModel(id)` — [X] (real fetch gated by FU-2)
- **Milestone**: M3
- **Files**: `…/local_slm/model_manager.dart`, `…/local_slm/model_install_event.dart`, `…/local_slm/model_downloader.dart`
- **Depends on**: T014
- **Acceptance**: Called only via explicit user action; streams progress; SHA256 + version verify; on success → `markInstalled` + `setActiveModel`. **No background/auto path.**
- **Status**: ✅ Implemented; emits `preflight → downloading(progress) → verifying → installed`. **Real fetch blocked**: when `downloadUrl`/`sha256` null or downloader unavailable → `pendingDistribution` (no bytes). `flutter_gemma`/real downloader wired when FU-2 closes (no manager change needed).
- **Conditional**: No.

### T016 — Cancel / retry + corrupt handling — [X]
- **Milestone**: M3
- **Files**: `…/local_slm/model_manager.dart`, `…/local_slm/model_downloader.dart`
- **Depends on**: T015
- **Acceptance**: cancel → `failed(cancelled)` clean state; IO error → `failed(downloadError)` + retry possible; checksum/version mismatch → `markCorrupt`, not installed, `repair()` redownloads.
- **Status**: ✅ Covered by tests (cancel/IO/retry/checksum/repair). Resume is delegated to the real downloader (deferred with FU-2).
- **Conditional**: No.

### T017 — Switch-without-redownload + delete/reset — [X]
- **Milestone**: M3
- **Files**: `…/local_slm/model_manager.dart`, `…/local_slm/active_model_store.dart`
- **Depends on**: T015, T006
- **Acceptance**: `isInstalledAndValid(id)` (version+checksum) avoids redownload; switching installed models sets active with no re-download; `clear()`/`repair()` reset paths.
- **Status**: ✅ `isInstalledAndValid` short-circuits redownload; M2 switching already verified; `ActiveModelStore.clear` used by `repair`.
- **Conditional**: No.

### T018 — Wire download progress into Model Selection/chat-loading UI — ⏸ DEFERRED (with T011 → M6 / FU-2)
- **Milestone**: M3 → deferred
- **Files**: `…/local_slm/model_selection_view.dart`
- **Reason**: progress UI wiring is only meaningful once real downloads are enabled (FU-2) and the chat-loading target exists (M6 / T011). The controller already emits `DownloadRequired`; `ModelManager` exposes an observable progress stream ready to bind. Wiring deferred to avoid a progress UI that can only show `pendingDistribution` today.
- **Conditional**: Depends on FU-2.

### T019 — Register `ModelManager` in DI — [X]
- **Milestone**: M3
- **Files**: `lib/core/di/project_management_locator.dart`
- **Depends on**: T014
- **Acceptance**: `ModelManager` + downloader/verifier/resolver/probe registered (guarded); no regressions.
- **Status**: ✅ Registered with `NoopModelDownloader` + `Pending*`/`Permissive*` defaults (swap at FU-2). Analyzer clean.
- **Conditional**: No.

### T020 [P] — Unit tests: lifecycle + tier + states — [X]
- **Milestone**: M3
- **Files**: `test/features/ai_assistant/local_slm/model_manager_test.dart`
- **Depends on**: T014, T016
- **Acceptance**: no auto-download; explicit-only; progress observable; no redownload when valid; checksum fail → corrupt/not-installed; success → installed + path/version/checksum + active; cancel clean; retry; unsupported/insufficient/pending; unknown model; repair; version mismatch; no chat-history keys.
- **Status**: ✅ **15 tests pass.**
- **Conditional**: No.

**Checkpoint M3**: ✅ lifecycle complete & tested. ⛔ **Real download blocked until FU-2** (returns `pendingDistribution`). Progress-UI wiring (T018) deferred with T011→M6.

---

## M4 — LocalSlmService + AiInferenceController (text-only) ✅ DONE (abstraction + controller)

> **M4 status (2026-06-29):** text-only interface + controller implemented; 11 new tests pass (57 total); `flutter analyze` clean. **No real inference, no `flutter_gemma` (still deferred), no UI change, no download, no chat-history persistence, no Intent/JSON/backend/MCP.** Default service = `UnavailableLocalSlmService` (signals unavailability; never generates). Real `FlutterGemmaLocalSlmService` deferred to FU-1/FU-2 boundary.

### T021 — Define `LocalSlmService` interface (text-only) — [X]
- **Milestone**: M4
- **Files**: `…/local_slm/local_slm_service.dart`
- **Depends on**: T003
- **Acceptance**: `isReady`, `load(modelId, modelFilePath)`, `generate(...)`, `generateText(...)`, `cancel()`, `dispose()`; **no `generateIntent()`**.
- **Status**: ✅ Interface + exceptions (`LocalSlmUnavailable`/`LocalSlmCancelled`/`LocalSlmTimeout`) + safe `UnavailableLocalSlmService` default. Matches the contract.
- **Conditional**: No.

### T022 — Implement `FlutterGemmaLocalSlmService` — ⏸ DEFERRED to FU-1/FU-2 (M6 boundary)
- **Milestone**: M4 → deferred
- **Files**: `…/local_slm/flutter_gemma_local_slm_service.dart` (not created yet)
- **Reason**: real inference requires the `flutter_gemma` dependency + a real installed model, both blocked by FU-2 (distribution) and validated by FU-1 (device spike). Per run scope ("do not implement real flutter_gemma inference"), the engine is represented by `UnavailableLocalSlmService` and swapped in at M6.
- **Conditional**: Depends on FU-1/FU-2.

### T023 — Implement `AiInferenceController` — [X]
- **Milestone**: M4
- **Files**: `…/local_slm/ai_inference_controller.dart`
- **Depends on**: T021, T006
- **Acceptance**: resolves active model; validates install/version/checksum via `ModelManager` (no download); loads-if-needed → `generateText`; returns typed results; records `PocMetrics`.
- **Status**: ✅ Sealed `AiInferenceResult`: `FreeTextResponse` · `NoActiveModel` · `ModelNotInstalled` · `ModelCorrupt` · `ModelLoadFailed` · `GenerationFailed` · `GenerationCancelled` · `GenerationTimeout`. Never downloads, never navigates, never persists chat.
- **Conditional**: No.

### T024 — Add `PocMetrics` — [X]
- **Milestone**: M4
- **Files**: `…/local_slm/poc_metrics.dart`
- **Depends on**: T003
- **Acceptance**: records latency/model/lang/tier/quality (no DB, no PII, no secrets).
- **Status**: ✅ `PocMetric` + `PocMetrics` (+ `InMemoryPocMetrics`); controller records full latency + detected lang.
- **Conditional**: No.

### T025 — Register M4 components in DI — [X]
- **Milestone**: M4
- **Files**: `lib/core/di/project_management_locator.dart`
- **Depends on**: T021, T023
- **Acceptance**: `LocalSlmService` (→ default `UnavailableLocalSlmService`), `PocMetrics`, `AiInferenceController` registered (guarded); no regressions.
- **Status**: ✅ Registered; analyzer clean. (Real `FlutterGemmaLocalSlmService` replaces the default at M6/FU-2.)
- **Conditional**: No.

**Checkpoint M4**: ✅ active model can be driven through a clean text-only abstraction with typed results; real engine deferred (UnavailableLocalSlmService default). No UI, no inference, no new deps.

---

## M5 — PromptBuilder + MetadataLoader

### T026 [P] — Add base system instruction asset (AR/EN) — [X]
- **Milestone**: M5
- **Files**: `systems/project_management/assets/ai/prompts/system_instruction.txt`; `pubspec.yaml` (register asset)
- **Depends on**: T003
- **Acceptance**: Concise executive assistant role; answer in user's language; **no fabricating facts**; polite "not enough information" when unsure; phase-1 answers are model-generated, **not** live system data.
- **Status**: ✅ Added `assets/ai/prompts/system_instruction.txt` and registered it in `pubspec.yaml`. The instruction is generic, concise, free-text only, language-aware, and includes the local/no-live-data limitation.
- **Conditional**: No.

### T027 [P] — Implement `MetadataLoader` + sample metadata — [X]
- **Milestone**: M5
- **Files**: `…/local_slm/metadata_loader.dart`; `systems/project_management/assets/ai/metadata.sample.json`; `pubspec.yaml` (register asset)
- **Depends on**: T003
- **Acceptance**: Loads/parses **mobile-safe** metadata (`version`, `generatedAt`, `domain`, AR/EN `terms`, `concepts`, `enums`); rejects forbidden keys (`sql`, `dsn`, `credentials`, `tenant`, `permission`, raw table/column names); supports domain slicing; kept compact for context window.
- **Status**: ✅ Added `MetadataLoader`, `MetadataBundle`, domain/term/concept/value models, compact domain slicing, safe null fallback for missing asset, validation errors for malformed/forbidden metadata, and `assets/ai/metadata.sample.json` with sample-only AR/EN labels. No real rows, secrets, schema, or query text included.
- **Conditional**: No.

### T028 — Implement `PromptBuilder` — [X]
- **Milestone**: M5
- **Files**: `…/local_slm/prompt_builder.dart`
- **Depends on**: T026, T027
- **Acceptance**: `build({userText, metadata?, systemInstruction})`; detects language (Arabic Unicode → `ar`, else `en`, mixed → dominant); assembles system + optional compact metadata + user; applies no-hallucination + answer-in-language guidance; respects maxTokens.
- **Status**: ✅ Added standalone `PromptBuilder` with Arabic/English/mixed dominant-language detection, compact optional metadata injection, optional active-model display hint, prompt size cap, and explicit local/free-text/no-live-data guidance inherited from the system instruction. Kept standalone and registered in DI for later M6 use; `AiInferenceController` behavior is unchanged.
- **Conditional**: No.

### T029 [P] — Unit tests: PromptBuilder + MetadataLoader — [X]
- **Milestone**: M5
- **Files**: `test/features/ai_assistant/local_slm/prompt_builder_test.dart`, `…/metadata_loader_test.dart`
- **Depends on**: T027, T028
- **Acceptance**: language detection (AR/EN/mixed); metadata injection on/off; mobile-safe rejection of forbidden keys; domain slicing; deterministic prompt assembly.
- **Status**: ✅ Added `prompt_builder_test.dart` and `metadata_loader_test.dart`. Covered asset loading, language guidance, mixed-language dominance, metadata include/skip behavior, missing/malformed fallback behavior, forbidden-key rejection, future-scope prompt guardrails, and local/free-text/no-live-data limitation.
- **Conditional**: No.

**Checkpoint M5**: ✅ prompts are built with optional safe metadata; ready to feed the active model. No real inference, model download, UI routing, chat persistence, structured output, backend handoff, MCP, SQL/DB access, or LoRA added.

---

## M6 — Chat UI Integration With Active Model

> Visual UI unchanged except loading/progress + error/fallback. Reuse existing chat state.

### T030 — Wire `_onSend()` to `AiInferenceController` — [X] (M6-A safe/controller wiring)
- **Milestone**: M6
- **Files**: `…/widgets/ai_assistant_body.dart`
- **Depends on**: T023, T028, T011
- **Acceptance**: At `_onSend()`, call `AiInferenceController.generate(text)` for the active model; reuse `_entries`/`_ChatEntry` (append user → thinking → free-text result); stream tokens into the result bubble; `_isSending` blocks concurrent inference; `startNewChat()` clears in-memory entries (no persistence). Existing online `AiAssistantRepo` path untouched.
- **Status**: ✅ Added a controlled local-mode path in `AiAssistantBody`: when opened from Model Selection, `_onSend()` calls `AiInferenceController.generate(text)` and renders the typed free-text/fallback result in the existing chat bubble style. The old online repo path remains available for non-local mode. Full token streaming and PromptBuilder injection into the controller remain M6-B/real-engine work.
- **M6-A2 Status**: ✅ `AiInferenceController` now builds the final prompt with `PromptBuilder` before `LocalSlmService.generateText`, using the system instruction asset, optional safe metadata, user text, and active catalog model. Prompt building happens only after active/installed/valid checks. Prompt failures return safe `GenerationFailed`; no download path is introduced. UI bubbles still render only the assistant response/fallback, not the internal prompt.
- **Conditional**: No.

### T031 — Error/fallback bubbles (no crash) — [X] (M6-A safe fallbacks)
- **Milestone**: M6
- **Files**: `…/widgets/ai_assistant_body.dart` (+ reuse fallback widget)
- **Depends on**: T030
- **Acceptance**: Renders fallback for `NoActiveModel` (route to selection), `ModelNotReady`, `ModelCorrupt` (repair), `DeviceUnsupported`, `InsufficientStorage`, `ModelNotInstalledOffline`, `GenerationTimeout`, `GenerationCancelled` — all without crashing or altering the base layout.
- **Status**: ✅ Local-mode chat now renders safe assistant bubbles for no active model, model not installed/pending distribution, corrupt/version mismatch, local engine unavailable/load failure, generation failure, timeout, and cancellation. Download/storage/device-specific UI remains tied to real download/inference work after FU-2.
- **Conditional**: No.

### T032 — UX disclaimer (model-generated, not live data) — [X] (M6-A English fallback)
- **Milestone**: M6
- **Files**: `…/widgets/ai_assistant_body.dart` or `…/view/ai_assistant_view.dart`; locale keys in `assets/langs/ar.json`, `assets/langs/en.json`
- **Depends on**: T030
- **Acceptance**: A subtle, localized note communicates that phase-1 answers are model-generated and **not** live system data; AR + EN.
- **Status**: ✅ Local-mode chat shows a subtle phase-1 disclaimer: replies are generated text and not live database results. Kept as an English literal in M6-A to avoid locale asset churn; AR/EN localization can be polished in M6-B.
- **Conditional**: No.

### T033 — Widget test: chat with mocked `LocalSlmService` — [X] (M6-A)
- **Milestone**: M6
- **Files**: `test/features/ai_assistant/local_slm/ai_assistant_body_local_slm_test.dart`
- **Depends on**: T030, T031
- **Acceptance**: With a preset active model + mocked service: `_onSend()` appends thinking then free-text; `_isSending` gating verified; `startNewChat()` clears entries; error path renders a fallback bubble. No network/DB.
- **Status**: ✅ Added M6-A widget tests for real entry → Model Selection, no auto-download on entry/render, pending-distribution behavior for not-installed models, test-installed model → chat path, `_onSend()` → `AiInferenceController`, safe fallback bubbles, `_isSending` gating, in-memory-only `startNewChat()`, and no Intent/JSON/backend/MCP UI behavior.
- **Conditional**: No.

**Checkpoint M6-A**: ✅ safe mocked/controller UI integration complete. The real app can expose Model Selection and the chat UI can call `AiInferenceController` safely, with no real download, no real `flutter_gemma`, no model files, no persisted chat, and no structured/DB/backend behavior.

**Checkpoint M6-A2**: ✅ PromptBuilder is wired into the local inference controller. The service receives a final prompt rather than raw user text; invalid model states do not build prompts, call the service, or download.

**M6 hardening (2026-06-29)** — review findings #1 & #3 fixed; 135 local-SLM tests pass; scoped `flutter analyze` clean. No `flutter_gemma`, no real inference/download, no UI/routing/persistence/scope change.
- **#1 PromptBuilder truncation**: only the variable parts (user message, optional metadata) are trimmed; fixed sections (system + safety guidance + active-model note) and the trailing `Assistant response:` cue always survive; final prompt stays within `maxPromptChars`; over-long user text is truncated with an ellipsis; metadata is dropped (not fragmented) when it can't fit. Tests added.
- **#3 MetadataLoader forbidden keys**: substring matching replaced with whole-token matching (camelCase/snake_case/kebab/space/punctuation split). Blocks `sql/database/db/dsn/credential(s)/password/secret/token/access_token/refresh_token/tenant_secret/permission(s)/table/column/row(s)/schema/connection/connection_string` (incl. nested); allows safe collisions (`feedback`, `borrow`, `tablet`). `metadata.sample.json` still valid. Tests added.

**Checkpoint M6-B / real offline chat**: ⏳ pending FU-1/FU-2 plus real `FlutterGemmaLocalSlmService`, model load/generation on device, and real download/progress integration.

**M6-B0 device spike preparation (2026-06-29)** — ✅ prepared / ⏳ physical validation pending.
- Added `flutter_gemma 0.12.6` for the spike only, selected because current Flutter 3.38 / Dart 3.10.1 cannot resolve newer 0.16.5+ or 1.x package lines.
- Added isolated `FlutterGemmaLocalSlmService` implementing `LocalSlmService` for developer-only local-file validation. It installs only from an already-present local model path, opens a `flutter_gemma` chat session, generates free text, and maps timeout/cancel/error behavior through the existing text-only contract.
- Production DI remains unchanged: `LocalSlmService` still defaults to `UnavailableLocalSlmService`; the AI Assistant flow does not attempt real inference or model download.
- FU-2 remains unresolved: no final Gemma URL, no SHA256, no gated-access production path. Production download stays blocked.
- FU-1 remains open: no physical Android 6GB arm64 device/model binary was available in this environment, so real model generation was not executed. Quickstart now contains the M6-B0 spike checklist.

**M6-B0 spike-plan clarification (2026-06-29):**
- **SHA256 is NOT required for the local-file spike** (`fromFile(localPath)` loads a trusted local developer file). SHA256 stays required later for production network-download validation, catalog integrity, installed-model verification, and repair/redownload.
- **Spike targets allowed**: Android 6GB physical device → "Android physical-device validation"; iPhone real device → "iOS physical-device validation"; **iOS Simulator → "simulator spike only"** (not final validation). An iOS run does not replace Android 6GB target validation while Android is the phase-1 target.
- Unchanged: local file path only; no production download; no committed model files/secrets; no production DI switch; **FU-2 stays open** until final production URL + SHA256 + access strategy are resolved; production download not marked complete.

---

## M7 — Golden Set Benchmark + Go/No-Go Report

### T034 [P] — Build Golden Set (30–50 prompts)
- **Milestone**: M7
- **Files**: `test/features/ai_assistant/local_slm/golden_set.json` (or assets), benchmark sheet in [quickstart.md](./quickstart.md)
- **Depends on**: T030
- **Acceptance**: 30–50 prompts: Arabic, English, mixed AR/EN, PM/business-style, and out-of-knowledge (hallucination probes). Labeled for manual quality rating.
- **Conditional**: No.

### T035 — Benchmark Gemma 3 1B on a 6GB device
- **Milestone**: M7
- **Files**: `…/local_slm/poc_metrics.dart` (collection), benchmark sheet
- **Depends on**: T024, T034
- **Acceptance**: Run Golden Set on Gemma 3 1B; record quality 1–5, AR/EN/mixed relevance, hallucination behavior, first-token + full latency, RAM, model size, download/offline success, temperature/battery, UI responsiveness.
- **Conditional**: No.

### T036 [COND] — Benchmark Qwen2.5 1.5B (Arabic challenger)
- **Milestone**: M7
- **Files**: benchmark sheet; `model_catalog.json` (challenger entry)
- **Depends on**: T035, T002
- **Acceptance**: Only if T002 confirmed Qwen usable/convertible — run the same Golden Set and metrics; compare Arabic/mixed quality vs Gemma.
- **Conditional**: Yes — depends on T002 (G1). If not usable, record llama.cpp/GGUF as future conditional fallback (no implementation).

### T037 — Manual checklist validation (quickstart)
- **Milestone**: M7
- **Files**: [quickstart.md](./quickstart.md) (checklists A–F)
- **Depends on**: T018, T030, T031
- **Acceptance**: Execute checklists: no auto-download; 2–3 cards with sizes; Download/Use CTAs; installed badge; installed→chat without re-download; user-initiated download with progress/checksum/resume/cancel/retry; checksum failure blocks install; active model persists across restart; multiple installed models selectable; airplane-mode free-text; storage/unsupported/offline fallbacks; chat history not persisted.
- **Conditional**: No.

### T038 — Go/No-Go report (decision gates G0–G4)
- **Milestone**: M7
- **Files**: `specs/001-local-slm-ai-assistant/poc-report.md` (new)
- **Depends on**: T035, T037 (+ T036 if applicable)
- **Acceptance**: Documents selected model + runtime, metrics summary, gate outcomes (G0 file usable; G1 challenger; G2 no-auto-download UX + active persistence; G3 quality ≥70% rated ≥3/5 incl. Arabic; G4 no freeze / ≤~5s / no OOM), and the recommendation to continue with `flutter_gemma` or activate the deferred llama.cpp/GGUF fallback.
- **Conditional**: No.

**Checkpoint M7**: measured Go/No-Go decision delivered.

---

## Dependencies & Execution Order

### Milestone order (sequential gates)
`M0 (gate)` → `M1` → `M2` → `M3` → `M4` → `M5` → `M6` → `M7`
- **M0 blocks everything** (no UI/code until T001 passes for Gemma).
- M4 and M5 are largely independent of each other (both need M0/M1) and can overlap; both are required before M6.
- M6 needs M2 (entry/active model), M3 (download), M4 (generation), M5 (prompt).
- M7 needs a working M6.

### Key dependency chains
- T001 → T003 → (T004, T005) → T006 → T007 → T009 → T010 → T011
- T014 → T015 → T016/T017 → T018
- T021 → T022 → T023 → (T030)
- T026/T027 → T028 → T030 → T031/T032 → T033
- T034 → T035 → (T036 cond) → T038

### Parallel opportunities
- **M0**: T001 ‖ T002.
- **M1**: T004 ‖ T005 (then T006); tests T008 after.
- **M5**: T026 ‖ T027 (then T028).
- Test tasks (T008, T013, T020, T029, T033) run alongside their siblings once deps met.

---

## Implementation Strategy
1. **M0 first — gate.** Do not write feature code until Gemma 3 1B is verified on a 6GB device (T001).
2. **Foundation (M1).** Catalog + persisted model state.
3. **Entry + lifecycle (M2, M3).** User-initiated selection and download; verify "no auto-download" early.
4. **Inference + prompt (M4, M5).** Text-only generation behind the abstraction.
5. **Wire UI (M6).** Minimal, non-breaking integration at `_onSend()`.
6. **Measure (M7).** Golden Set → Go/No-Go.

## Notes
- `[P]` = different files, no dependency. `[COND]` = depends on a Step-0 outcome.
- Reuse existing UI/DI; do not duplicate `AiAssistantBody`, `_ChatEntry`, or the `get_it` instance.
- **No task may auto-download a model**; every download requires explicit user model selection (T015 enforces).
- **No Future-Scope tasks** were generated (Intent JSON, backend, MCP, SQL/DB, API-key baseline, persistent chat history, LoRA, llama.cpp implementation). llama.cpp/GGUF appears only as a deferred conditional fallback note (T002/T036/T038).
- Commit after each task or logical group; stop at any checkpoint to validate.
