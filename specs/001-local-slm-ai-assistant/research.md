# Phase 0 Research — Model File Verification & Runtime Decisions

**Feature**: 001-local-slm-ai-assistant | **Date**: 2026-06-29

This is the **mandatory Step 0** that must complete (at least for Gemma 3 1B) before any Flutter integration begins. It records what is known from desk research and defines the on-device verification each candidate still requires.

---

## Runtime decision

**Decision**: `flutter_gemma` is the primary runtime for phase 1.
**Rationale**: Dart-first integration; built-in model download manager (progress, SHA256 checksum, resume/retry, cancel, Android foreground service for files >500MB); Android + iOS support (iOS 16+); chat sessions; CPU/GPU backends; MIT license. It removes most of the model-lifecycle plumbing we would otherwise build.
**Alternatives considered**:
- `llama.cpp` / `fllama` (GGUF): broader model/Arabic options and GBNF constrained decoding, but requires native plumbing (download manager, checksum, resume, sessions, bridge, build tuning). **Kept as conditional fallback only.**
- MediaPipe LLM Inference directly: lower-level, "experimental" per Google. Not chosen.
- MLC LLM / ONNX Runtime Mobile: weaker mobile-LLM ergonomics for this case. Rejected.

---

## Candidate 0.A — Gemma 3 1B (FIRST INTEGRATION MODEL)

| Attribute | Finding (desk research) | Must verify on-device |
|---|---|---|
| Supported by `flutter_gemma` | ✅ Officially listed | Install + generate on real device |
| Format | `.task` / `.litertlm` | Confirm which build we ship |
| Android arm64 | ✅ | Run on 6GB arm64 device |
| Size | ~0.5 GB | Confirm exact file size |
| Download URL/source | HuggingFace / Kaggle / LiteRT community builds | Confirm a concrete, reachable URL |
| Checksum | SHA256 via catalog | Capture real hash |
| Storage | app documents dir (managed) | Confirm path + free-space check |
| Free-text chat | ✅ expected | `openChat()` → coherent reply |

**Success criteria**: file installs through `flutter_gemma`, opens a session, and returns a coherent free-text reply (AR + EN) on a 6GB Android device within ~5s for a short prompt.
**Failure criteria**: no reachable compatible file, or load/inference fails/OOMs on 6GB. → try an alternate Gemma build; if still blocked, the primary route fails Step 0 and we escalate to the fallback evaluation.

---

## Candidate 0.B — Qwen2.5 1.5B (ARABIC-QUALITY CHALLENGER)

| Attribute | Finding (desk research) | Must verify on-device |
|---|---|---|
| Supported by `flutter_gemma` | ✅ Family listed as "Qwen 2.5 (0.5–1.6 GB)" with function calling on the package site | Confirm the **specific 1.5B** file works |
| Ready file (`.task`/`.litertlm`) | ⚠️ **Uncertain** — listing ≠ guaranteed prebuilt 1.5B file | Find a concrete prebuilt file |
| If no ready file | Conversion via AI Edge Torch / LiteRT-LM converter likely required | Validate conversion produces a loadable artifact |
| Conversion risk | Medium — toolchain effort, possible quality/perf variance, time cost | Time-box the spike |
| Android | ✅ expected | Run on 6GB arm64 |
| Size | ~1.0 GB (4-bit) | Confirm |
| Checksum | SHA256 via catalog | Capture |
| Free-text chat | ✅ expected | Confirm coherent AR/mixed reply |

**Status**: **challenger, not first integration model.**
**Success criteria**: a usable file exists (ready or convertible within an acceptable, time-boxed effort) and produces coherent Arabic/mixed free-text on a 6GB device → include in benchmark.
**Failure criteria**: no ready file AND conversion too risky/slow → do **not** block phase 1; record llama.cpp/GGUF fallback as a future conditional milestone and proceed with Gemma only.

---

## Candidate 0.C — llama.cpp / fllama + Qwen GGUF (CONDITIONAL FALLBACK — DO NOT BUILD NOW)

