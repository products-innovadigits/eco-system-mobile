# Quickstart — Phase 1 Local SLM Free-Text POC

**Feature**: 001-local-slm-ai-assistant | **Date**: 2026-06-29

How to bring up and verify the phase-1 POC. M1-M6-A2 are implemented behind
safe abstractions. M6-B0 adds an isolated `flutter_gemma` spike adapter for
manual physical-device validation; production DI still uses the safe
`UnavailableLocalSlmService` until the spike passes.

---

## ⭐ POC_DEMO_REAL_CHAT — run the real end-to-end demo now

Immediate objective: a working real demo (download a public model and chat with
it on-device). Production hardening is deferred (see "Deferred" below).

**Demo model:** Qwen2.5 1.5B (public, Apache-2.0, ungated), `~1.57 GB`
`https://huggingface.co/litert-community/Qwen2.5-1.5B-Instruct/resolve/main/Qwen2.5-1.5B-Instruct_seq128_q8_ekv1280.task`
Gemma 3 1B stays gated and is NOT used for the demo.

**Run it:**
1. `kPocDemoRealChat` is `true` in `lib/features/ai_assistant/local_slm/poc_demo_flags.dart` (demo wiring on).
2. Build/run the app on your available target (iOS Simulator, iPhone, or Android device): `flutter run` from `systems/project_management` (or the host app that mounts it).
3. Open **AI Assistant** → the **Model Selection** screen appears (no auto-download).
4. On **Qwen2.5 1.5B ("Demo ready")** tap **Download** → real progress bar (Wi-Fi recommended; ~1.57 GB).
5. After install it becomes the active model and the chat opens automatically.
6. Send an **Arabic** message and an **English** message → receive real local responses from `flutter_gemma`.
7. (Installed model) re-open AI Assistant → tap **Use** → chat opens with no re-download (until app restart — model state is in-memory in demo).

**SHA256 in demo:** skipped (`ModelManager.allowUnverifiedInstall = true`, catalog `sha256 = null`). Required again for production.

**Label your result:** iOS Simulator = `simulator spike only`; iPhone = `iOS physical-device validation`; Android 6GB = `Android physical-device validation`. An iOS run does NOT close Android 6GB validation (FU-1).

**Deferred (production hardening — not complete):** mandatory SHA256; Gemma gated distribution / final URL + access (FU-2); durable model-state persistence; Android 6GB validation (FU-1); production download error handling + cancel/resume + repair.

**To restore production:** set `kPocDemoRealChat = false` (DI reverts to safe Noop/Pending/Unavailable defaults).

---

## Prerequisites
- **Phase-1 target validation = a physical Android device with 6GB RAM (arm64-v8a, Android 12+).** This remains the gating device for FU-1 if Android is still the phase-1 target. Emulators/simulators are insufficient for real inference timing/RAM.
- **M6-B0 spike may additionally run on an iOS Simulator or a real iPhone** using a local model file (see labelling rules in M6-B0). An iOS run does **not** replace Android 6GB target validation.
- `flutter_gemma 0.12.6` resolved in `systems/project_management/pubspec.yaml`
  for the local Flutter 3.38 / Dart 3.10.1 toolchain. Newer 1.x package lines
  require a newer SDK and should be revisited before production M6-B wiring.
- A model file provided as a **local developer-only file path** on the test device/simulator. **SHA256 is NOT required for the local-file spike** (`fromFile` reads a trusted local path). Do not commit the file.

## Step 0 — Model File Verification (do this first; gate)
1. Obtain a `flutter_gemma`-compatible **Gemma 3 1B** file (`.task`/`.litertlm`); record URL, size, SHA256.
2. Install via `flutter_gemma`, open a chat session, send one Arabic and one English prompt; confirm coherent free-text.
3. (Conditional) Repeat for **Qwen2.5 1.5B**; if no ready file, time-box a conversion spike and record the outcome.
4. Record results against the decision gate in [research.md](./research.md). **Do not start UI integration until 0.A passes.**

## M6-B0 — Developer-only flutter_gemma local-file spike
FU-2 remains unresolved, so **production network download must stay disabled**.
This spike validates the inference path only, using a **local model file path**
via `flutter_gemma.fromFile(localPath)` — construct `FlutterGemmaLocalSlmService`
manually in a debug-only spike harness or local test screen.

**SHA256 is NOT required for this spike.** `fromFile` loads a trusted, locally
provided developer file, so no checksum is needed to run it. SHA256 stays
**required later** for: production network download validation, catalog
integrity, installed-model verification, and repair/redownload logic. The spike
passing does **not** satisfy any of those production requirements.

Allowed spike targets (pick what you have; label the result accordingly):
- **Android 6GB physical device** → label **"Android physical-device validation"** (this is the phase-1 target validation if Android is still the target).
- **iPhone real device** → label **"iOS physical-device validation"**. Android 6GB target validation remains a separate, still-required item.
- **iOS Simulator** → label **"simulator spike only"** — NOT final device validation (no real RAM/thermal/latency signal).

Example local-file inputs:
- Android — Gemma: `/sdcard/Download/gemma3-1b-it-int4.task`
- Android — Qwen challenger: `/sdcard/Download/qwen2.5-1.5b-instruct_dynamic_int8.task`
- iOS (Simulator/device) — a local `.task` / `.litertlm` path inside the app sandbox (e.g. copied into the app Documents directory).

Expected spike path:
1. Keep `projectManagementSl<LocalSlmService>()` bound to
   `UnavailableLocalSlmService` for normal app startup (**no production DI switch**).
