# Implementation Plan: Local SLM for AI Assistant (Phase 1 — Offline Free-Text POC)

**Branch**: `001-local-slm-ai-assistant` | **Date**: 2026-06-29 | **Spec**: [spec.md](./spec.md)

**Input**: Feature specification from `specs/001-local-slm-ai-assistant/spec.md`

> **Phase-1 scope is LOCKED (see Clarifications 2026-06-29):** offline-first, **free-text response only**, `flutter_gemma` runtime, Gemma 3 1B first + Qwen2.5 1.5B challenger, **user-initiated model download from a Model Selection UI** (no automatic download), Android-first (6GB RAM floor), iOS not blocked but not delivered. Intent JSON, JSON validation, backend handoff, MCP, DB access, server-side baseline, persistent chat history, and LoRA are **Future Scope only**.
>
> **UX update (locked 2026-06-29, supersedes "download after first launch"):** The app **must not** auto-download any large model when the AI Assistant screen opens. Download is **user-initiated** from a Model Selection UI. The app ships only a small **model catalog/manifest** (no model files). Model **state** is persisted (installed ids, version, checksum, local path, installed status, active/last-selected id); **chat history is NOT persisted**.

---

## Summary

Build a proof-of-concept that lets the existing AI Assistant chat screen ([ai_assistant_body.dart](../../systems/project_management/lib/features/ai_assistant/widgets/ai_assistant_body.dart)) generate a **free-text answer from an on-device small language model**, fully offline once the user has installed a model. Entry goes through a **Model Selection UI** where the user explicitly picks a model: an already-installed model opens chat immediately (no download); a not-installed model downloads on user action with real progress, then becomes active. The model runs through `flutter_gemma`. The chat UI stays visually unchanged except for model-selection/loading/progress states and error/fallback messages. A small mobile-safe metadata JSON may be injected into the prompt as context only. The POC ends with a measured **Go/No-Go** recommendation and a selected model + runtime.

The work is gated by a mandatory **Step 0 — Model File Verification** that proves the required model files are actually downloadable and runnable in `flutter_gemma` *before* any UI integration begins.

---

## Technical Context

**Language/Version**: Dart / Flutter (module `project_management`, Dart SDK `>=3.8.0 <4.0.0`)

**Primary Dependencies**: `flutter_gemma` (on-device inference + model download manager), `get_it ^8.0.3` (existing DI via `projectManagementSl`). Existing: `dio`, `core_system` network layer (unused by the local path in phase 1).

**Storage**: App-private documents directory for model files (managed by `flutter_gemma`). **Persisted model state only** (e.g. `shared_preferences`): installed model ids, version, checksum, local path, installed status, active/last-selected model id. The app bundles only a small **model catalog/manifest** asset (no model files). No database in phase 1. Metadata is a bundled read-only asset. **No persistent chat history** in phase 1 — chat stays in-memory (`_entries`) and is lost on screen close/app restart unless a future persistence spec is implemented.

**Testing**: `flutter_test` unit/widget tests (PromptBuilder, MetadataLoader, readiness logic, mocked `LocalSlmService` against `AiAssistantBody`). Manual device checklists + benchmark sheet for on-device behavior.

**Target Platform**: Android first (arm64-v8a, **min target mid-range, 6GB RAM, Android 12+**). iOS architecturally open (iOS 16+, Metal, memory entitlements) but **not a phase-1 delivery target**.

**Project Type**: Mobile (Flutter multi-module monorepo; feature lives in the `project_management` system module).

**Performance Goals**: First free-text response ≤ ~5s on a 6GB device for a short prompt (model preloaded); no UI freeze during inference (isolate handled inside `flutter_gemma`).

**Constraints**: Model file ≤ ~1.2 GB; no OOM on 6GB RAM; **no automatic/background model download** — download only on explicit user selection; model loads lazily after a model is selected/active; offline operation after install; no DB credentials/SQL/tenant logic on device.

