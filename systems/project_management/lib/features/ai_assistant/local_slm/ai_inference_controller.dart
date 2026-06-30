import 'package:flutter/services.dart';
import 'package:project_management/features/ai_assistant/local_slm/active_model_store.dart';
import 'package:project_management/features/ai_assistant/local_slm/ai_log.dart';
import 'package:project_management/features/ai_assistant/local_slm/local_slm_service.dart';
import 'package:project_management/features/ai_assistant/local_slm/metadata_loader.dart';
import 'package:project_management/features/ai_assistant/local_slm/model_catalog.dart';
import 'package:project_management/features/ai_assistant/local_slm/model_installation_state.dart';
import 'package:project_management/features/ai_assistant/local_slm/model_manager.dart';
import 'package:project_management/features/ai_assistant/local_slm/poc_metrics.dart';
import 'package:project_management/features/ai_assistant/local_slm/prompt_builder.dart';
import 'package:project_management/features/ai_assistant/m0_probe/m0_intent_prompt.dart';
import 'package:project_management/features/ai_assistant/m0_probe/m0_probe_log.dart';

/// Outcome of an [AiInferenceController.generate] call. Free-text only.
sealed class AiInferenceResult {
  const AiInferenceResult();
}

/// Successful free-text generation.
class FreeTextResponse extends AiInferenceResult {
  const FreeTextResponse({required this.modelId, required this.text});
  final String modelId;
  final String text;
}

/// No model has been selected/activated yet → route user to Model Selection.
class NoActiveModel extends AiInferenceResult {
  const NoActiveModel();
}

/// Active model is not installed → user must download it (no auto-download here).
class ModelNotInstalled extends AiInferenceResult {
  const ModelNotInstalled(this.modelId);
  final String modelId;
}

/// Active model file is corrupt / version-mismatched → offer repair/redownload.
class ModelCorrupt extends AiInferenceResult {
  const ModelCorrupt(this.modelId);
  final String modelId;
}

/// Model could not be loaded into memory (engine not wired / load error).
class ModelLoadFailed extends AiInferenceResult {
  const ModelLoadFailed(this.modelId, this.message);
  final String modelId;
  final String message;
}

/// Generation raised an unexpected error.
class GenerationFailed extends AiInferenceResult {
  const GenerationFailed(this.message);
  final String message;
}

/// Generation was cancelled by the user.
class GenerationCancelled extends AiInferenceResult {
  const GenerationCancelled();
}

/// Generation exceeded its timeout.
class GenerationTimeout extends AiInferenceResult {
  const GenerationTimeout();
}

/// Orchestrates a single free-text inference request against the **active**
/// local model. Phase-1 scope:
/// - Never downloads (only reads/validates state via [ModelManager]).
/// - Never navigates / triggers model selection.
/// - Never persists chat history.
/// - Never calls Intent JSON / backend / MCP.
class AiInferenceController {
  AiInferenceController({
    required this.activeModelStore,
    required this.modelManager,
    required this.localSlm,
    required this.metrics,
    PromptBuilder? promptBuilder,
    MetadataLoader? metadataLoader,
    String? systemInstruction,
  }) : promptBuilder = promptBuilder ?? const PromptBuilder(),
       metadataLoader = metadataLoader ?? const MetadataLoader(),
       _systemInstruction = systemInstruction;

  final ActiveModelStore activeModelStore;
  final ModelManager modelManager;
  final LocalSlmService localSlm;
  final PocMetrics metrics;
  final PromptBuilder promptBuilder;
  final MetadataLoader metadataLoader;
  final String? _systemInstruction;

  // The asset lives in the `project_management` package, so in a host app it is
  // bundled under the `packages/<name>/` prefix. We try the package-prefixed
  // path first, then the bare path (works when this package is the app/test
  // root), then fall back to an embedded string so chat never hard-fails.
  static const List<String> _systemInstructionAssetPaths = [
    'packages/project_management/assets/ai/prompts/system_instruction.txt',
    'assets/ai/prompts/system_instruction.txt',
  ];

