import 'package:flutter_test/flutter_test.dart';
import 'package:project_management/features/ai_assistant/local_slm/active_model_store.dart';
import 'package:project_management/features/ai_assistant/local_slm/ai_inference_controller.dart';
import 'package:project_management/features/ai_assistant/local_slm/local_slm_service.dart';
import 'package:project_management/features/ai_assistant/local_slm/metadata_loader.dart';
import 'package:project_management/features/ai_assistant/local_slm/model_catalog.dart';
import 'package:project_management/features/ai_assistant/local_slm/model_downloader.dart';
import 'package:project_management/features/ai_assistant/local_slm/model_manager.dart';
import 'package:project_management/features/ai_assistant/local_slm/poc_metrics.dart';
import 'package:project_management/features/ai_assistant/local_slm/prompt_builder.dart';

// ── Fake LocalSlmService (no real inference) ────────────────────────────────

enum _FakeMode { ok, cancelled, timeout, error, unavailable }

class FakeLocalSlmService implements LocalSlmService {
  FakeLocalSlmService({
    this.mode = _FakeMode.ok,
    this.reply = 'مرحبا، هذا رد تجريبي.',
  });

  _FakeMode mode;
  String reply;

  bool ready = false;
  int loadCalls = 0;
  int generateCalls = 0;
  bool cancelCalled = false;
  final List<String> prompts = [];

  @override
  bool get isReady => ready;

  @override
  Future<void> load(String modelId, {required String modelFilePath}) async {
    loadCalls++;
    ready = true;
  }

  @override
  Future<String> generateText(
    String prompt, {
    int maxTokens = 256,
    Duration? timeout,
  }) async {
    generateCalls++;
    prompts.add(prompt);
    switch (mode) {
      case _FakeMode.ok:
        return reply;
      case _FakeMode.cancelled:
        throw const LocalSlmCancelled();
      case _FakeMode.timeout:
        throw const LocalSlmTimeout();
      case _FakeMode.error:
        throw StateError('boom');
      case _FakeMode.unavailable:
        throw const LocalSlmUnavailable('engine down');
    }
  }

  @override
  Stream<String> generate(
    String prompt, {
    int maxTokens = 256,
    Duration? timeout,
  }) async* {
    yield await generateText(prompt, maxTokens: maxTokens, timeout: timeout);
  }

  @override
  Future<void> cancel() async => cancelCalled = true;

  @override
  Future<void> dispose() async {}
}

// Catalog whose entry has a non-empty version (sha256 null → checksum skipped).
ModelCatalog _catalog({String version = 'int4-2026.06'}) => ModelCatalog(
  entries: [
    ModelCatalogEntry(
      id: 'gemma_3_1b',
      displayName: 'Gemma 3 1B',
      role: ModelRole.firstIntegration,
      shortDescription: 'd',
      recommendationLabel: 'Recommended',
      format: ModelFormat.mediapipeTask,
      expectedFileName: 'gemma3-1b-it-int4.task',
      expectedSizeBytes: 1,
      estimatedSizeLabel: '~529 MB',
      version: version,
      gated: true,
      accessNote: 'n',
      supportStatus: ModelSupportStatus.deskVerified,
    ),
  ],
);

