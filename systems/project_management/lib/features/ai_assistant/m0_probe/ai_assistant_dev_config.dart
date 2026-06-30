/// Code-level dev switches for the **M0 Intent JSON probe**, driven through the
/// normal AI Assistant chat send flow (no `--dart-define`, no separate screen).
///
/// Toggle these in source when running M0 measurement, then revert:
/// - [useIntentJsonProbe] = `true`  → the next chat send assembles the fixed
///   Intent JSON prompt internally and logs the raw output as an Intent JSON
///   attempt. `false` → normal feature-001 free-text chat, completely unchanged.
/// - [intentProbeDepth] = `2` (depth-2 slice) or `1` (depth-1 fallback).
///
/// This is M0 measurement support only — NOT the Intent pipeline. It does not
/// parse/validate/repair the output and never marks G-M0 passed.
class AiAssistantDevConfig {
  const AiAssistantDevConfig._();

  /// Default `false` → normal 001 chat behavior.
  static const bool useIntentJsonProbe = false;

  /// `2` = depth-2 schema slice, `1` = depth-1 fallback slice.
  static const int intentProbeDepth = 2;
}