  static const String _fallbackSystemInstruction =
      'You are a local, phase-1 AI assistant. Answer in the user\'s language '
      '(Arabic, English, or mixed). Be concise and helpful. Use only the user '
      'message and any provided safe context; do not invent live system data. '
      'If you do not have enough information, say so. Responses are generated '
      'locally as free text and are not live system results.';

  /// Generates a free-text response for [userText] using the active model.
  /// Returns a typed [AiInferenceResult]; never throws for expected states.
  /// Logs an organized start/response block (question + response/status).
  ///
  /// M0-only (dev): when [useIntentJsonProbe] is `true`, the active model is
  /// prompted with the fixed Intent JSON template (depth [intentProbeDepth])
  /// instead of the normal free-text prompt, and `[AI_INTENT_PROBE]` logs are
  /// emitted. Defaults keep the exact feature-001 behavior. This does NOT parse,
  /// validate, or repair the output and never marks G-M0 passed.
  Future<AiInferenceResult> generate(
    String userText, {
    int maxTokens = 256,
    Duration? timeout,
    bool useIntentJsonProbe = false,
    int intentProbeDepth = 2,
  }) async {
    final sw = Stopwatch()..start();
    aiLog('╔══════════════ AI CHAT ══════════════');
    aiLog('║ Question : ${userText.trim()}');
    aiLog(
      '║ lang=${_detectLang(userText)} '
      'model=${activeModelStore.activeModelId}',
    );
    if (useIntentJsonProbe) {
      aiLog('║ MODE     : INTENT JSON PROBE (depth=$intentProbeDepth)');
    }
    final result = await _runGenerate(
      userText,
      maxTokens: maxTokens,
      timeout: timeout,
      useIntentJsonProbe: useIntentJsonProbe,
      intentProbeDepth: intentProbeDepth,
    );
    sw.stop();
    switch (result) {
      case FreeTextResponse(:final text):
        aiLog('║ Status   : ✅ SUCCESS (${sw.elapsedMilliseconds} ms)');
        aiLog('║ Response : $text');
      case NoActiveModel():
        aiLog('║ Status   : ⛔ NO ACTIVE MODEL (choose/download a model)');
      case ModelNotInstalled(:final modelId):
        aiLog('║ Status   : ⛔ MODEL NOT INSTALLED ($modelId)');
      case ModelCorrupt(:final modelId):
        aiLog('║ Status   : ⛔ MODEL CORRUPT ($modelId) — repair/redownload');
      case ModelLoadFailed(:final modelId, :final message):
        aiLog('║ Status   : ❌ LOAD FAILED ($modelId)');
        aiLog('║ Error    : $message');
      case GenerationFailed(:final message):
        aiLog('║ Status   : ❌ GENERATION FAILED');
        aiLog('║ Error    : $message');
      case GenerationCancelled():
        aiLog('║ Status   : ⏹ CANCELLED');
      case GenerationTimeout():
        aiLog('║ Status   : ⏱ TIMEOUT');
    }
    aiLog('╚═════════════════════════════════════');
    return result;
  }