2. In a local debug-only harness, instantiate `FlutterGemmaLocalSlmService()`.
3. Call `load('gemma_3_1b', modelFilePath: '<local .task/.litertlm path>')`.
4. Send **one Arabic prompt** and **one English prompt** (the same final prompt
   `AiInferenceController` would pass to `generateText(...)`).
5. Record: model load success/failure, session/chat open success, English +
   Arabic outputs, first-token + full latency, crash/OOM status, and the target
   label (Android device / iOS device / iOS Simulator) in the checklist below.

Do not use `fromNetwork(...)` in M6-B0. Do not pass Hugging Face tokens through
source code, assets, logs, screenshots, or committed configuration. Do not mark
production download complete and do not close FU-2 from this spike.

## Step 1 — Wire catalog + state + abstraction (no auto-download)
- Add `local_slm/` classes and register `ModelCatalog`, `ActiveModelStore`, `ModelSelectionController`, `ModelManager`, `LocalSlmService`, `AiInferenceController` in
  `systems/project_management/lib/core/di/project_management_locator.dart` using the existing
  `if (!projectManagementSl.isRegistered<T>()) registerLazySingleton<T>(...)` pattern.
- Bundle `assets/ai/model_catalog.json` (manifest only — **no model files**).

## Step 2 — Model Selection entry (user-initiated)
- Open AI Assistant entry → **Model Selection UI appears** (2–3 cards with name, size, label, status, CTA). **Nothing downloads automatically.**
- Tap **"Use"** on an installed model → chat opens immediately (no download).
- Tap **"Download"** on a not-installed model → chat/loading state → real progress → checksum/version verify → installed badge → becomes active.
- Verify resume (kill app mid-download), cancel, retry-on-failure, and the not-enough-storage path.

## Step 3 — Free-text chat (active model)
- With a model active, type an Arabic prompt; confirm a free-text reply appears in the existing chat bubble.
- Confirm `_isSending` blocks a second concurrent send; confirm the "thinking" animation shows.
- Enable **airplane mode**; confirm generation still works (offline) using the installed active model.
- Restart the app; confirm the **active model is remembered** (no re-download). Note chat history is **not** persisted.

## Step 4 — Metadata context (optional injection)
- Place `assets/ai/metadata.sample.json` (mobile-safe) and confirm `PromptBuilder` injects a compact context slice.

## Step 5 — Benchmark
- Run the 30–50 prompt Golden Set on Gemma 3 1B (and Qwen2.5 if verified). Fill the benchmark sheet (below).

---

## Manual test checklists

### A. Airplane-mode free-text
- [ ] Model already downloaded
- [ ] Airplane mode ON
- [ ] Arabic prompt → coherent reply, no network error
- [ ] English prompt → coherent reply
- [ ] Mixed AR/EN prompt → coherent reply in dominant language
- [ ] UI never freezes; thinking state shows

### B. Model Selection UI (no auto-download)
- [ ] Entry shows **2–3 models**; each shows **estimated size**, recommendation label, short description, status, CTA
- [ ] **No download starts automatically** (app start or screen open)
- [ ] Not-installed model shows **"Download"** CTA
- [ ] Installed model shows **check mark / Installed badge** and **"Use"** CTA
- [ ] Tapping an installed model **opens chat immediately** and does **not** re-download
- [ ] Tapping a not-installed model starts download **only after the tap**

### C. User-initiated download
- [ ] Real progress percentage displayed during download
- [ ] SHA256 checksum verified before marking installed
- [ ] Checksum/version mismatch → **not** marked installed; repair/redownload offered
- [ ] Kill app mid-download → resume works (if supported)
- [ ] Cancel works and leaves a clean state
- [ ] Download errors (e.g. 5xx) show a friendly message + retry

### D. Persistence & multi-model
- [ ] **Active model persists across app restart** (no re-download)
- [ ] Multiple installed models can be selected without re-download
- [ ] Chat uses the **active selected model**
- [ ] Chat history is **not** persisted (lost on close/restart) — documented as expected

### E. Not-enough-storage / unsupported device / offline
- [ ] Insufficient free space → clear message, no doomed download
- [ ] <6GB device → "device not supported for local mode" fallback, no crash
- [ ] Not-installed model + offline → clear "needs one-time download" message

### F. Benchmark sheet (per model)
| Prompt ID | Lang | Quality 1–5 | AR relevance | EN relevance | Mixed | Hallucination? | First-token ms | Full ms | ~RAM MB | Notes |
|---|---|---|---|---|---|---|---|---|---|---|
| | | | | | | | | | | |

Also record once per model: model size, download success, offline success, peak temperature/battery observation, UI responsiveness.

### G. M6-B0 local-file spike record
| Field | Value |
|---|---|
| Tester / date | |
| **Target label** (Android physical-device validation / iOS physical-device validation / simulator spike only) | |
| Platform + OS version (Android 12+ / iOS) | |
| Device or simulator model | |
| RAM (physical device only) | |
| ABI / arch | |
| Flutter SDK | |
| `flutter_gemma` version | 0.12.6 |
| Model id | |
| Model file path (local, not committed) | |
| Model format (`.task` / `.litertlm`) | |
| Model size | |
| SHA256 | N/A for local-file spike (required only for production download) |
| Load success/failure | |
| Chat/session creation success/failure | |
| English prompt | |
| English result summary | |
| Arabic prompt | |
| Arabic result summary | |
| First-token latency | |
| Full response latency | |
| Peak memory observation | |
| Crash/OOM status | |
| Cancellation/timeout behavior | |
| Recommendation | |

---

## Done = Go/No-Go report
Produce a short report: selected model + runtime, metrics summary, gate outcomes (G0–G3), and the recommendation to continue with `flutter_gemma` or activate the llama.cpp/GGUF fallback.
