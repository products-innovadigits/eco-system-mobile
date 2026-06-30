import 'package:flutter/foundation.dart';

/// Debug-only logger for the M0 Intent JSON probe.
///
/// Greppable `[AI_INTENT_PROBE]` prefix. No-ops in release builds. It is only
/// ever called from the probe branch of the chat send flow (when
/// `AiAssistantDevConfig.useIntentJsonProbe == true`), so normal chat emits none
/// of these logs.
void intentProbeLog(String message) {
  if (kReleaseMode) return; // diagnostics only — never in release
  debugPrint('[AI_INTENT_PROBE] $message');
}