**Scale/Scope**: Single chat screen, single local provider, 2 benchmarked models (+1 optional fallback model), 30–50 prompt Golden Set.

---

## Constitution Check

*GATE: Must pass before Phase 0. Re-check after Phase 1 design.*

The project constitution at `.specify/memory/constitution.md` is an **unfilled template** (no ratified principles). The gate is therefore **non-binding**. We adopt these self-imposed gates for this feature, consistent with the spec:

- **Additive-only UI**: do not alter the existing chat layout/widgets except loading/progress + error/fallback (spec UI constraint). ✅ planned.
- **Provider abstraction**: local SLM sits behind an interface so future providers (online/API-key, Intent JSON) can be added without UI changes. ✅ planned.
- **No secrets on device**: no DB credentials, SQL, tenant/permission logic. ✅ planned.
- **Scope discipline**: no Intent JSON / backend / MCP / persistence / LoRA in phase 1. ✅ enforced in task guidance.

No violations → **Complexity Tracking left empty**.

---

## Project Structure

### Documentation (this feature)

```text
specs/001-local-slm-ai-assistant/
├── plan.md              # This file
├── spec.md              # Clarified feature spec (phase-1 locked)
├── research.md          # Phase 0 — Model File Verification findings + decisions
├── data-model.md        # Phase 1 — entities/contracts for the local SLM layer
├── quickstart.md        # Phase 1 — how to run/verify the POC + manual checklists
├── contracts/
│   └── local_slm_service_contract.md   # LocalSlmService interface contract (text-only)
└── checklists/
    └── requirements.md  # Spec quality checklist (updated: clarify complete)
```

### Source Code (repository root)

New code is added **inside the existing feature module**, not a new package, to reuse the existing DI (`projectManagementSl`) and UI:

```text
systems/project_management/
├── lib/features/ai_assistant/
│   ├── view/ai_assistant_view.dart                    # EXISTING — unchanged
│   ├── widgets/ai_assistant_body.dart                 # EXISTING — minimal integration at _onSend()
│   ├── data/repositories/ai_assistant_repo_impl.dart  # EXISTING online path — untouched
│   ├── domain/repositories/ai_assistant_repo.dart     # EXISTING — untouched
│   └── local_slm/                                     # NEW (phase 1)
│       ├── local_slm_service.dart                     # interface (text generation only)
│       ├── flutter_gemma_local_slm_service.dart       # flutter_gemma implementation
│       ├── ai_inference_controller.dart               # strategy/orchestration layer (uses active model)
│       ├── model_manager.dart                         # download/install/checksum/version/tier
│       ├── model_catalog.dart                         # ModelCatalog + ModelCatalogEntry (manifest)
│       ├── active_model_store.dart                    # persists installed state + active model id
│       ├── model_installation_state.dart             # ModelInstallationState enum/value type
│       ├── model_selection_controller.dart            # checks install state, routes to chat/download
│       ├── prompt_builder.dart                        # system instruction + metadata + user → prompt
│       ├── metadata_loader.dart                       # loads + parses mobile-safe metadata asset
│       └── poc_metrics.dart                           # latency/RAM/quality logging (POC only)
│   └── view/
│       ├── ai_assistant_view.dart                     # EXISTING — entry now routes to model selection first
│       └── model_selection_view.dart                  # NEW — model catalog UI (cards, CTA, badges)
├── lib/core/di/project_management_locator.dart        # EXISTING — add lazy registrations
├── assets/ai/
│   ├── model_catalog.json                             # NEW — small manifest (NO model files)
│   ├── metadata.sample.json                           # NEW — mobile-safe context
│   └── prompts/system_instruction.txt                 # NEW — base system prompt (AR/EN)
└── test/features/ai_assistant/local_slm/              # NEW unit/widget tests
    ├── model_catalog_test.dart
    ├── active_model_store_test.dart
    ├── model_selection_controller_test.dart
    ├── prompt_builder_test.dart
    ├── metadata_loader_test.dart
    ├── model_readiness_test.dart
    └── ai_assistant_body_local_slm_test.dart          # mocked LocalSlmService
```

