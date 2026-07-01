/// Code-level dev switches for the **M0 Intent JSON probe**, driven through the
/// normal AI Assistant chat send flow (no `--dart-define`, no separate screen).
///
/// Toggle these in source when running M0 measurement, then revert:
/// - [useIntentJsonProbe] = `true`  → the next chat send assembles the fixed
///   Intent JSON prompt internally (fresh, history-free one-shot) and logs the
///   raw output. `false` → normal feature-001 free-text chat, fully unchanged.
/// - [intentProbeDepth] = `0` (minimal, fits ~1024 ctx), `1` (depth-1 fallback),
///   or `2` (depth-2 slice).
///
/// IMPORTANT (Qwen2.5 1.5B, context = [intentProbeContextTokens] tokens):
/// depth-2 (~1226 tok) and depth-1 (~895 tok) do NOT fit the 1024 context once
/// output room is reserved. They will be rejected by the preflight guard with
/// `[AI_INTENT_PROBE] prompt_too_large` (a controlled Flutter error — the native
/// engine is never called, so it cannot SIGSEGV). Use **depth-0** to get an
/// actual generation on a 1024-context model.
///
/// Recommended order: start at depth-1 to confirm it is too large, then drop to
/// depth-0 for a fitting one-shot.
///
/// This is M0 measurement support only — NOT the Intent pipeline. It does not
/// parse/validate/repair the output and never marks G-M0 passed.
class AiAssistantDevConfig {
  const AiAssistantDevConfig._();

  /// Default `false` → normal 001 chat behavior. Set `true` to run the probe.
  static const bool useIntentJsonProbe = true;

  /// `0` = minimal (recommended for 1024-ctx), `1` = depth-1, `2` = depth-2.
  static const int intentProbeDepth = 0;

  /// Known usable context window of the active model build (tokens).
  static const int intentProbeContextTokens = 1024;

  /// Tokens reserved for the model's output so the prompt + output fit the
  /// context. Prompt budget = context - reserve.
  static const int intentProbeOutputReserveTokens = 256;

  /// Heuristic chars→tokens ratio for the preflight size estimate (mixed AR/EN).
  static const double intentProbeCharsPerToken = 3.5;
}
