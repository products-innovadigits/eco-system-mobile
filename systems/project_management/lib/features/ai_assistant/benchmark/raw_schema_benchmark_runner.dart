import 'package:project_management/core/di/project_management_locator.dart';
import 'package:project_management/features/ai_assistant/benchmark/benchmark_prompt_builder.dart';
import 'package:project_management/features/ai_assistant/benchmark/benchmark_questions.dart';
import 'package:project_management/features/ai_assistant/benchmark/benchmark_result_record.dart';
import 'package:project_management/features/ai_assistant/benchmark/compact_schema_loader.dart';
import 'package:project_management/features/ai_assistant/local_slm/active_model_store.dart';
import 'package:project_management/features/ai_assistant/local_slm/local_slm_service.dart';

typedef CompactSchemaLoader = Future<String> Function();

class RawSchemaBenchmarkRunner {
  RawSchemaBenchmarkRunner({
    LocalSlmService? localSlm,
    ActiveModelStore? activeModelStore,
    CompactSchemaLoader compactSchemaLoader = loadCompactSchema,
    this.maxTokens = 1280,
    this.timeout = const Duration(minutes: 1),
  }) : _localSlm = localSlm ?? projectManagementSl<LocalSlmService>(),
       _activeModelStore = activeModelStore,
       _compactSchemaLoader = compactSchemaLoader;

  final LocalSlmService _localSlm;

  /// Optional injected seam. When null, resolved lazily from DI only if a model
  /// actually needs loading (keeps inference-free tests off the DI container).
  final ActiveModelStore? _activeModelStore;
  final CompactSchemaLoader _compactSchemaLoader;
  final int maxTokens;
  final Duration? timeout;

  Future<BenchmarkResultRecord> run(BenchmarkQuestion question) async {
    final compactSchema = await _compactSchemaLoader();
    final prompt = buildBenchmarkPrompt(
      compactSchema: compactSchema,
      question: question.text,
    );

    // Ensure a model is loaded before touching the session. The benchmark
    // bypasses AiInferenceController, which is what normally lazy-loads the
    // model on first use, so replicate its load convention here.
    if (!_localSlm.isReady) {
      final store =
          _activeModelStore ?? projectManagementSl<ActiveModelStore>();
      final modelId = store.activeModelId;
      if (modelId == null) {
        throw const LocalSlmUnavailable('No active local model selected.');
      }
      final record = store.recordOf(modelId);
      await _localSlm.load(modelId, modelFilePath: record?.localPath ?? '');
    }

    // Fresh one-shot context per question: clear any prior chat history so
    // earlier benchmark questions cannot bleed into this one.
    await _localSlm.resetSession();

    final stopwatch = Stopwatch()..start();
    final rawOutput = await _localSlm.generateText(
      prompt,
      maxTokens: maxTokens,
      timeout: timeout,
    );
    stopwatch.stop();

    return BenchmarkResultRecord(
      questionId: question.id,
      questionText: question.text,
      schemaCharCount: compactSchema.length,
      promptCharCount: prompt.length,
      estimatedTokens: _estimateTokens(prompt.length),
      rawOutput: rawOutput,
      latencyMs: stopwatch.elapsedMilliseconds,
    );
  }

  int _estimateTokens(int charCount) => (charCount / 4).ceil();
}