**Structure Decision**: Keep everything in the `project_management` module under a new `local_slm/` folder. This reuses the existing `get_it` instance (`projectManagementSl`) and the existing chat widget, and isolates all new logic behind `LocalSlmService` + `AiInferenceController` so the UI change is minimal and reversible.

---

## Phase 0 — Model File Verification (MANDATORY GATE, before any UI work)

> Full findings: [research.md](./research.md). This is **Milestone 0** and blocks all integration.

**Purpose**: prove the model files are *actually* downloadable and runnable in `flutter_gemma`, not just theoretically listed.

### 0.A — Gemma 3 1B (first integration model)
Verify: a real downloadable file compatible with `flutter_gemma`; required format (`.task`/`.litertlm`); Android arm64 support; size (~0.5 GB expected); download URL/source; checksum strategy; storage location; installs via `flutter_gemma` install API; can `openChat()` and produce a free-text response.
- **Success**: file installs and returns a coherent free-text reply on a 6GB Android device.
- **Failure**: no compatible file / fails to load → escalate (try alternate Gemma build; if blocked, Step 0 fails the primary route).

### 0.B — Qwen2.5 1.5B (Arabic-quality challenger)
Verify: whether a ready `.task`/`.litertlm` file exists; if **not**, whether conversion (AI Edge Torch / LiteRT-LM converter) is required and document the path + risk; Android support; size (~1.0 GB expected); URL/source; checksum; free-text chat works in `flutter_gemma`. **Marked challenger, not first integration model.**
- **Success**: usable file (ready or converted with acceptable effort) → include in benchmark.
- **Failure**: no ready file AND conversion too risky/slow → **do not block phase 1**; keep Qwen GGUF + llama.cpp as a conditional fallback recorded for a later milestone.

### 0.C — Fallback condition (llama.cpp / fllama / GGUF) — NOT primary
Document (do not build) the fallback. Activate later **only if**: Qwen2.5 not practically available for `flutter_gemma`; conversion too risky/slow; `flutter_gemma` performance unacceptable; **or** a future Intent JSON phase needs strict constrained decoding (GBNF grammar).

### Decision Gate (exit Phase 0)
- Gemma 3 1B usable → **proceed to integration** with Gemma as first model. ✅ primary path.
- Qwen2.5 usable → **add to benchmark** as challenger.
- Qwen2.5 not usable → **record llama.cpp/GGUF fallback** as a future conditional milestone; continue phase 1 with Gemma only.

---

## Phase 1 — Architecture & Design

> Full entity/contract detail: [data-model.md](./data-model.md) and [contracts/local_slm_service_contract.md](./contracts/local_slm_service_contract.md).

### Entry flow (phase 1, user-initiated, free-text only)

```
AI Assistant Entry (ai_assistant_view.dart)
  └─▶ ModelSelection UI / ModelCatalog (model_selection_view.dart)
        └─▶ User selects a model
              └─▶ ModelSelectionController.onSelect(modelId)
                    ├─ INSTALLED?  → ActiveModelStore.setActiveModel(modelId) → open chat (NO download)
                    └─ NOT INSTALLED → open chat/loading state
                                        → ModelManager.downloadSelectedModel(modelId)
                                          [real progress · resume/cancel/retry · checksum · version]
                                        → mark installed → ActiveModelStore.setActiveModel(modelId)
                                        → enable chat
  └─▶ Chat (AiAssistantBody) uses the ACTIVE local model:
        _onSend() ──▶ AiInferenceController.generate(text)   (reads active model from ActiveModelStore)
                          └─▶ LocalSlmService (text-only) ─▶ FlutterGemmaLocalSlmService
                                ├─ PromptBuilder (system + optional metadata + user)
                                └─ MetadataLoader (mobile-safe asset)
                          └─▶ PocMetrics (latency/RAM/quality)
        ◀─ free-text response rendered in existing chat bubble
```