  Future<AiInferenceResult> _runGenerate(
    String userText, {
    int maxTokens = 256,
    Duration? timeout,
    bool useIntentJsonProbe = false,
    int intentProbeDepth = 2,
  }) async {
    final modelId = activeModelStore.activeModelId;
    if (modelId == null) return const NoActiveModel();

    // Validate installation/version/checksum (may flip to corrupt). No download.
    if (activeModelStore.statusOf(modelId) == ModelInstallationState.corrupt) {
      return ModelCorrupt(modelId);
    }
    final valid = await modelManager.isInstalledAndValid(modelId);
    if (!valid) {
      if (activeModelStore.statusOf(modelId) ==
          ModelInstallationState.corrupt) {
        return ModelCorrupt(modelId);
      }
      return ModelNotInstalled(modelId);
    }

    final record = activeModelStore.recordOf(modelId);
    final entry = modelManager.catalog.byId(modelId);
    final String? prompt;
    if (useIntentJsonProbe) {
      // M0 probe: assemble the fixed Intent JSON prompt from assets. No normal
      // 001 prompt is built in this branch.
      try {
        prompt = await M0IntentPrompt.build(
          question: userText,
          depth: intentProbeDepth,
        );
      } catch (e) {
        return GenerationFailed('M0 intent prompt assembly failed: $e');
      }
      intentProbeLog(
        'variant=depth-$intentProbeDepth '
        'question_len=${userText.trim().length} prompt_len=${prompt.length}',
      );
    } else {
      prompt = await _buildPrompt(userText: userText, activeModel: entry);
    }
    if (prompt == null) {
      return const GenerationFailed(
        'Prompt build failed safely before local generation.',
      );
    }

    final stopwatch = Stopwatch()..start();
    try {
      // Load if needed (engine not wired yet → ModelLoadFailed). No download.
      if (!localSlm.isReady) {
        try {
          await localSlm.load(modelId, modelFilePath: record?.localPath ?? '');
        } on LocalSlmUnavailable catch (e) {
          return ModelLoadFailed(modelId, e.reason);
        } catch (e) {
          return ModelLoadFailed(modelId, e.toString());
        }
      }

      // Generate free-text from the final prompt, never from raw user text.
      final text = await localSlm.generateText(
        prompt,
        maxTokens: maxTokens,
        timeout: timeout,
      );
      stopwatch.stop();
      if (useIntentJsonProbe) {
        intentProbeLog('latency=${stopwatch.elapsedMilliseconds}ms');
        intentProbeLog('raw_output=$text');
      }
      metrics.record(
        PocMetric(
          modelId: modelId,
          lang: _detectLang(userText),
          latencyFullMs: stopwatch.elapsedMilliseconds,
        ),
      );
      return FreeTextResponse(modelId: modelId, text: text);
    } on LocalSlmCancelled {
      return const GenerationCancelled();
    } on LocalSlmTimeout {
      return const GenerationTimeout();
    } on LocalSlmUnavailable catch (e) {
      return GenerationFailed(e.reason);
    } catch (e) {
      return GenerationFailed(e.toString());
    }
  }

  Future<String?> _buildPrompt({
    required String userText,
    required ModelCatalogEntry? activeModel,
  }) async {
    try {
      final systemInstruction = await _loadSystemInstruction();
      MetadataBundle? metadata;
      try {
        metadata = await metadataLoader.load();
      } catch (_) {
        // Metadata is optional context; never fail the prompt because of it.
        metadata = null;
      }
      return promptBuilder.build(
        systemInstruction: systemInstruction,
        metadata: metadata,
        userText: userText,
        activeModel: activeModel,
      );
    } catch (e) {
      aiLog('promptBuilder error: $e');
      return null;
    }
  }

  /// Loads the system instruction, tolerating package-asset path differences;
  /// falls back to an embedded string so a missing asset never blocks chat.
  Future<String> _loadSystemInstruction() async {
    if (_systemInstruction != null) return _systemInstruction;
    for (final path in _systemInstructionAssetPaths) {
      try {
        return await rootBundle.loadString(path);
      } catch (_) {
        // try next candidate
      }
    }
    aiLog('system_instruction asset not found → using embedded fallback');
    return _fallbackSystemInstruction;
  }

  /// Cancels an in-flight generation (delegates to the service).
  Future<void> cancel() => localSlm.cancel();

  /// Lightweight language hint for metrics (Arabic block → 'ar', else 'en',
  /// both → 'mixed'). Not used to alter behavior in phase 1.
  String _detectLang(String text) {
    final hasArabic = RegExp(r'[؀-ۿ]').hasMatch(text);
    final hasLatin = RegExp(r'[A-Za-z]').hasMatch(text);
    if (hasArabic && hasLatin) return 'mixed';
    if (hasArabic) return 'ar';
    return 'en';
  }
}
