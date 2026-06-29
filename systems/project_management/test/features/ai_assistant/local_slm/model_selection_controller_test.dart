import 'package:flutter_test/flutter_test.dart';
import 'package:project_management/features/ai_assistant/local_slm/active_model_store.dart';
import 'package:project_management/features/ai_assistant/local_slm/model_catalog.dart';
import 'package:project_management/features/ai_assistant/local_slm/model_installation_state.dart';
import 'package:project_management/features/ai_assistant/local_slm/model_selection_controller.dart';

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

  group('buildCards', () {
    test('renders one card per catalog entry (2)', () {
      expect(controller.buildCards().length, 2);
    });

    test('fresh state → all not-installed, Download CTA, none active', () {
      for (final c in controller.buildCards()) {
        expect(c.installState, ModelInstallationState.notInstalled);
        expect(c.cta, ModelCtaType.download);
        expect(c.isInstalled, isFalse);
        expect(c.isActive, isFalse);
      }
    });

    test('installed model → Use CTA + installed flag', () async {
      await store.markInstalled(
        id: 'gemma_3_1b',
        version: 'v1',
        checksum: 'c',
        localPath: '/p',
      );
      final gemma =
          controller.buildCards().firstWhere((c) => c.id == 'gemma_3_1b');
      expect(gemma.cta, ModelCtaType.use);
      expect(gemma.isInstalled, isTrue);
    });

    test('corrupt model → Repair CTA', () async {
      await store.markCorrupt('gemma_3_1b');
      final gemma =
          controller.buildCards().firstWhere((c) => c.id == 'gemma_3_1b');
      expect(gemma.cta, ModelCtaType.repair);
      expect(gemma.isInstalled, isFalse);
    });

    test('active flag reflects ActiveModelStore', () async {
      await store.markInstalled(
        id: 'gemma_3_1b',
        version: 'v1',
        checksum: 'c',
        localPath: '/p',
      );
      await store.setActiveModel('gemma_3_1b');
      final gemma =
          controller.buildCards().firstWhere((c) => c.id == 'gemma_3_1b');
      expect(gemma.isActive, isTrue);
    });
  });

  group('onSelect', () {
    test('not-installed → DownloadRequired and NO download / NO active set',
        () async {
      final action = await controller.onSelect('gemma_3_1b');
      expect(action, isA<DownloadRequired>());
      expect(action.modelId, 'gemma_3_1b');
      // No side effects: not activated, no record created (no download in M2).
      expect(store.activeModelId, isNull);
      expect(store.recordOf('gemma_3_1b'), isNull);
    });

    test('installed → OpenChatRequested and sets active (in-memory)', () async {
      await store.markInstalled(
        id: 'gemma_3_1b',
        version: 'v1',
        checksum: 'c',
        localPath: '/p',
      );
      final action = await controller.onSelect('gemma_3_1b');
      expect(action, isA<OpenChatRequested>());
      expect(store.activeModelId, 'gemma_3_1b');
    });

    test('corrupt → RepairRequired and does NOT change active', () async {
      await store.markCorrupt('gemma_3_1b');
      final action = await controller.onSelect('gemma_3_1b');
      expect(action, isA<RepairRequired>());
      expect(store.activeModelId, isNull);
    });

    test('switching between two installed models updates active, no download',
        () async {
      for (final id in ['gemma_3_1b', 'qwen_2_5_1_5b']) {
        await store.markInstalled(
          id: id,
          version: 'v',
          checksum: 'c',
          localPath: '/p/$id',
        );
      }
      await controller.onSelect('gemma_3_1b');
      expect(store.activeModelId, 'gemma_3_1b');
      await controller.onSelect('qwen_2_5_1_5b');
      expect(store.activeModelId, 'qwen_2_5_1_5b');
      // Both remain installed; nothing re-created/downloaded.
      expect(store.installedModels().map((r) => r.id).toSet(),
          {'gemma_3_1b', 'qwen_2_5_1_5b'});
    });
  });
}