void main() {
  // Needed so rootBundle can load the M0 prompt template assets in the probe test.
  TestWidgetsFlutterBinding.ensureInitialized();

  late InMemoryModelStateStore backing;
  late ActiveModelStore store;
  late FakeDownloaderSpy downloader;
  late ModelManager manager;
  late InMemoryPocMetrics metrics;

  ModelManager buildManager(ModelCatalog catalog) {
    downloader = FakeDownloaderSpy();
    return ModelManager(
      catalog: catalog,
      activeModelStore: store,
      downloader: downloader,
      checksumVerifier: _ThrowingVerifier(),
      pathResolver: _ThrowingResolver(),
      deviceProbe: const PermissiveDeviceCapabilityProbe(),
    );
  }

  AiInferenceController build({
    required ModelCatalog catalog,
    required LocalSlmService slm,
    PromptBuilder? promptBuilder,
    MetadataLoader? metadataLoader,
  }) {
    manager = buildManager(catalog);
    metrics = InMemoryPocMetrics();
    return AiInferenceController(
      activeModelStore: store,
      modelManager: manager,
      localSlm: slm,
      metrics: metrics,
      promptBuilder: promptBuilder,
      metadataLoader: metadataLoader ?? const _NullMetadataLoader(),
      systemInstruction: 'SYSTEM: local free-text only.',
    );
  }

  setUp(() {
    backing = InMemoryModelStateStore();
    store = ActiveModelStore(store: backing);
  });

  Future<void> installActive({String version = 'int4-2026.06'}) async {
    await store.markInstalled(
      id: 'gemma_3_1b',
      version: version,
      checksum: '',
      localPath: '/p/gemma.task',
    );
    await store.setActiveModel('gemma_3_1b');
  }

  test('no active model → NoActiveModel', () async {
    final c = build(catalog: _catalog(), slm: FakeLocalSlmService());
    final r = await c.generate('hi');
    expect(r, isA<NoActiveModel>());
    expect(downloader.downloadCalls, 0);
  });

  test('active but not installed → ModelNotInstalled (no download)', () async {
    await store.setActiveModel('gemma_3_1b'); // active, but no install record
    final c = build(catalog: _catalog(), slm: FakeLocalSlmService());
    final r = await c.generate('hi');
    expect(r, isA<ModelNotInstalled>());
    expect((r as ModelNotInstalled).modelId, 'gemma_3_1b');
    expect(downloader.downloadCalls, 0);
  });

  test('corrupt active model → ModelCorrupt', () async {
    await store.markCorrupt('gemma_3_1b');
    await store.setActiveModel('gemma_3_1b');
    final c = build(catalog: _catalog(), slm: FakeLocalSlmService());
    final r = await c.generate('hi');
    expect(r, isA<ModelCorrupt>());
  });

  test('version mismatch → ModelCorrupt (validation flips state)', () async {
    await installActive(version: 'OLD');
    final c = build(
      catalog: _catalog(version: 'NEW'),
      slm: FakeLocalSlmService(),
    );
    final r = await c.generate('hi');
    expect(r, isA<ModelCorrupt>());
  });

  test(
    'installed valid → loads + calls service + passes free text through',
    () async {
      await installActive();
      final slm = FakeLocalSlmService(reply: 'Hello from local model');
      final c = build(catalog: _catalog(), slm: slm);
      final r = await c.generate('What are delayed projects?');
      expect(r, isA<FreeTextResponse>());
      expect((r as FreeTextResponse).text, 'Hello from local model');
      expect(slm.loadCalls, 1);
      expect(slm.generateCalls, 1);
      expect(slm.prompts.single, isNot('What are delayed projects?'));
      expect(slm.prompts.single, contains('SYSTEM: local free-text only.'));
      expect(
        slm.prompts.single,
        contains('User message:\nWhat are delayed projects?'),
      );
      expect(metrics.all.length, 1);
      expect(downloader.downloadCalls, 0);
    },
  );

  test('M0 probe OFF (default) → normal 001 prompt, no intent template', () async {
    await installActive();
    final slm = FakeLocalSlmService(reply: 'normal reply');
    final c = build(catalog: _catalog(), slm: slm);

    final r = await c.generate('What are delayed projects?');

    expect(r, isA<FreeTextResponse>());
    final prompt = slm.prompts.single;
    expect(prompt, contains('SYSTEM: local free-text only.'));
    expect(prompt, isNot(contains('Intent JSON')));
    expect(prompt, isNot(contains('{{USER_QUESTION}}')));
  });

  test('M0 probe ON depth-2 → intent template assembled, question injected', () async {
    await installActive();
    final slm = FakeLocalSlmService(reply: '{"status":"ok"}');
    final c = build(catalog: _catalog(), slm: slm);

    final r = await c.generate(
      'كم عدد المشاريع المتأخرة؟',
      useIntentJsonProbe: true,
      intentProbeDepth: 2,
    );

    expect(r, isA<FreeTextResponse>());
    final prompt = slm.prompts.single;
    expect(prompt, contains('compact depth-2 slice'));
    expect(prompt, contains('Return ONLY the Intent JSON object.'));
    expect(prompt, contains('كم عدد المشاريع المتأخرة؟'));
    expect(prompt, isNot(contains('{{USER_QUESTION}}')));
    expect(prompt, isNot(contains('SYSTEM: local free-text only.')));
  });

  test('M0 probe ON depth-1 → depth-1 fallback template used', () async {
    await installActive();
    final slm = FakeLocalSlmService(reply: '{"status":"ok"}');
    final c = build(catalog: _catalog(), slm: slm);

    final r = await c.generate(
      'show delayed projects',
      useIntentJsonProbe: true,
      intentProbeDepth: 1,
    );

    expect(r, isA<FreeTextResponse>());
    final prompt = slm.prompts.single;
    expect(prompt, contains('compact depth-1 fallback slice'));
    expect(prompt, contains('show delayed projects'));
  });

  test(
    'installed valid → PromptBuilder runs before service receives final prompt',
    () async {
      await installActive();
      final slm = FakeLocalSlmService(reply: 'executive answer');
      final promptBuilder = _SpyPromptBuilder();
      final c = build(
        catalog: _catalog(),
        slm: slm,
        promptBuilder: promptBuilder,
      );

      final r = await c.generate('What is delayed?');

      expect(r, isA<FreeTextResponse>());
      expect(promptBuilder.calls, 1);
      expect(promptBuilder.userTexts, ['What is delayed?']);
      expect(promptBuilder.activeModelIds, ['gemma_3_1b']);
      expect(slm.generateCalls, 1);
      expect(slm.prompts, ['BUILT PROMPT: What is delayed?']);
      expect(slm.prompts.single, isNot('What is delayed?'));
      expect(downloader.downloadCalls, 0);
    },
  );

  test(
    'no active model does not build prompt, call service, or download',
    () async {
      final slm = FakeLocalSlmService();
      final promptBuilder = _SpyPromptBuilder();
      final c = build(
        catalog: _catalog(),
        slm: slm,
        promptBuilder: promptBuilder,
      );

      final r = await c.generate('hi');

      expect(r, isA<NoActiveModel>());
      expect(promptBuilder.calls, 0);
      expect(slm.generateCalls, 0);
      expect(slm.loadCalls, 0);
      expect(downloader.downloadCalls, 0);
    },
  );

  test(
    'not-installed model does not build prompt, call service, or download',
    () async {
      await store.setActiveModel('gemma_3_1b');
      final slm = FakeLocalSlmService();
      final promptBuilder = _SpyPromptBuilder();
      final c = build(
        catalog: _catalog(),
        slm: slm,
        promptBuilder: promptBuilder,
      );

      final r = await c.generate('hi');

      expect(r, isA<ModelNotInstalled>());
      expect(promptBuilder.calls, 0);
      expect(slm.generateCalls, 0);
      expect(slm.loadCalls, 0);
      expect(downloader.downloadCalls, 0);
    },
  );

  test(
    'corrupt model does not build prompt, call service, or download',
    () async {
      await store.markCorrupt('gemma_3_1b');
      await store.setActiveModel('gemma_3_1b');
      final slm = FakeLocalSlmService();
      final promptBuilder = _SpyPromptBuilder();
      final c = build(
        catalog: _catalog(),
        slm: slm,
        promptBuilder: promptBuilder,
      );

      final r = await c.generate('hi');

      expect(r, isA<ModelCorrupt>());
      expect(promptBuilder.calls, 0);
      expect(slm.generateCalls, 0);
      expect(slm.loadCalls, 0);
      expect(downloader.downloadCalls, 0);
    },
  );

  test(
    'PromptBuilder failure returns safe GenerationFailed before service generate',
    () async {
      await installActive();
      final slm = FakeLocalSlmService();
      final c = build(
        catalog: _catalog(),
        slm: slm,
        promptBuilder: const _ThrowingPromptBuilder(),
      );

      final r = await c.generate('hi');

      expect(r, isA<GenerationFailed>());
      expect(
        (r as GenerationFailed).message,
        contains('Prompt build failed safely'),
      );
      expect(slm.generateCalls, 0);
      expect(downloader.downloadCalls, 0);
    },
  );

  test(
    'generation failure → GenerationFailed (safe result, no throw)',
    () async {
      await installActive();
      final c = build(
        catalog: _catalog(),
        slm: FakeLocalSlmService(mode: _FakeMode.error),
      );
      final r = await c.generate('hi');
      expect(r, isA<GenerationFailed>());
    },
  );

  test('cancelled generation → GenerationCancelled', () async {
    await installActive();
    final c = build(
      catalog: _catalog(),
      slm: FakeLocalSlmService(mode: _FakeMode.cancelled),
    );
    final r = await c.generate('hi');
    expect(r, isA<GenerationCancelled>());
  });

  test('timeout → GenerationTimeout', () async {
    await installActive();
    final c = build(
      catalog: _catalog(),
      slm: FakeLocalSlmService(mode: _FakeMode.timeout),
    );
    final r = await c.generate('hi');
    expect(r, isA<GenerationTimeout>());
  });

  test('unavailable engine on load → ModelLoadFailed', () async {
    await installActive();
    final c = build(catalog: _catalog(), slm: UnavailableLocalSlmService());
    final r = await c.generate('hi');
    expect(r, isA<ModelLoadFailed>());
  });

  test('cancel() delegates to service.cancel()', () async {
    final slm = FakeLocalSlmService();
    final c = build(catalog: _catalog(), slm: slm);
    await c.cancel();
    expect(slm.cancelCalled, isTrue);
  });

  test('no chat-history keys are persisted by a full generate', () async {
    await installActive();
    final c = build(catalog: _catalog(), slm: FakeLocalSlmService());
    await c.generate('hi');
    for (final k in backing.keys()) {
      expect(k.contains('chat'), isFalse);
      expect(k.contains('message'), isFalse);
      expect(k.contains('history'), isFalse);
    }
  });
}

