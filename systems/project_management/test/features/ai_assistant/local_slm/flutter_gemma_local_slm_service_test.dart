import 'package:flutter_gemma/flutter_gemma.dart' as gemma;
import 'package:flutter_test/flutter_test.dart';
import 'package:project_management/features/ai_assistant/local_slm/flutter_gemma_local_slm_service.dart';
import 'package:project_management/features/ai_assistant/local_slm/local_slm_service.dart';

void main() {
  group('FlutterGemmaLocalSlmService spike adapter', () {
    test('rejects missing local model path before calling backend', () async {
      final backend = _FakeGemmaBackend();
      final service = FlutterGemmaLocalSlmService(backend: backend);

      await expectLater(
        service.load('gemma_3_1b', modelFilePath: ''),
        throwsA(isA<LocalSlmUnavailable>()),
      );

      expect(backend.initializeCalls, 0);
      expect(backend.installPaths, isEmpty);
    });

    test('rejects unsupported model file extension', () async {
      final backend = _FakeGemmaBackend();
      final service = FlutterGemmaLocalSlmService(backend: backend);

      await expectLater(
        service.load('gemma_3_1b', modelFilePath: '/tmp/model.txt'),
        throwsA(isA<LocalSlmUnavailable>()),
      );

      expect(backend.initializeCalls, 0);
      expect(backend.installPaths, isEmpty);
    });

    test('loads local task file and generates free text', () async {
      final backend = _FakeGemmaBackend(reply: 'Hello from Gemma');
      final service = FlutterGemmaLocalSlmService(backend: backend);

      await service.load(
        'gemma_3_1b',
        modelFilePath: '/sdcard/Download/gemma3-1b-it-int4.task',
      );
      final response = await service.generateText('Hello');

      expect(service.isReady, isTrue);
      expect(response, 'Hello from Gemma');
      expect(backend.initializeCalls, 1);
      expect(backend.installPaths.single, contains('gemma3-1b-it-int4.task'));
      expect(backend.modelTypes.single, gemma.ModelType.gemmaIt);
      expect(backend.fileTypes.single, gemma.ModelFileType.task);
      expect(backend.session.messages.single, 'Hello');
    });

    test('maps Qwen catalog id to Qwen model type', () async {
      final backend = _FakeGemmaBackend();
      final service = FlutterGemmaLocalSlmService(backend: backend);

      await service.load(
        'qwen_2_5_1_5b',
        modelFilePath: '/sdcard/Download/qwen.task',
      );

      expect(backend.modelTypes, contains(gemma.ModelType.qwen));
    });

    test('maps generation timeout to LocalSlmTimeout', () async {
      final backend = _FakeGemmaBackend(
        textDelay: const Duration(milliseconds: 50),
      );
      final service = FlutterGemmaLocalSlmService(backend: backend);

      await service.load('gemma_3_1b', modelFilePath: '/tmp/model.task');

      await expectLater(
        service.generateText('slow', timeout: const Duration(milliseconds: 1)),
        throwsA(isA<LocalSlmTimeout>()),
      );
    });

    test('cancel delegates to the active spike session', () async {
      final backend = _FakeGemmaBackend();
      final service = FlutterGemmaLocalSlmService(backend: backend);

      await service.load('gemma_3_1b', modelFilePath: '/tmp/model.task');
      await service.cancel();

      expect(backend.session.cancelCalls, 1);
    });

    test('dispose closes session and marks service not ready', () async {
      final backend = _FakeGemmaBackend();
      final service = FlutterGemmaLocalSlmService(backend: backend);

      await service.load('gemma_3_1b', modelFilePath: '/tmp/model.task');
      await service.dispose();

      expect(service.isReady, isFalse);
      expect(backend.session.closeCalls, 1);
    });
  });
}

class _FakeGemmaBackend implements FlutterGemmaSpikeBackend {
  _FakeGemmaBackend({this.reply = 'ok', this.textDelay = Duration.zero})
    : session = _FakeGemmaSession(reply: reply, textDelay: textDelay);

  final String reply;
  final Duration textDelay;
  final _FakeGemmaSession session;
  int initializeCalls = 0;
  final installPaths = <String>[];
  final modelTypes = <gemma.ModelType>[];
  final fileTypes = <gemma.ModelFileType>[];

  @override
  Future<void> initialize() async {
    initializeCalls += 1;
  }

  @override
  Future<void> installFromFile(
    String path, {
    required gemma.ModelType modelType,
    required gemma.ModelFileType fileType,
  }) async {
    installPaths.add(path);
    modelTypes.add(modelType);
    fileTypes.add(fileType);
  }

  @override
  Future<FlutterGemmaSpikeSession> openChat({
    required int maxTokens,
    required gemma.ModelType modelType,
    required gemma.ModelFileType fileType,
    gemma.PreferredBackend? preferredBackend,
    String? systemInstruction,
  }) async {
    return session;
  }
}

class _FakeGemmaSession implements FlutterGemmaSpikeSession {
  _FakeGemmaSession({required this.reply, required this.textDelay});

  final String reply;
  final Duration textDelay;
  final messages = <String>[];
  int cancelCalls = 0;
  int closeCalls = 0;

  @override
  Future<void> addUserMessage(String text) async {
    messages.add(text);
  }

  @override
  Stream<String> generate() async* {
    yield reply;
  }

  @override
  Future<String> generateText() async {
    if (textDelay > Duration.zero) await Future<void>.delayed(textDelay);
    return reply;
  }

  @override
  Future<void> cancel() async {
    cancelCalls += 1;
  }

  @override
  Future<void> close() async {
    closeCalls += 1;
  }
}
