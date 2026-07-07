import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:project_management/features/ai_assistant/local_slm/active_model_store.dart';
import 'package:project_management/features/ai_assistant/local_slm/model_catalog.dart';
import 'package:project_management/features/ai_assistant/local_slm/model_selection_controller.dart';
import 'package:project_management/features/ai_assistant/local_slm/model_selection_view.dart';

void main() {
  late InMemoryModelStateStore backing;
  late ActiveModelStore store;
  late ModelSelectionController controller;

  setUp(() {
    backing = InMemoryModelStateStore();
    store = ActiveModelStore(store: backing);
    controller = ModelSelectionController(
      catalog: ModelCatalog(),
      activeModelStore: store,
    );
  });

  Widget harness({
    void Function(String)? onOpenChat,
    void Function(String)? onDownloadRequired,
  }) {
    return MaterialApp(
      home: ModelSelectionView(
        controller: controller,
        onOpenChat: onOpenChat,
        onDownloadRequired: onDownloadRequired,
      ),
    );
  }

  testWidgets('shows a card per model with size + Download CTA, no auto-download',
      (tester) async {
    var downloadCalls = 0;
    await tester.pumpWidget(harness(onDownloadRequired: (_) => downloadCalls++));
    await tester.pumpAndSettle();

    expect(find.text('Gemma 3 1B'), findsOneWidget);
    expect(find.text('Qwen2.5 1.5B'), findsOneWidget);
    expect(find.text('Qwen2.5 1.5B ekv4096'), findsOneWidget);
    expect(find.text('~529 MB'), findsOneWidget);
    // Both Qwen variants share the ~1.57 GB size label.
    expect(find.text('~1.57 GB'), findsNWidgets(2));
    expect(find.text('Download'), findsNWidgets(3));
    // Simply opening the screen must NOT trigger any download.
    expect(downloadCalls, 0);
  });

  testWidgets('tapping a not-installed model emits DownloadRequired only on tap',
      (tester) async {
    final requested = <String>[];
    await tester.pumpWidget(harness(onDownloadRequired: requested.add));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Download').first);
    await tester.pumpAndSettle();

    expect(requested, isNotEmpty);
    // No model became active and no record was created (no real download).
    expect(store.activeModelId, isNull);
  });

  testWidgets('installed model shows Use CTA and activates on tap',
      (tester) async {
    await store.markInstalled(
      id: 'gemma_3_1b',
      version: 'v1',
      checksum: 'c',
      localPath: '/p',
    );
    final opened = <String>[];
    await tester.pumpWidget(harness(onOpenChat: opened.add));
    await tester.pumpAndSettle();

    expect(find.text('Use'), findsOneWidget);
    await tester.tap(find.text('Use'));
    await tester.pumpAndSettle();

    expect(opened, ['gemma_3_1b']);
    expect(store.activeModelId, 'gemma_3_1b');
  });
}