Key rules:
- **No automatic download.** A large model is fetched **only** after explicit user selection of a not-installed model. Selecting an installed model never re-downloads.
- `ModelSelectionController` checks `ModelInstallationState` (via `ActiveModelStore` + `ModelManager`) and routes to either immediate chat (installed) or download-then-chat (not installed).
- `ActiveModelStore` persists model state only (installed ids, version, checksum, local path, installed status, active/last-selected id) — e.g. `shared_preferences`. It does **not** persist chat history.
- `LocalSlmService` in phase 1 exposes **text generation only**: `Stream<String> generate(...)` / `Future<String> generateText(...)` + `load()`, `isReady`, `dispose()`. **No `generateIntent()`** in phase 1 (Future Scope — documented in the contract, not implemented).
- `AiInferenceController` uses whichever model `ActiveModelStore` reports active; in phase 1 the only provider is local. The interface leaves room for a future online/API-key provider without UI changes.
- DI: register `LocalSlmService`, `ModelManager`, `ModelCatalog`, `ActiveModelStore`, `ModelSelectionController`, `AiInferenceController` as lazy singletons in [project_management_locator.dart](../../systems/project_management/lib/core/di/project_management_locator.dart) using the existing `isRegistered`-guarded `registerLazySingleton` pattern.

### UI integration (minimal, non-breaking)
- **Entry routing**: opening the AI Assistant routes first to the Model Selection UI; chat is shown only after a model is active. No auto-download on screen open.
- Reuse `_entries`, `_ChatEntry` (user / thinking / result), `_isSending`, `startNewChat()`, the existing "thinking" animation, scroll, and input field exactly as-is.
- At `_onSend()`: call `AiInferenceController.generate(text)` (which targets the active model) and stream/append the free-text reply into a `_ChatEntry`.
- Add **only**: the Model Selection UI, a download-progress state (real %, "downloading model"), and error/fallback bubbles (device unsupported, not enough storage, model not installed + offline, checksum/version mismatch → repair/redownload, inference timeout). No redesign of the existing chat layout.
- `_isSending` (or equivalent) must continue to **block concurrent inference**.

### Model Selection UI requirements
- Show **2–3 recommended models** as cards. Each card shows: model name, **estimated size** (beside/under the name), recommendation label, short description, installed/not-installed status, active/last-used status (if any), and a CTA.
- CTA: **"Download"** when not installed, **"Use"** when installed. Installed models show a clear **check mark / Installed badge**.
- The app bundles only the **catalog/manifest** (`assets/ai/model_catalog.json`), never model files. User must explicitly choose a model before any large download starts.
- Recommended phase-1 entries: **(1) Gemma 3 1B** — lightweight / recommended first; **(2) Qwen2.5 1.5B** (or closest verified supported small Qwen) — Arabic-quality challenger; **(3) optional** weak-device fallback model, only if verified and useful.

### Installed-model behavior
- Selecting an installed model: validate file/version/checksum when needed; if valid → set active and enter chat directly (no download).
- Multiple installed models: user can pick any installed one and enter chat immediately; the chosen one becomes active.
- Selecting a different not-installed model: download only that model, then make it active after successful install.
- Checksum/version mismatch: do **not** mark installed; show **repair/redownload** option.

---

## Phase 1 — Model Download & Lifecycle (user-initiated)

Use `flutter_gemma`'s built-in install/download manager (it provides progress, SHA256 checksum, resume/retry, cancel, and an Android foreground service for files >500MB). **No automatic or background download** — every download is triggered by an explicit user model selection.

