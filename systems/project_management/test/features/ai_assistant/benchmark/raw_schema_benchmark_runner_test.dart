import 'package:flutter_test/flutter_test.dart';
import 'package:project_management/features/ai_assistant/benchmark/benchmark_questions.dart';
import 'package:project_management/features/ai_assistant/benchmark/raw_schema_benchmark_runner.dart';
import 'package:project_management/features/ai_assistant/local_slm/active_model_store.dart';
import 'package:project_management/features/ai_assistant/local_slm/local_slm_service.dart';

void main() {
  group('RawSchemaBenchmarkRunner', () {
    const question = BenchmarkQuestion(
      id: 7,
      text: 'ما وصف اجتماع لجنة المتابعة',
    );

    test(
      'A: when already ready, skips load and resets before generating',
      () async {
        final localSlm = _FakeLocalSlmService(
          ready: true,
          rawOutput: 'raw benchmark output',
        );
        final runner = RawSchemaBenchmarkRunner(
          localSlm: localSlm,
          activeModelStore: _storeWith(),
          compactSchemaLoader: () async => 'raw compact schema',
          maxTokens: 384,
          timeout: const Duration(seconds: 9),
        );

        final record = await runner.run(question);

        expect(localSlm.loadCallCount, 0);
        expect(localSlm.resetSessionCallCount, 1);
        expect(localSlm.generateTextCallCount, 1);
        expect(localSlm.callOrder, ['resetSession', 'generateText']);
        expect(localSlm.lastPrompt, contains('raw compact schema'));
        expect(localSlm.lastPrompt, contains(question.text));
        expect(localSlm.lastMaxTokens, 384);
        expect(localSlm.lastTimeout, const Duration(seconds: 9));
        expect(record.questionId, question.id);
        expect(record.questionText, question.text);
        expect(record.schemaCharCount, 'raw compact schema'.length);
        expect(record.promptCharCount, localSlm.lastPrompt!.length);
        expect(record.estimatedTokens, (record.promptCharCount / 4).ceil());
        expect(record.rawOutput, 'raw benchmark output');
        expect(record.latencyMs, greaterThanOrEqualTo(0));
      },
    );

    test(
      'B: when not ready, loads active model before reset and generate',
      () async {
        final localSlm = _FakeLocalSlmService(
          ready: false,
          rawOutput: 'raw benchmark output',
        );
        final store = _storeWith(
          activeId: 'qwen_2_5_1_5b',
          localPath: '/sdcard/Download/qwen.task',
        );
        final runner = RawSchemaBenchmarkRunner(
          localSlm: localSlm,
          activeModelStore: store,
          compactSchemaLoader: () async => 'raw compact schema',
        );

        final record = await runner.run(question);

        expect(localSlm.loadCallCount, 1);
        expect(localSlm.lastLoadModelId, 'qwen_2_5_1_5b');
        expect(localSlm.lastLoadModelFilePath, '/sdcard/Download/qwen.task');
        // load must precede reset, which must precede generation.
        expect(localSlm.callOrder, ['load', 'resetSession', 'generateText']);
        expect(localSlm.generateTextCallCount, 1);
        expect(localSlm.lastPrompt, contains('raw compact schema'));
        expect(localSlm.lastPrompt, contains(question.text));
        expect(record.rawOutput, 'raw benchmark output');
        // Default cancellation cap: generation is bounded to 1 minute.
        expect(localSlm.lastTimeout, const Duration(minutes: 1));
      },
    );

    test(
      'C: when not ready and no active model, throws and never generates',
      () async {
        final localSlm = _FakeLocalSlmService(
          ready: false,
          rawOutput: 'raw benchmark output',
        );
        final runner = RawSchemaBenchmarkRunner(
          localSlm: localSlm,
          activeModelStore: _storeWith(), // no active model
          compactSchemaLoader: () async => 'raw compact schema',
        );

        await expectLater(
          runner.run(question),
          throwsA(isA<LocalSlmUnavailable>()),
        );
        expect(localSlm.loadCallCount, 0);
        expect(localSlm.resetSessionCallCount, 0);
        expect(localSlm.generateTextCallCount, 0);
      },
    );
  });
}

ActiveModelStore _storeWith({String? activeId, String? localPath}) {
  final store = ActiveModelStore(store: InMemoryModelStateStore());
  if (activeId != null) {
    store.setActiveModel(activeId);
    store.markInstalled(
      id: activeId,
      version: '1',
      checksum: 'abc',
      localPath: localPath ?? '',
    );
  }
  return store;
}

class _FakeLocalSlmService implements LocalSlmService {
  _FakeLocalSlmService({required bool ready, required this.rawOutput})
    : _ready = ready;

  bool _ready;
  final String rawOutput;

  int loadCallCount = 0;
  int generateTextCallCount = 0;
  int resetSessionCallCount = 0;
  final List<String> callOrder = [];
  String? lastLoadModelId;
  String? lastLoadModelFilePath;
  String? lastPrompt;
  int? lastMaxTokens;
  Duration? lastTimeout;

  @override
  bool get isReady => _ready;

  @override
  Future<void> load(String modelId, {required String modelFilePath}) async {
    loadCallCount += 1;
    lastLoadModelId = modelId;
    lastLoadModelFilePath = modelFilePath;
    callOrder.add('load');
    _ready = true;
  }

  @override
  Future<void> resetSession() async {
    resetSessionCallCount += 1;
    callOrder.add('resetSession');
  }

  @override
  Stream<String> generate(
    String prompt, {
    int maxTokens = 256,
    Duration? timeout,
  }) async* {}

  @override
  Future<String> generateText(
    String prompt, {
    int maxTokens = 256,
    Duration? timeout,
  }) async {
    generateTextCallCount += 1;
    callOrder.add('generateText');
    lastPrompt = prompt;
    lastMaxTokens = maxTokens;
    lastTimeout = timeout;
    return rawOutput;
  }

  @override
  Future<void> cancel() async {}

  @override
  Future<void> dispose() async {}
}
