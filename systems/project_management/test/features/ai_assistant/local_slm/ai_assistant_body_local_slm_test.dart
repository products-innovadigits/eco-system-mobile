import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project_management/features/ai_assistant/local_slm/active_model_store.dart';
import 'package:project_management/features/ai_assistant/local_slm/ai_inference_controller.dart';
import 'package:project_management/features/ai_assistant/local_slm/local_slm_service.dart';
import 'package:project_management/features/ai_assistant/local_slm/model_catalog.dart';
import 'package:project_management/features/ai_assistant/local_slm/model_downloader.dart';
import 'package:project_management/features/ai_assistant/local_slm/model_manager.dart';
import 'package:project_management/features/ai_assistant/local_slm/poc_metrics.dart';
import 'package:project_management/features/ai_assistant/widgets/ai_assistant_body.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  Widget harness(_SpyInferenceController controller) {
    return ScreenUtilInit(
      designSize: const Size(390, 844),
      builder: (_, _) => MaterialApp(
        home: Scaffold(
          body: AiAssistantBody(
            useLocalSlm: true,
            inferenceController: controller,
          ),
        ),
      ),
    );
  }

  Future<void> send(WidgetTester tester, String text) async {
    await tester.enterText(find.byType(TextField), text);
    await tester.tap(find.byIcon(Icons.send_rounded));
    await tester.pump();
  }

  testWidgets('_onSend calls AiInferenceController in local mode', (
    tester,
  ) async {
    final controller = _SpyInferenceController([
      const FreeTextResponse(
        modelId: 'gemma_3_1b',
        text: 'mocked local answer',
      ),
    ]);
    await tester.pumpWidget(harness(controller));

    await send(tester, 'hello');
    await tester.pumpAndSettle();

    expect(controller.generateCalls, 1);
    expect(controller.prompts, ['hello']);
    expect(find.text('mocked local answer'), findsOneWidget);
    expect(controller.repoLikeCalls, 0);
  });

  testWidgets('fallback bubble renders for no active model', (tester) async {
    final controller = _SpyInferenceController([const NoActiveModel()]);
    await tester.pumpWidget(harness(controller));

    await send(tester, 'hello');
    await tester.pumpAndSettle();

    expect(
      find.textContaining('No active local model is selected'),
      findsOneWidget,
    );
  });

  testWidgets('fallback bubble renders for model not installed', (
    tester,
  ) async {
    final controller = _SpyInferenceController([
      const ModelNotInstalled('gemma_3_1b'),
    ]);
    await tester.pumpWidget(harness(controller));

    await send(tester, 'hello');
    await tester.pumpAndSettle();

    expect(
      find.textContaining('distribution URL/checksum is pending'),
      findsOneWidget,
    );
  });

  testWidgets('fallback bubble renders for corrupt model', (tester) async {
    final controller = _SpyInferenceController([
      const ModelCorrupt('gemma_3_1b'),
    ]);
    await tester.pumpWidget(harness(controller));

    await send(tester, 'hello');
    await tester.pumpAndSettle();

    expect(
      find.textContaining('corrupt or version-mismatched'),
      findsOneWidget,
    );
  });

  testWidgets('fallback bubble renders for unavailable local model', (
    tester,
  ) async {
    final controller = _SpyInferenceController([
      const ModelLoadFailed('gemma_3_1b', 'engine unavailable'),
    ]);
    await tester.pumpWidget(harness(controller));

    await send(tester, 'hello');
    await tester.pumpAndSettle();

    expect(
      find.textContaining('Local AI is not available yet'),
      findsOneWidget,
    );
  });

  testWidgets('fallback bubble renders for generation failed', (tester) async {
    final controller = _SpyInferenceController([
      const GenerationFailed('safe failure'),
    ]);
    await tester.pumpWidget(harness(controller));

    await send(tester, 'hello');
    await tester.pumpAndSettle();

    expect(
      find.textContaining('Local generation failed safely'),
      findsOneWidget,
    );
  });

  testWidgets('_isSending blocks concurrent sends', (tester) async {
    final controller = _SpyInferenceController([
      const FreeTextResponse(modelId: 'gemma_3_1b', text: 'done'),
    ], delay: const Duration(milliseconds: 80));
    await tester.pumpWidget(harness(controller));

    await send(tester, 'first');
    await tester.enterText(find.byType(TextField), 'second');
    await tester.tap(find.byIcon(Icons.send_rounded));
    await tester.pump();
    await tester.pumpAndSettle();

    expect(controller.generateCalls, 1);
    expect(controller.prompts, ['first']);
  });

  testWidgets('startNewChat clears in-memory entries only', (tester) async {
    final key = GlobalKey<AiAssistantBodyState>();
    final controller = _SpyInferenceController([
      const FreeTextResponse(modelId: 'gemma_3_1b', text: 'temporary answer'),
    ]);
    await tester.pumpWidget(
      ScreenUtilInit(
        designSize: const Size(390, 844),
        builder: (_, _) => MaterialApp(
          home: Scaffold(
            body: AiAssistantBody(
              key: key,
              useLocalSlm: true,
              inferenceController: controller,
            ),
          ),
        ),
      ),
    );

    await send(tester, 'hello');
    await tester.pumpAndSettle();
    expect(find.text('temporary answer'), findsOneWidget);

    key.currentState!.startNewChat();
    await tester.pumpAndSettle();

    expect(find.text('temporary answer'), findsNothing);
    expect(
      controller.backing.keys().where((key) => key.contains('chat')),
      isEmpty,
    );
    expect(
      controller.backing.keys().where((key) => key.contains('history')),
      isEmpty,
    );
  });

  testWidgets('local mode exposes no Intent JSON backend or MCP text', (
    tester,
  ) async {
    final controller = _SpyInferenceController([
      const FreeTextResponse(modelId: 'gemma_3_1b', text: 'plain free text'),
    ]);
    await tester.pumpWidget(harness(controller));

    await send(tester, 'hello');
    await tester.pumpAndSettle();

    final rendered = find
        .byType(Text)
        .evaluate()
        .map((element) => (element.widget as Text).data ?? '')
        .join(' ')
        .toLowerCase();

    expect(rendered, isNot(contains('intent json')));
    expect(rendered, isNot(contains('backend')));
    expect(rendered, isNot(contains('mcp')));
  });
}

class _SpyInferenceController extends AiInferenceController {
  _SpyInferenceController(
    List<AiInferenceResult> results, {
    this.delay = Duration.zero,
  }) : _results = List<AiInferenceResult>.of(results),
       backing = InMemoryModelStateStore(),
       super(
         activeModelStore: ActiveModelStore(store: InMemoryModelStateStore()),
         modelManager: _ControllerDeps().manager,
         localSlm: const UnavailableLocalSlmService(),
         metrics: InMemoryPocMetrics(),
       );

  final List<AiInferenceResult> _results;
  final Duration delay;
  final InMemoryModelStateStore backing;
  final List<String> prompts = [];
  int generateCalls = 0;
  int repoLikeCalls = 0;

  @override
  Future<AiInferenceResult> generate(
    String userText, {
    int maxTokens = 256,
    Duration? timeout,
  }) async {
    generateCalls++;
    prompts.add(userText);
    if (delay != Duration.zero) {
      await Future<void>.delayed(delay);
    }
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
