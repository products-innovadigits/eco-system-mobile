import 'dart:async';

import 'package:flutter_gemma/flutter_gemma.dart' as gemma;
import 'package:project_management/features/ai_assistant/local_slm/local_slm_service.dart';

/// M6-B0 isolated spike adapter for validating real `flutter_gemma` on device.
///
/// This class is intentionally **not** registered in production DI. The default
/// app binding remains [UnavailableLocalSlmService] until FU-1/FU-2 pass.
///
/// Scope rules:
/// - Loads only an already-present developer model file path.
/// - Does not download, fetch, or bundle any model file.
/// - Generates free text only.
/// - Does not persist chat history or model state.
class FlutterGemmaLocalSlmService implements LocalSlmService {
  FlutterGemmaLocalSlmService({
    FlutterGemmaSpikeBackend? backend,
    FlutterGemmaSpikeConfig config = const FlutterGemmaSpikeConfig(),
    this.assumeAlreadyInstalled = false,
  }) : _backend = backend ?? const FlutterGemmaPackageBackend(),
       _config = config;

  final FlutterGemmaSpikeBackend _backend;
  final FlutterGemmaSpikeConfig _config;

  /// POC_DEMO_REAL_CHAT: when true, the model is assumed to already be installed
  /// (e.g. by [FlutterGemmaNetworkDownloader] via network install), so [load]
  /// skips the file-install step and only opens a session/model. The
  /// `modelFilePath` then acts as a logical marker, not a real file to install.
  final bool assumeAlreadyInstalled;

  FlutterGemmaSpikeSession? _session;
  String? _loadedModelId;
  bool _isReady = false;

  @override
  bool get isReady => _isReady;

  @override
  Future<void> load(String modelId, {required String modelFilePath}) async {
    if (_isReady && _loadedModelId == modelId) return;

    // In demo mode the model is already installed by the network downloader, so
    // a real file path isn't required; default the format to MediaPipe `.task`.
    final gemma.ModelFileType fileType;
    if (assumeAlreadyInstalled) {
      fileType = _fileTypeFor(modelFilePath) ?? gemma.ModelFileType.task;
    } else {
      if (modelFilePath.trim().isEmpty) {
        throw const LocalSlmUnavailable(
          'flutter_gemma spike needs a local developer model file path.',
        );
      }
      final detected = _fileTypeFor(modelFilePath);
      if (detected == null) {
        throw LocalSlmUnavailable(
          'Unsupported local model file for flutter_gemma spike: $modelFilePath',
        );
      }
      fileType = detected;
    }

    await _session?.close();
    _isReady = false;
    _loadedModelId = null;

    try {
      await _backend.initialize();
      if (!assumeAlreadyInstalled) {
        await _backend.installFromFile(
          modelFilePath,
          modelType: _modelTypeFor(modelId),
          fileType: fileType,
        );
      }
      _session = await _backend.openChat(
        maxTokens: _config.contextTokens,
        modelType: _modelTypeFor(modelId),
        fileType: fileType,
        preferredBackend: _config.preferredBackend,
        systemInstruction: _config.systemInstruction,
      );
      _loadedModelId = modelId;
      _isReady = true;
    } catch (e) {
      throw LocalSlmUnavailable('flutter_gemma spike load failed: $e');
    }
  }

  @override
  Stream<String> generate(
    String prompt, {
    int maxTokens = 256,
    Duration? timeout,
  }) async* {
    final session = _requireSession();
    try {
      await session.addUserMessage(prompt);
      final stream = session.generate();
      if (timeout == null) {
        await for (final token in stream) {
          yield token;
        }
      } else {
        await for (final token in stream.timeout(timeout)) {
          yield token;
        }
      }
    } on TimeoutException {
      throw const LocalSlmTimeout();
    } catch (e) {
      if (_config.isCancelled(e)) throw const LocalSlmCancelled();
      rethrow;
    }
  }

  @override
  Future<String> generateText(
    String prompt, {
    int maxTokens = 256,
    Duration? timeout,
  }) async {
    final session = _requireSession();
    try {
      await session.addUserMessage(prompt);
      final future = session.generateText();
      return timeout == null ? await future : await future.timeout(timeout);
    } on TimeoutException {
      throw const LocalSlmTimeout();
    } catch (e) {
      if (_config.isCancelled(e)) throw const LocalSlmCancelled();
      rethrow;
    }
  }

  @override
  Future<void> cancel() async {
    await _session?.cancel();
  }

