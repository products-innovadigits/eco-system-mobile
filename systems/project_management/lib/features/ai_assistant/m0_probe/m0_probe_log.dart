import 'package:flutter/foundation.dart';
import 'package:project_management/features/ai_assistant/m0_probe/m0_probe_flags.dart';

/// Debug/POC-only logger for the M0 probe harness.
///
/// Prints with a consistent, greppable `[AI_M0_PROBE]` prefix. No-ops in release
/// builds and when the M0 probe flag is off, so it never affects production.
void m0Log(String message) {
  if (kReleaseMode) return; // never log in release
  if (!kM0ProbeEnabled) return; // only when the M0 probe build flag is on
  debugPrint('[AI_M0_PROBE] $message');
}