- **Trigger**: **user-initiated only** — download starts when the user taps **"Download"** on a not-installed model in the Model Selection UI. Nothing downloads on app start or on AI Assistant screen open.
- **Model selection before download**: the user must pick a model first; the app shows the progress state only after that explicit selection.
- **Progress state**: real percentage shown after selection of a not-installed model.
- **Checksum**: SHA256 verify post-download (catalog holds expected hash). Mismatch → do **not** mark installed; offer repair/redownload.
- **Version validation**: compare installed version vs catalog; mismatch → repair/redownload; allow model update without a full app release.
- **Retry/resume/cancel**: rely on `flutter_gemma` retry+resume; expose cancel (leaves a clean state); handle `DownloadException` (401/403/404/429/5xx) with user-friendly messages + retry.
- **Storage location**: app documents directory (managed). **Free-space check before download**; if insufficient → clear message, never start a doomed download.
- **Installed badge + active model persistence**: on successful verify, mark installed (persist id/version/checksum/path/status) and set active via `ActiveModelStore`; show Installed badge + Use CTA.
- **Switching between installed models**: selecting another installed model sets it active and enters chat **without re-download**.
- **Redownload only if**: file missing, corrupt (checksum fail), or version mismatch.
- **Device tier check**: verify RAM ≥ 6GB and free storage ≥ model size + headroom before allowing download/run; otherwise show fallback message (no crash).
- **Model not installed + offline**: explicit message ("this model needs a one-time download; you're offline") — distinct from an installed/ready-offline model.
- **Delete/reset**: provide a reset path (delete model file + clear its persisted state) for testing and storage recovery.

---

## Phase 1 — Local Free-Text Prompt Flow

> Chat is only reachable once a model is **active** (selected + installed). The send path never downloads.

```
User types → AiInferenceController.generate(text)   // targets ActiveModelStore's active model
  → LocalSlmService.load() if not yet loaded into memory (no download — already installed)
  → PromptBuilder.build(system, metadata?, userText, lang)
  → LocalSlmService.generate(prompt) [stream tokens, maxTokens cap, timeout, cancel]
  → append free-text to chat bubble (reuse _ChatEntry)
  → PocMetrics.record(latency, tokens, deviceTier, model)
```

PromptBuilder responsibilities:
- **Base system instruction** (AR/EN) from `assets/ai/prompts/system_instruction.txt`: assistant role, answer in the user's language, be concise/executive, **do not invent data/facts**, and **politely say you don't have enough information** when unsure (no-hallucination guidance).
- **Language handling**: detect script (Arabic Unicode range → Arabic) for Arabic/English/mixed; instruct the model to reply in the question's dominant language.
- **Optional metadata injection**: if present, append compact mobile-safe metadata as context (see below).
- **Generation controls**: `maxTokens` cap (keep small for latency/RAM), timeout, and cancellation wired through to `flutter_gemma`.

---

## Phase 1 — Local Metadata Strategy

Metadata is **context only**, not a contract, in phase 1.

Plan only:
- A single **`assets/ai/metadata.sample.json`** (mobile-safe), with `version` + `generated_at`, optionally split by domain (project/meetings/strategy) so only the relevant slice is injected.
- Contents allowed: safe high-level business terms, **Arabic/English labels**, allowed high-level concepts, enum/status display values, date-range concepts.
- **Excluded**: SQL, DB credentials/DSN, tenant logic, permission logic, sensitive table/column names, real data rows.
- `MetadataLoader` loads + parses + validates shape; keeps the injected text small to respect the context window.
- (Future Scope: real DB-derived metadata, encryption-at-rest, server-versioned download.)

---

## Phase 1 — Benchmark & Golden Set

**Golden Set**: 30–50 prompts stored as a test asset, covering:
- Arabic prompts, English prompts, mixed Arabic-English prompts.
- Project-management/business-style prompts (delayed projects, responsible person, overdue items, KPIs, meeting decisions — phrased as free-text questions).
- Out-of-knowledge prompts (to observe hallucination vs polite "I don't know").

**Models benchmarked**: Gemma 3 1B first; Qwen2.5 1.5B (or closest supported small Qwen) if verified in Step 0; optional weak-device fallback model only if time permits.

