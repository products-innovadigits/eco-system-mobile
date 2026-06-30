import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project_management/features/ai_assistant/local_slm/active_model_store.dart';
import 'package:project_management/features/ai_assistant/local_slm/ai_inference_controller.dart';
import 'package:project_management/features/ai_assistant/local_slm/local_slm_service.dart';
import 'package:project_management/features/ai_assistant/local_slm/model_catalog.dart';
import 'package:project_management/features/ai_assistant/local_slm/model_downloader.dart';
import 'package:project_management/features/ai_assistant/local_slm/model_manager.dart';
import 'package:project_management/features/ai_assistant/local_slm/model_selection_controller.dart';
import 'package:project_management/features/ai_assistant/local_slm/poc_metrics.dart';
import 'package:project_management/features/ai_assistant/view/ai_assistant_view.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late InMemoryModelStateStore backing;
  late ActiveModelStore store;
  late ModelSelectionController selectionController;
  late ModelManager modelManager;
  late _SpyInferenceController inferenceController;

  setUp(() {
    backing = InMemoryModelStateStore();
    store = ActiveModelStore(store: backing);
    selectionController = ModelSelectionController(
      catalog: ModelCatalog(),
      activeModelStore: store,
    );
    // Production-gated manager (no demo): real catalog → Gemma has no URL →
    // tapping Download yields pendingDistribution (no install).
    modelManager = ModelManager(
      catalog: ModelCatalog(),
      activeModelStore: store,
      downloader: const NoopModelDownloader(),
      checksumVerifier: const PendingChecksumVerifier(),
      pathResolver: const PendingModelFilePathResolver(),
      deviceProbe: const PermissiveDeviceCapabilityProbe(),
    );
    inferenceController = _SpyInferenceController([
      const FreeTextResponse(modelId: 'gemma_3_1b', text: 'safe local reply'),
    ]);
  });

  Widget harness() {
    return ScreenUtilInit(
      designSize: const Size(390, 844),
      builder: (_, _) => MaterialApp(
        home: AiAssistantView(
          modelSelectionController: selectionController,
          inferenceController: inferenceController,
          modelManager: modelManager,
        ),
      ),
    );
  }

  testWidgets('AI Assistant entry shows Model Selection with 2 model cards', (
    tester,
  ) async {
    await tester.pumpWidget(harness());
    await tester.pumpAndSettle();

    expect(find.text('Gemma 3 1B'), findsOneWidget);
    expect(find.text('Qwen2.5 1.5B'), findsOneWidget);
    expect(find.text('Download'), findsNWidgets(2));
  });

  testWidgets('opening entry and rendering selection does not auto-download', (
    tester,
  ) async {
    await tester.pumpWidget(harness());
    await tester.pumpAndSettle();

    expect(store.activeModelId, isNull);
    expect(store.installedModels(), isEmpty);
    expect(inferenceController.generateCalls, 0);
    expect(backing.keys().where((key) => key.contains('download')), isEmpty);
  });

  testWidgets(
    'tapping not-installed model shows pending distribution state without install',
    (tester) async {
      await tester.pumpWidget(harness());
      await tester.pumpAndSettle();

      await tester.tap(find.text('Download').first);
      await tester.pumpAndSettle();

      // Gemma is gated (no URL) → ModelManager reports pendingDistribution and
      // the view surfaces that notice without installing anything.
      expect(
        find.textContaining('distribution pending'),
        findsOneWidget,
      );
      expect(store.activeModelId, isNull);
      expect(store.recordOf('gemma_3_1b'), isNull);
      expect(inferenceController.generateCalls, 0);
    },
  );

  testWidgets(
    'M0 Probe launcher is absent and selection is unchanged when AI_M0_PROBE flag is off (default)',
    (tester) async {
      // kM0ProbeEnabled defaults to false (no --dart-define in tests), so the
      // dev-only launcher must not render and normal selection is unaffected.
      await tester.pumpWidget(harness());
      await tester.pumpAndSettle();

      expect(find.text('M0 Probe (dev)'), findsNothing);
      // normal model-selection behavior intact
      expect(find.text('Gemma 3 1B'), findsOneWidget);
      expect(find.text('Qwen2.5 1.5B'), findsOneWidget);
      expect(store.activeModelId, isNull);
      expect(inferenceController.generateCalls, 0);
    },
  );

  testWidgets('installed test model can reach local chat flow safely', (
    tester,
  ) async {
    await store.markInstalled(
      id: 'gemma_3_1b',
      version: 'v1',
      checksum: 'c',
      localPath: '/test-only/gemma.task',
    );

    await tester.pumpWidget(harness());
    await tester.pumpAndSettle();

    await tester.tap(find.text('Use'));
    await tester.pumpAndSettle();

    expect(store.activeModelId, 'gemma_3_1b');
    expect(find.textContaining('not live database results'), findsOneWidget);
    expect(find.byType(TextField), findsOneWidget);
  });
}

class _SpyInferenceController extends AiInferenceController {
  _SpyInferenceController(List<AiInferenceResult> results)
    : _results = List<AiInferenceResult>.of(results),
      super(
        activeModelStore: _deps.store,
        modelManager: _deps.manager,
        localSlm: const UnavailableLocalSlmService(),
        metrics: InMemoryPocMetrics(),
      );

  final List<AiInferenceResult> _results;
  int generateCalls = 0;

  static final _deps = _ControllerDeps();

  @override
  Future<AiInferenceResult> generate(
    String userText, {
    int maxTokens = 256,
    Duration? timeout,
  }) async {
    generateCalls++;
    if (_results.isEmpty) {
      return const GenerationFailed('no fake result configured');
    }
    return _results.removeAt(0);
  }
}

class _ControllerDeps {
  _ControllerDeps()
    : store = ActiveModelStore(store: InMemoryModelStateStore()) {
    manager = ModelManager(
      catalog: ModelCatalog(),
      activeModelStore: store,
      downloader: const NoopModelDownloader(),
      checksumVerifier: const PendingChecksumVerifier(),
      pathResolver: const PendingModelFilePathResolver(),
      deviceProbe: const PermissiveDeviceCapabilityProbe(),
    );
  }

  final ActiveModelStore store;
  late final ModelManager manager;
}