Documented only. **Activate later if and only if** one of:
- Qwen2.5 1.5B is not practically available for `flutter_gemma`;
- Qwen conversion to a supported format is too risky/time-consuming;
- `flutter_gemma` performance is unacceptable on the 6GB target;
- a future **Intent JSON** phase requires strict constrained decoding / **GBNF grammar** (llama.cpp's strength).

Trade-off if activated: we must build our own download manager, checksum, resume/retry, session management, native bridge, and Android/iOS build tuning — effort the primary route avoids.

Optional smaller fallback for weak devices (within `flutter_gemma`): **Qwen3 0.6B (~586 MB)** — only if time permits; Arabic weaker at 0.6B.

---

## Phase 0 Decision Gate (must record outcomes before integration)

| Outcome | Action |
|---|---|
| Gemma 3 1B usable on 6GB Android | ✅ Proceed to M1 integration with Gemma as first model |
| Qwen2.5 1.5B usable/convertible (acceptable effort) | ✅ Add to M5 benchmark as Arabic challenger |
| Qwen2.5 1.5B not usable | ⏸ Record llama.cpp/GGUF fallback as future conditional milestone; continue with Gemma only |
| Gemma 3 1B not usable at all | ⛔ Escalate: alternate Gemma build → else fallback evaluation; do not start UI work |

---

## M0 Execution Findings (recorded 2026-06-29)

> Scope of this run: **desk verification only** (concrete files, formats, sizes, sources, checksum strategy, install path). The **on-device spike** (install + `openChat` + Arabic/English free-text on a real 6GB Android device) was **not executed** in this environment — it is captured as a mandatory follow-up before M1 sign-off (FU-1).

### Gemma 3 1B — VERIFIED (desk)
- **Source repo**: `litert-community/Gemma3-1B-IT` (Hugging Face).
- **Recommended file**: `gemma3-1b-it-int4.task` — **~529 MB**, int4 QAT, **MediaPipe `.task`** format (mobile). `.litertlm` int4 (~529 MB) also available (desktop/LiteRT-LM). Other variants: q4_block128 `.task` (~657 MB), q4_block32 (~688 MB), q8 (~1,005 MB), fp32, and `-web.task` builds.
- **Download URL pattern**: `https://huggingface.co/litert-community/Gemma3-1B-IT/resolve/main/<filename>`
- **Android arm64**: ✅ supported via MediaPipe LLM Inference / LiteRT.
- **Size vs target**: ✅ ~529 MB ≤ ~1.2 GB cap.
- **License / access**: **Gemma Terms — GATED.** Repo requires accepting the Gemma license + HF login/token. ⚠️ A raw in-app `GET` to the HF `resolve` URL will **not** work unauthenticated.
- **Format fit**: `.task` is the mobile MediaPipe format `flutter_gemma` consumes. ✅
- **Verdict**: file/format/size/source confirmed. Desk **PASS**; on-device spike pending (FU-1).

### Qwen2.5 1.5B — VERIFIED (desk), READY FILE EXISTS (no conversion)
- **Source repo**: `litert-community/Qwen2.5-1.5B-Instruct` (Hugging Face).
- **Recommended file**: `dynamic_int8` **`.task`** — **~1,598 MB (~1.6 GB)** (ekv1280 / ekv4096 variants). fp32 `.task` is ~6.2 GB. **No ready int4 `.task` observed** in the repo listing.
- **Conversion needed?** ❌ No — a ready `.task` exists (better than the planned "conditional convert" assumption).
- **Download URL pattern**: `https://huggingface.co/litert-community/Qwen2.5-1.5B-Instruct/resolve/main/<filename>.task`
- **Android arm64**: ✅ supported (LiteRT XNNPACK CPU 4-thread; GPU tested on S25 Ultra).
- **Size vs target**: ⚠️ ~1.6 GB (int8) **exceeds the ~1.2 GB soft cap** (NFR-002). Runs on 6GB RAM but costs more storage/download. No int4 `.task` found to bring it under cap.
- **License / access**: **Apache-2.0 — NOT gated.** ✅ Freely redistributable / mirror-able; simpler for user-initiated download than Gemma.
- **Verdict**: ready challenger file confirmed (no conversion). Desk **PASS with size caveat** → treat as benchmark challenger; decide at M5/M7 whether ~1.6 GB is acceptable or seek/produce an int4 build.

### Checksum strategy (both models)
- HF serves git-LFS objects; capture each file's **SHA256** at catalog-build time (via `huggingface_hub` metadata / `X-Linked-ETag` LFS oid, or `sha256sum` after a one-time download) and store it in `assets/ai/model_catalog.json`.
- `ModelManager` (M3) verifies SHA256 post-download before marking installed; mismatch → `corrupt` → repair/redownload. (Not implemented in M0.)

### Install path
- `flutter_gemma` installs into the app documents directory (managed). Network install via `installModel(...).fromNetwork(url)` with HF token where required. (Not wired in M0.)

### Key M0 risks surfaced (for M1+ planning)
- **R-M0-1 (High, Gemma distribution)**: Gemma file is **gated** → cannot be fetched by an unauthenticated in-app download. Mitigation: **self-host/mirror** the Gemma `.task` on our own bucket/CDN after accepting the Gemma Terms (redistribution permitted under the terms), **or** use an HF token via backend proxy. Decide before M3. Qwen (Apache-2.0) has no such constraint.
- **R-M0-2 (Medium, Qwen size)**: only int8 ~1.6 GB ready → exceeds the ~1.2 GB soft cap. Mitigation: accept larger storage for the challenger, or evaluate an int4 conversion later (not phase-1 blocking).
- **R-M0-3 (Medium, on-device unverified)**: actual install/generation latency/RAM/quality on a 6GB device not yet measured → FU-1.

### Decision Gate Result
- **G0 (Gemma 3 1B)**: **PASS (desk)** — concrete compatible file (`gemma3-1b-it-int4.task`, ~529 MB, MediaPipe, arm64) confirmed; on-device spike pending (FU-1). Distribution gating tracked as R-M0-1.
- **G1 (Qwen2.5 1.5B)**: **PASS (conditional)** — ready `.task` exists (no conversion), Apache-2.0, arm64; **size caveat ~1.6 GB int8**. Included as benchmark challenger; final inclusion confirmed at M5/M7.
- **Recommendation**: ✅ **Proceed to M1** (catalog + model-state persistence). M1 is desk/code work that does not depend on the on-device spike; schedule FU-1 (device spike) before M6 chat integration and FU-2 (Gemma hosting decision) before M3 download.

### POC_DEMO_REAL_CHAT note (2026-06-29) — demo download uses public Qwen, FU-2 still open
For the immediate real demo, the **public, ungated** Qwen2.5 1.5B `.task` is used as the demo-downloadable model:
`https://huggingface.co/litert-community/Qwen2.5-1.5B-Instruct/resolve/main/Qwen2.5-1.5B-Instruct_seq128_q8_ekv1280.task` (~1.57 GB, Apache-2.0, verified ungated). This **does not close FU-2** — Gemma gated distribution and final production URL/SHA256/access strategy remain unresolved; the demo simply routes around Gemma. SHA256 is intentionally skipped in demo mode (`allowUnverifiedInstall`) and must be restored for production.

### FU-2 Outcome (recorded 2026-06-29, during M3) — UNRESOLVED, documented, real download BLOCKED
- **Status**: **Unresolved / blocked** — pending a product+legal decision on Gemma distribution. Not resolvable in the implementation environment (no bucket/CDN/token; secrets must not be committed).
- **Decision needed** (pick one): (a) **self-host/mirror** the Gemma `.task` under Gemma Terms on our CDN/bucket; (b) **backend token/proxy** that injects an HF token server-side; (c) another approved access path. Qwen2.5 (Apache-2.0) is **not** gated and can be hosted/downloaded freely once a URL is published.
- **Consequence**: **Real production model download remains BLOCKED until FU-2 is closed.** Catalog `downloadUrl`/`sha256` stay `null`; `ModelManager.downloadSelectedModel` returns `pendingDistribution` for both models (no bytes fetched). The full lifecycle (progress → checksum/version verify → installed → active) is implemented and unit-tested behind injectable abstractions (`ModelDownloader`/`ChecksumVerifier`/`ModelFilePathResolver`/`DeviceCapabilityProbe`); the registered defaults are `Noop`/`Pending`/`Permissive`.
- **To close FU-2**: publish final URL + capture SHA256 → populate the two catalog entries → register real `ModelDownloader` (flutter_gemma install manager / background_downloader) + real `ChecksumVerifier` + `ModelFilePathResolver` (path_provider) + `DeviceCapabilityProbe`. No `ModelManager` logic change required.

### M6-B0 Spike Preparation (recorded 2026-06-29) — PREPARED, DEVICE VALIDATION PENDING
- **Dependency status**: `flutter_gemma` was added for the spike and pinned to **0.12.6** because the current local SDK is Flutter **3.38.3** / Dart **3.10.1**. The latest `flutter_gemma` 1.1.x line requires Flutter >=3.44 / Dart >=3.12 and is therefore a later SDK-upgrade decision before production M6-B wiring.
- **Production binding**: unchanged. `LocalSlmService` is still registered as `UnavailableLocalSlmService`; normal AI Assistant entry and chat do not run real inference.
- **Spike adapter**: `FlutterGemmaLocalSlmService` exists as an isolated, developer-only adapter implementing `LocalSlmService`. It supports only local file installation via `installModel(...).fromFile(...)`, opens a chat via `createModel(...).createChat(...)`, and produces free-text through `generateChatResponse` / `generateChatResponseAsync`.
- **Download posture**: no production URL, no SHA256, and no Gemma gated-access resolution are available. Therefore production download remains blocked and the spike must use a local developer-provided model file path only.
- **Validation status**: real model generation was **not** tested in this environment because no physical Android 6GB arm64 device and no local model binary are available here. FU-1 remains open until a device run records load, chat/session creation, Arabic/English output, latency, memory, and crash/OOM status.

### Follow-up tasks before deeper milestones
- **FU-1 (before full M6-B)**: On-device spike on a real 6GB arm64 Android device — install `gemma3-1b-it-int4.task` via `flutter_gemma`, create/open chat, confirm one Arabic + one English prompt return coherent free-text; record latency/RAM/crash/OOM. M6-B0 prepared the adapter and checklist, but the device run is still pending.
- **FU-2 (before M3 download)**: Resolve Gemma distribution — self-host/mirror the gated `.task` (under Gemma Terms) or set up token-based fetch. Confirm final download URL + SHA256 for the catalog.
- **FU-3 (M5/M7)**: Decide whether Qwen int8 ~1.6 GB is acceptable or pursue an int4 build.

---

## Open research items carried into planning (non-blocking)

- Arabic dialect depth (MSA sufficient vs dialect) — affects Golden Set wording (Spec Open Q1).
- Model license confirmation (Gemma Terms / Apache-2.0 Qwen) — legal sign-off before any release.
- Exact CPU vs GPU backend choice on target SoCs — decided empirically in M5 benchmark.

## References
- flutter_gemma (pub.dev): https://pub.dev/packages/flutter_gemma
- flutter_gemma model list & formats: https://fluttergemma.dev/
- flutter_gemma API docs: https://pub.dev/documentation/flutter_gemma/latest/
- **Gemma 3 1B LiteRT/MediaPipe files (gated)**: https://huggingface.co/litert-community/Gemma3-1B-IT
- **Qwen2.5 1.5B Instruct LiteRT/MediaPipe files (Apache-2.0)**: https://huggingface.co/litert-community/Qwen2.5-1.5B-Instruct
- Gemma 3 on mobile/web with Google AI Edge: https://developers.googleblog.com/gemma-3-on-mobile-and-web-with-google-ai-edge/
- Gemma 3 QAT sizes: https://developers.googleblog.com/en/gemma-3-quantized-aware-trained-state-of-the-art-ai-to-consumer-gpus/
