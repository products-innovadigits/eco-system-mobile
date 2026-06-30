import 'package:flutter/services.dart' show rootBundle;

/// M0-only helper: loads the fixed Intent JSON prompt template for the chosen
/// depth and injects the user's question into `{{USER_QUESTION}}`.
///
/// Used exclusively by the probe branch of the chat send flow. It does NOT
/// parse/validate/repair anything — it only assembles the prompt string.
class M0IntentPrompt {
  const M0IntentPrompt._();

  static const String _placeholder = '{{USER_QUESTION}}';

  // Asset may be bundled under the package prefix (host app) or bare (tests).
  static const List<String> _depth2Paths = [
    'packages/project_management/assets/ai/prompts/m0_strict_json_depth_2.txt',
    'assets/ai/prompts/m0_strict_json_depth_2.txt',
  ];
  static const List<String> _depth1Paths = [
    'packages/project_management/assets/ai/prompts/m0_strict_json_depth_1.txt',
    'assets/ai/prompts/m0_strict_json_depth_1.txt',
  ];

  /// Returns the assembled prompt for [depth] (1 → depth-1 fallback, else
  /// depth-2) with [question] injected. Throws if no template asset is found.
  static Future<String> build({
    required String question,
    required int depth,
  }) async {
    final paths = depth == 1 ? _depth1Paths : _depth2Paths;
    String? template;
    for (final p in paths) {
      try {
        template = await rootBundle.loadString(p);
        break;
      } catch (_) {
        // try next candidate path
      }
    }
    if (template == null) {
      throw StateError('M0 intent prompt template not found (depth $depth)');
    }
    return template.replaceAll(_placeholder, question.trim());
  }
}
