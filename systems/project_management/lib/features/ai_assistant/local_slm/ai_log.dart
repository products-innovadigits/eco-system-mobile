import 'package:flutter/foundation.dart';

/// Lightweight status logger for AI Assistant local-SLM actions.
///
/// Prints to the debug console (visible in `flutter run`) with a consistent
/// `[AiAssistant]` prefix so model-selection, download, and chat actions can be
/// traced — success or failure. No prompt/response *content* is logged (only
/// sizes/status) to avoid leaking text into logs.
void aiLog(String message) {
  if (kReleaseMode) return; // diagnostics only — never log in release builds
  debugPrint('[AiAssistant] $message');
}