**Metrics** (recorded by `PocMetrics` + manual sheet):
free-text quality 1–5, Arabic relevance, English relevance, mixed-language understanding, hallucination behavior, latency (first-token + full), RAM, model size, download success, offline success, temperature/battery observation, UI responsiveness.

---

## Phase 1 — Acceptance Criteria (phase-1 only)

- **AC-1**: **No model download starts automatically** (not on app start, not on AI Assistant screen open).
- **AC-2**: User can **explicitly choose** which model to download/use from the Model Selection UI.
- **AC-3**: Model Selection UI shows **2–3 recommended models**, each with **estimated size** (and name, recommendation label, short description, status, CTA).
- **AC-4**: **Installed models are visually marked** (check mark / Installed badge) and show a **"Use"** CTA; not-installed show **"Download"**.
- **AC-5**: Choosing an **installed** model **opens chat without any download**.
- **AC-6**: Choosing a **not-installed** model starts download **only on user tap**, with **real progress**, SHA256 checksum, resume/cancel/retry.
- **AC-7**: After successful download, the selected model becomes **active** and **free-text chat works offline (airplane mode)**.
- **AC-8**: **Active model is remembered** across app restart (persisted model state).
- **AC-9**: Multiple installed models can be selected without re-download; chat uses the **active selected model**.
- **AC-10**: Checksum/version mismatch → model is **not** marked installed; **repair/redownload** offered.
- **AC-11**: AI Assistant UI **does not freeze** during inference; `_isSending` prevents concurrent inference; free-text shown in the existing chat bubble; UI otherwise visually unchanged.
- **AC-12**: At least one model runs acceptably on a **6GB RAM Android** device; POC metrics recorded; **Go/No-Go report** produced with selected model + runtime.
- **AC-13** *(device safety)*: unsupported device / insufficient storage / not-installed-offline → clear fallback, **no crash**.
- **AC-14**: **Persistent chat history remains out of scope** for phase 1 (in-memory only; documented as expected behavior).

> JSON-validity / Intent acceptance criteria are **deferred (Future Scope)** and intentionally excluded from phase 1.

---

## Phase 1 — Testing Plan

**Automated (no DB, no network for unit tests):**
- `model_catalog_test.dart`: parses `model_catalog.json` manifest into `ModelCatalogEntry`s; validates 2–3 entries, sizes, recommendation labels; manifest carries no model files.
- `active_model_store_test.dart`: persists/reads installed ids, version, checksum, local path, installed status, active/last-selected id; survives a simulated restart; does NOT persist chat history.
- `model_selection_controller_test.dart`: installed → sets active + routes to chat with no download; not-installed → routes to download; checksum/version mismatch → not-installed + repair; switching between installed models has no re-download.
- `prompt_builder_test.dart`: system instruction assembly, language detection, metadata injection on/off, maxTokens/format invariants.
- `metadata_loader_test.dart`: parses valid asset, rejects malformed, enforces mobile-safe shape (no forbidden keys), domain slicing.
- `model_readiness_test.dart`: device tier check (RAM/storage thresholds), states (`notInstalled`/`downloading`/`installed`/`corrupt`/`unsupported`), not-installed+offline handling.
- `ai_assistant_body_local_slm_test.dart`: widget test with a **mocked `LocalSlmService`** + active model preset — verifies `_onSend()` appends a thinking entry then a free-text result, `_isSending` gating, `startNewChat()` clears entries, error path renders fallback bubble.

**Manual checklists** (in [quickstart.md](./quickstart.md)):
- Model Selection UI (2–3 models, sizes, no auto-download, Download/Use CTAs, Installed badge).
- Installed model → opens chat immediately, no re-download.
- Not-installed model → download starts only on tap, real progress, checksum, resume-after-kill, cancel, retry on failure.
- Checksum failure prevents installed state (repair/redownload).
- Active model persists across app restart; multiple installed models selectable without re-download.
- Airplane-mode free-text test (after install); chat uses active model.
- Not-enough-storage / unsupported-device / not-installed-offline paths.
- Chat history not persisted (lost on close/restart) — documented as expected.
- Benchmark sheet for Gemma vs Qwen (metrics above).

