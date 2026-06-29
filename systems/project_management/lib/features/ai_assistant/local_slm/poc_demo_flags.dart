/// POC_DEMO_REAL_CHAT — temporary demo switch.
///
/// When true, the AI Assistant local-SLM path is wired for a **real**
/// end-to-end demo: a public model is downloadable, `flutter_gemma` performs
/// real on-device inference, and SHA256 verification is relaxed.
///
/// ⚠️ This is a DEMO path, NOT production. Flip to `false` (or delete this file
/// and its references) to restore the production-gated behavior.
///
/// TODO(prod-hardening): before production, restore:
///  - mandatory SHA256 validation (ModelManager.allowUnverifiedInstall = false),
///  - resolved Gemma gated distribution / final model URL + access strategy,
///  - durable ModelStateStore (replace InMemoryModelStateStore),
///  - Android 6GB device validation (FU-1),
///  - production download error handling / repair-redownload.
const bool kPocDemoRealChat = true;