  @override
  Future<void> dispose() async {
    await _session?.close();
    _session = null;
    _loadedModelId = null;
    _isReady = false;
  }

  FlutterGemmaSpikeSession _requireSession() {
    final session = _session;
    if (!_isReady || session == null) {
      throw const LocalSlmUnavailable(
        'flutter_gemma spike model is not loaded.',
      );
    }
    return session;
  }

  gemma.ModelFileType? _fileTypeFor(String path) {
    final lower = path.toLowerCase();
    if (lower.endsWith('.task') || lower.endsWith('.litertlm')) {
      return gemma.ModelFileType.task;
    }
    if (lower.endsWith('.bin') || lower.endsWith('.tflite')) {
      return gemma.ModelFileType.binary;
    }
    return null;
  }

  gemma.ModelType _modelTypeFor(String modelId) {
    if (modelId == 'qwen_2_5_1_5b') return gemma.ModelType.qwen;
    return gemma.ModelType.gemmaIt;
  }
}

/// Spike-only knobs. Defaults are conservative for a 6GB Android device.
class FlutterGemmaSpikeConfig {
  const FlutterGemmaSpikeConfig({
    this.contextTokens = 1024,
    this.preferredBackend,
    this.systemInstruction,
    this.isCancelled = _neverCancelled,
  });

  final int contextTokens;
  final gemma.PreferredBackend? preferredBackend;

  /// Kept as a future compatibility note. flutter_gemma 0.12.x does not expose
  /// system instructions on `createChat`; PromptBuilder already includes system
  /// guidance in the prompt passed from AiInferenceController.
  final String? systemInstruction;
  final bool Function(Object error) isCancelled;

  static bool _neverCancelled(Object error) => false;
}

abstract class FlutterGemmaSpikeBackend {
  Future<void> initialize();

  Future<void> installFromFile(
    String path, {
    required gemma.ModelType modelType,
    required gemma.ModelFileType fileType,
  });

  Future<FlutterGemmaSpikeSession> openChat({
    required int maxTokens,
    required gemma.ModelType modelType,
    required gemma.ModelFileType fileType,
    gemma.PreferredBackend? preferredBackend,
    String? systemInstruction,
  });
}

abstract class FlutterGemmaSpikeSession {
  Future<void> addUserMessage(String text);
  Stream<String> generate();
  Future<String> generateText();
  Future<void> cancel();
  Future<void> close();
}

class FlutterGemmaPackageBackend implements FlutterGemmaSpikeBackend {
  const FlutterGemmaPackageBackend();

  @override
  Future<void> initialize() => gemma.FlutterGemma.initialize();

  @override
  Future<void> installFromFile(
    String path, {
    required gemma.ModelType modelType,
    required gemma.ModelFileType fileType,
  }) {
    return gemma.FlutterGemma.installModel(
      modelType: modelType,
      fileType: fileType,
    ).fromFile(path).install();
  }

  @override
  Future<FlutterGemmaSpikeSession> openChat({
    required int maxTokens,
    required gemma.ModelType modelType,
    required gemma.ModelFileType fileType,
    gemma.PreferredBackend? preferredBackend,
    String? systemInstruction,
  }) async {
    final model = await gemma.FlutterGemmaPlugin.instance.createModel(
      modelType: modelType,
      fileType: fileType,
      maxTokens: maxTokens,
      preferredBackend: preferredBackend,
    );
    final chat = await model.createChat(
      modelType: modelType,
      supportsFunctionCalls: false,
    );
    return _FlutterGemmaPackageSession(model: model, chat: chat);
  }
}

class _FlutterGemmaPackageSession implements FlutterGemmaSpikeSession {
  _FlutterGemmaPackageSession({required this.model, required this.chat});

  final gemma.InferenceModel model;
  final gemma.InferenceChat chat;

  @override
  Future<void> addUserMessage(String text) {
    return chat.addQueryChunk(gemma.Message.text(text: text, isUser: true));
  }

  @override
  Stream<String> generate() async* {
    await for (final response in chat.generateChatResponseAsync()) {
      if (response is gemma.TextResponse) yield response.token;
    }
  }

  @override
  Future<String> generateText() async {
    final response = await chat.generateChatResponse();
    if (response is gemma.TextResponse) return response.token;
    return '';
  }

  @override
  Future<void> cancel() async {
    await chat.stopGeneration();
  }

  @override
  Future<void> close() => model.close();
}