No production DB dependency anywhere in the test plan.

---

## Risks & Mitigations

| Risk | Impact | Mitigation |
|---|---|---|
| Qwen2.5 1.5B file not practically available for `flutter_gemma` | Lose Arabic challenger | Step 0.B verifies early; document conversion path; fallback = Qwen GGUF + llama.cpp (later, conditional) |
| Gemma Arabic quality only "fair" | Weaker answers | Benchmark vs Qwen; constrain task to concise answers; escalate to Qwen/challenger if below bar |
| Model too large for user storage | Install fails | Pre-flight free-space check; clear message; consider smaller fallback model (Qwen3 0.6B) |
| Slow inference on 6GB device | Poor UX | maxTokens cap, measure CPU vs GPU backend, lazy load, keep model warm during session |
| OOM / thermal throttling | Crash/slowdown | Device tier gate (6GB+), single session, release model on screen exit, thermal observation in benchmark |
| Third-party package maturity (`flutter_gemma`) | Integration/maintenance risk | Isolate behind `LocalSlmService`; pin version; keep llama.cpp fallback documented |
| iOS later needs entitlements/config | Future delay | Keep abstraction iOS-friendly now (no Android-only APIs leaking into the interface); document iOS 16 + memory entitlements |
| Metadata may reveal business structure | Info exposure | Mobile-safe only; no sensitive names/SQL/rows; (future: encrypt-at-rest + auth-gated download) |
| Users may think free-text is real data | Trust/accuracy | UX disclaimer that phase-1 answers are model-generated, **not** live system data; no-hallucination system prompt |

---

## Future Scope (explicitly NOT in phase 1)

Intent JSON generation · IntentParser/IntentResult · JSON schema validation & contract enforcement · backend handoff & validation · MCP execution · SQL generation · production DB schema extraction · server-side / API-key SLM baseline comparison · **persistent chat history** (SQLite/Drift/Hive or backend) · LoRA / fine-tuning · GBNF constrained decoding · llama.cpp/fllama primary route. Each will be its own spec/milestone; the phase-1 interfaces are designed not to block them.

> **Chat history note**: In phase 1, chat history is **in-memory only** (current `_entries` behavior) and is **lost on screen close / app restart**. This is expected and accepted; a future persistence spec may add durable history. Note this is distinct from **model state**, which IS persisted in phase 1 (installed/active model).

---

## Task-Generation Guidance for `/speckit-tasks`

Milestones (updated):
- **M0 — Model File Verification** (gate; verification/spike with explicit success/failure + Phase-0 decision gate; no UI work until 0.A passes for Gemma 3 1B).
- **M1 — Model Catalog + Model State Persistence** (`ModelCatalog`/`ModelCatalogEntry` from `model_catalog.json`; `ActiveModelStore` persisting installed ids/version/checksum/path/status/active id; `ModelInstallationState`).
- **M2 — Model Selection UI / Entry Flow** (`model_selection_view.dart` + `ModelSelectionController`; 2–3 cards w/ size, labels, badges, Download/Use CTAs; entry routes to selection first; **no auto-download**).
- **M3 — ModelManager download/install lifecycle** (user-initiated download, progress, checksum, version validation, resume/cancel/retry, storage + tier check, installed badge, switch-without-redownload, repair on mismatch).
- **M4 — LocalSlmService + AiInferenceController integration** (text-only generate targeting active model; DI registrations).
- **M5 — PromptBuilder + MetadataLoader** (+ `assets/ai/metadata.sample.json`, system instruction AR/EN).
- **M6 — Chat UI integration with active model** (wire `_onSend()`, reuse `_entries`/`_ChatEntry`/`_isSending`/`startNewChat`, fallback bubbles; no layout redesign).
- **M7 — Golden Set benchmark + Go/No-Go report**.

