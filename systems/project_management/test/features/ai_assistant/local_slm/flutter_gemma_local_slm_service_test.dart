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

    test('maps ekv4096 Qwen id to Qwen model type', () async {
      final backend = _FakeGemmaBackend();
      final service = FlutterGemmaLocalSlmService(backend: backend);

      await service.load(
        'qwen_2_5_1_5b_ekv4096',
        modelFilePath: '/sdcard/Download/qwen_ekv4096.task',
      );

      expect(backend.modelTypes, contains(gemma.ModelType.qwen));
    });

    test('opens chat with the model catalog context ceiling', () async {
      final backend = _FakeGemmaBackend();
      final service = FlutterGemmaLocalSlmService(backend: backend);

      await service.load(
        'qwen_2_5_1_5b',
        modelFilePath: '/sdcard/Download/qwen_ekv1280.task',
      );

      expect(backend.openChatMaxTokens.single, 1280);
    });

    test('ekv4096 model opens chat with 4096 max tokens', () async {
      final backend = _FakeGemmaBackend();
      final service = FlutterGemmaLocalSlmService(backend: backend);

      await service.load(
        'qwen_2_5_1_5b_ekv4096',
        modelFilePath: '/sdcard/Download/qwen_ekv4096.task',
      );

      expect(backend.openChatMaxTokens.single, 4096);
    });

    test('resetSession reopens the ekv4096 model at 4096 max tokens', () async {
      final backend = _FakeGemmaBackend();
      final service = FlutterGemmaLocalSlmService(backend: backend);

      await service.load(
        'qwen_2_5_1_5b_ekv4096',
        modelFilePath: '/sdcard/Download/qwen_ekv4096.task',
      );
      await service.resetSession();

      expect(backend.openChatMaxTokens, [4096, 4096]);
    });

    test('opens chat with the configured decoding temperature', () async {
      final backend = _FakeGemmaBackend();
      final service = FlutterGemmaLocalSlmService(
        backend: backend,
        config: const FlutterGemmaSpikeConfig(temperature: 0.2),
      );

      await service.load('gemma_3_1b', modelFilePath: '/tmp/model.task');

      expect(backend.openChatTemperatures.single, 0.2);
    });

    test('defaults to the configured decoding temperature', () async {
      final backend = _FakeGemmaBackend();
      final service = FlutterGemmaLocalSlmService(backend: backend);

      await service.load('gemma_3_1b', modelFilePath: '/tmp/model.task');

      expect(backend.openChatTemperatures.single, 0.2);
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
      // Timeout must also stop the in-flight native generation, not just the
      // await (the 1-minute benchmark cancellation cap).
      expect(backend.session.cancelCalls, 1);
    });

    test('cancel delegates to the active spike session', () async {
      final backend = _FakeGemmaBackend();
      final service = FlutterGemmaLocalSlmService(backend: backend);

      await service.load('gemma_3_1b', modelFilePath: '/tmp/model.task');
      await service.cancel();

      expect(backend.session.cancelCalls, 1);
    });

    test(
      'resetSession reopens a fresh chat on the already-loaded model without reinstall',
      () async {
        final backend = _FakeGemmaBackend();
        final service = FlutterGemmaLocalSlmService(backend: backend);

        await service.load('gemma_3_1b', modelFilePath: '/tmp/model.task');
        expect(backend.openChatCalls, 1);
        expect(backend.installPaths.length, 1);

        await service.resetSession();

        // Old chat closed, a new chat opened; model NOT reinstalled.
        expect(backend.session.closeCalls, 1);
        expect(backend.openChatCalls, 2);
        expect(backend.installPaths.length, 1);
        expect(service.isReady, isTrue);
      },
    );

    test('resetSession throws when no model is loaded', () async {
      final backend = _FakeGemmaBackend();
      final service = FlutterGemmaLocalSlmService(backend: backend);

      await expectLater(
        service.resetSession(),
        throwsA(isA<LocalSlmUnavailable>()),
      );
      expect(backend.openChatCalls, 0);
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
  int openChatCalls = 0;
  final installPaths = <String>[];
  final modelTypes = <gemma.ModelType>[];
  final fileTypes = <gemma.ModelFileType>[];
  final openChatMaxTokens = <int>[];
  final openChatTemperatures = <double>[];

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
    double temperature = 0.1,
    int topK = 40,
    double topP = 0.95,
    gemma.PreferredBackend? preferredBackend,
    String? systemInstruction,
  }) async {
    openChatCalls += 1;
    openChatMaxTokens.add(maxTokens);
    openChatTemperatures.add(temperature);
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
