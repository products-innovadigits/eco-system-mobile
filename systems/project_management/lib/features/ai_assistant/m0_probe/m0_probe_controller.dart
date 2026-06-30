import 'package:flutter/services.dart' show rootBundle;
import 'package:project_management/features/ai_assistant/local_slm/active_model_store.dart';
import 'package:project_management/features/ai_assistant/local_slm/local_slm_service.dart';
import 'package:project_management/features/ai_assistant/m0_probe/m0_probe_log.dart';

/// Which fixed prompt template the harness assembles around the user question.
enum M0PromptVariant { depth2, depth1 }

extension M0PromptVariantLabel on M0PromptVariant {
  String get label => this == M0PromptVariant.depth2 ? 'depth-2' : 'depth-1';
}

/// Result of one M0 probe run. Pure data — no pass/fail judgement is made here.
class M0ProbeResult {
  const M0ProbeResult({
    required this.variant,
    required this.promptChars,
    required this.approxPromptTokens,
    this.rawOutput,
    this.latencyMs,
    this.error,
  });

  final M0PromptVariant variant;
  final int promptChars;
  final int approxPromptTokens;
  final String? rawOutput;
  final int? latencyMs;
  final String? error;

  bool get ok => error == null && rawOutput != null;
}

/// Dev-only M0 measurement harness controller.
///
/// Responsibilities (M0 measurement ONLY):
/// 1. load a fixed prompt template asset for the chosen variant,
/// 2. inject the typed question into the `{{USER_QUESTION}}` placeholder,
/// 3. call the existing [LocalSlmService.generateText] (no new runtime),
/// 4. measure latency and return the raw output.
///
/// It does NOT parse, validate, repair, or score the output, and it never marks
/// G-M0 passed. It reuses the active model selected via feature 001.
class M0ProbeController {
  M0ProbeController({
    required this.localSlm,
    required this.activeModelStore,
  });

  final LocalSlmService localSlm;
  final ActiveModelStore activeModelStore;

  // Asset may be bundled under the package prefix (host app) or bare (tests).
  static const List<String> _depth2Paths = [
    'packages/project_management/assets/ai/prompts/m0_strict_json_depth_2.txt',
    'assets/ai/prompts/m0_strict_json_depth_2.txt',
  ];
  static const List<String> _depth1Paths = [
    'packages/project_management/assets/ai/prompts/m0_strict_json_depth_1.txt',
    'assets/ai/prompts/m0_strict_json_depth_1.txt',
  ];

  static const String _placeholder = '{{USER_QUESTION}}';

  Future<String> _loadTemplate(M0PromptVariant variant) async {
    final paths =
        variant == M0PromptVariant.depth2 ? _depth2Paths : _depth1Paths;
    for (final p in paths) {
      try {
        return await rootBundle.loadString(p);
      } catch (_) {
        // try next candidate path
      }
    }
    throw StateError('M0 prompt template asset not found for ${variant.label}');
  }

  /// Runs one probe: assembles the prompt internally and calls the local model.
  /// The caller (tester) only ever supplies the natural-language [question].
  Future<M0ProbeResult> run({
    required String question,
    required M0PromptVariant variant,
    int maxTokens = 512,
    Duration timeout = const Duration(seconds: 60),
  }) async {
    final q = question.trim();
    m0Log('selected prompt variant: ${variant.label}');
    m0Log('question length: ${q.length}');

    if (q.isEmpty) {
      return M0ProbeResult(
        variant: variant,
        promptChars: 0,
        approxPromptTokens: 0,
        error: 'Empty question — type a natural-language question first.',
      );
    }

    final String prompt;
    try {
      final template = await _loadTemplate(variant);
      prompt = template.replaceAll(_placeholder, q);
    } catch (e) {
      m0Log('error/timeout: template load failed: $e');
      return M0ProbeResult(
        variant: variant,
        promptChars: 0,
        approxPromptTokens: 0,
        error: 'Prompt template load failed: $e',
      );
    }

    final chars = prompt.length;
    final approxTokens = (chars * 10 / 35).round(); // ~3.5 chars/token heuristic
    m0Log('prompt length estimate: $chars chars (~$approxTokens tokens)');

    final modelId = activeModelStore.activeModelId;
    if (modelId == null) {
      return M0ProbeResult(
        variant: variant,
        promptChars: chars,
        approxPromptTokens: approxTokens,
        error: 'No active model. Select Qwen2.5 1.5B in the AI Assistant first.',
      );
    }

    final sw = Stopwatch()..start();
    try {
      if (!localSlm.isReady) {
        final record = activeModelStore.recordOf(modelId);
        await localSlm.load(modelId, modelFilePath: record?.localPath ?? '');
      }
      m0Log('generation started (model=$modelId)');
      final out = await localSlm.generateText(
        prompt,
        maxTokens: maxTokens,
        timeout: timeout,
      );
      sw.stop();
      m0Log('generation finished');
      m0Log('latency: ${sw.elapsedMilliseconds} ms');
      return M0ProbeResult(
        variant: variant,
        promptChars: chars,
        approxPromptTokens: approxTokens,
        rawOutput: out,
        latencyMs: sw.elapsedMilliseconds,
      );
    } on LocalSlmTimeout {
      sw.stop();
      m0Log('error/timeout: timeout after ${sw.elapsedMilliseconds} ms');
      return M0ProbeResult(
        variant: variant,
        promptChars: chars,
        approxPromptTokens: approxTokens,
        latencyMs: sw.elapsedMilliseconds,
        error: 'Timeout after ${sw.elapsedMilliseconds} ms',
      );
    } on LocalSlmCancelled {
      sw.stop();
      m0Log('error/timeout: cancelled');
      return M0ProbeResult(
        variant: variant,
        promptChars: chars,
        approxPromptTokens: approxTokens,
        latencyMs: sw.elapsedMilliseconds,
        error: 'Generation cancelled',
      );
    } on LocalSlmUnavailable catch (e) {
      sw.stop();
      m0Log('error/timeout: ${e.reason}');
      return M0ProbeResult(
        variant: variant,
        promptChars: chars,
        approxPromptTokens: approxTokens,
        latencyMs: sw.elapsedMilliseconds,
        error: 'Local model unavailable: ${e.reason}',
      );
    } catch (e) {
      sw.stop();
      m0Log('error/timeout: $e');
      return M0ProbeResult(
        variant: variant,
        promptChars: chars,
        approxPromptTokens: approxTokens,
        latencyMs: sw.elapsedMilliseconds,
        error: '$e',
      );
    }
  }
}