// Spy downloader to assert the controller never triggers a download.
class FakeDownloaderSpy implements ModelDownloader {
  int downloadCalls = 0;
  @override
  bool get isAvailable => true;
  @override
  Stream<double> download({
    required ModelCatalogEntry entry,
    required String destinationPath,
  }) async* {
    downloadCalls++;
  }

  @override
  Future<void> cancel(String modelId) async {}
}

class _ThrowingVerifier implements ChecksumVerifier {
  @override
  Future<String> sha256OfFile(String path) async =>
      throw StateError('verifier should not be called in controller path');
}

class _ThrowingResolver implements ModelFilePathResolver {
  @override
  Future<String> resolve(ModelCatalogEntry entry) async =>
      throw StateError('resolver should not be called in controller path');
}

class _SpyPromptBuilder extends PromptBuilder {
  final List<String> userTexts = [];
  final List<String?> activeModelIds = [];

  int get calls => userTexts.length;

  @override
  String build({
    required String userText,
    required String systemInstruction,
    MetadataBundle? metadata,
    Iterable<String>? metadataDomains,
    ModelCatalogEntry? activeModel,
  }) {
    userTexts.add(userText);
    activeModelIds.add(activeModel?.id);
    return 'BUILT PROMPT: $userText';
  }
}

class _ThrowingPromptBuilder extends PromptBuilder {
  const _ThrowingPromptBuilder();

  @override
  String build({
    required String userText,
    required String systemInstruction,
    MetadataBundle? metadata,
    Iterable<String>? metadataDomains,
    ModelCatalogEntry? activeModel,
  }) {
    throw StateError('prompt boom');
  }
}

class _NullMetadataLoader extends MetadataLoader {
  const _NullMetadataLoader();

  @override
  Future<MetadataBundle?> load() async => null;
}