Rules:
- **Do NOT generate any task that auto-downloads a model on first screen open.** Every download task must require explicit user model selection.
- Mark Qwen2.5 tasks as **conditional** on Step 0.B; mark llama.cpp/GGUF tasks as **conditional fallback (deferred)**.
- Every new file maps to the Project Structure tree above; reuse existing UI/DI files (do not duplicate).
- Include the test tasks (model catalog, active-model store, selection controller, PromptBuilder, MetadataLoader, readiness, mocked widget test) and the manual checklists.
- **Do NOT generate tasks** for any Future Scope item (Intent JSON, backend, MCP, DB, API-key baseline, persistent chat history, LoRA); reference them only as deferred.
- Each task: id, milestone, description, files touched, dependencies, acceptance check, conditional flag (if any).

---

## Final Phase-1 Route

1. **Gate on Step 0 (Model File Verification)** before any UI work.
2. **Start with `flutter_gemma` + Gemma 3 1B** — fastest, lowest-risk; reuses the existing chat UI + DI.
3. Build the **user-initiated Model Selection entry flow** (catalog manifest + persisted model state) — **no auto-download**.
4. **Benchmark Qwen2.5 1.5B inside `flutter_gemma`** as the Arabic challenger if Step 0.B confirms a usable/convertible file.
5. **Switch to llama.cpp / fllama + Qwen GGUF only if** Qwen2.5 isn't practical in `flutter_gemma`, conversion is too risky/slow, `flutter_gemma` performance is unacceptable, or a future Intent JSON phase requires GBNF constrained decoding.
6. **Decide Go/No-Go** from measured Golden Set results on a real 6GB Android device.

## Decision Gates

- **G0 (exit Step 0)**: Gemma 3 1B file usable on 6GB Android → proceed. Else fix/replace the Gemma build or fail the primary route.
- **G1 (challenger)**: Qwen2.5 usable/convertible with acceptable effort → include in benchmark; else record llama.cpp fallback as a future conditional milestone.
- **G2 (UX/no-auto-download)**: entry shows Model Selection with 2–3 models; **nothing downloads without explicit user selection**; installed → chat without download; active model persists → required to proceed.
- **G3 (quality)**: best model meets free-text quality bar (≥70% rated ≥3/5, incl. Arabic) on 6GB device → **Go**; else trigger fallback route or re-scope.
- **G4 (perf/safety)**: no UI freeze, latency ≤ ~5s short prompt, no OOM/crash → required for Go.

## First 5 tasks for `/speckit-tasks`

1. **M0 — Verify Gemma 3 1B file for `flutter_gemma`** (format, Android arm64, size, URL, checksum, install + free-text generation on a 6GB device). *Gate, blocks all UI work.*
2. **M0 — Verify Qwen2.5 1.5B availability/conversion in `flutter_gemma`** (ready `.task`/`.litertlm`? else document conversion path + risk; mark as Arabic challenger). *Conditional benchmark inclusion.*
3. **M1 — Implement `ModelCatalog`/`ModelCatalogEntry` (from `assets/ai/model_catalog.json`) + `ActiveModelStore` (persist installed ids/version/checksum/path/status + active id) + `ModelInstallationState`**; register in `project_management_locator.dart` via the existing `registerLazySingleton`/`isRegistered` pattern. *No model files bundled; no chat-history persistence.*
4. **M2 — Build Model Selection UI (`model_selection_view.dart`) + `ModelSelectionController`** showing 2–3 cards (name, size, label, description, status, Download/Use CTA, Installed badge); route AI Assistant entry to selection first; installed → set active + open chat (no download); not-installed → route to download. *No auto-download.*
5. **M3 — Implement `ModelManager` user-initiated download/install lifecycle** (download only on user tap, real progress, SHA256 checksum, version validation, resume/cancel/retry, storage + device-tier check, installed badge, switch-without-redownload, repair on mismatch).
