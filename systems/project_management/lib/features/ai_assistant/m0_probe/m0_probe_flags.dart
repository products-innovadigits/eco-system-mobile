/// Dev/POC-only flag that exposes the **M0 measurement probe harness**.
///
/// This harness exists ONLY to run the M0 measurement (T007/T008) on a real
/// device (Samsung Galaxy S22 Ultra) using the existing feature-001
/// `LocalSlmService`. It is NOT the Intent pipeline and does NOT implement
/// SchemaGraph/loader/trimmer/parser/validator/repair/IntentService.
///
/// Enable for a measurement build with:
///   flutter run --dart-define=AI_M0_PROBE=true
///
/// Default is `false`, so the probe entry is invisible and the normal AI
/// Assistant behavior is completely unchanged.
const bool kM0ProbeEnabled =
    bool.fromEnvironment('AI_M0_PROBE', defaultValue: false);
