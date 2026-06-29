import 'package:flutter_test/flutter_test.dart';
import 'package:project_management/features/ai_assistant/local_slm/active_model_store.dart';
import 'package:project_management/features/ai_assistant/local_slm/model_installation_state.dart';

void main() {
  group('ActiveModelStore (model state only)', () {
    late InMemoryModelStateStore backing;
    late ActiveModelStore store;

    setUp(() {
      backing = InMemoryModelStateStore();
      store = ActiveModelStore(store: backing);
    });

    test('active model id is null initially, then saves/reads', () async {
      expect(store.activeModelId, isNull);
      await store.setActiveModel('gemma_3_1b');
      expect(store.activeModelId, 'gemma_3_1b');
    });

    test('active model id survives a new store over the same backing (persist)',
        () async {
      await store.setActiveModel('qwen_2_5_1_5b');
      // Simulate "restart": new store instance over the same persisted backing.
      final reopened = ActiveModelStore(store: backing);
      expect(reopened.activeModelId, 'qwen_2_5_1_5b');
    });

    test('markInstalled persists full model-state record', () async {
      await store.markInstalled(
        id: 'gemma_3_1b',
        version: 'int4-2026.06',
        checksum: 'abc123',
        localPath: '/data/models/gemma3-1b-it-int4.task',
      );
      final rec = store.recordOf('gemma_3_1b');
      expect(rec, isNotNull);
      expect(rec!.version, 'int4-2026.06');
      expect(rec.checksum, 'abc123');
      expect(rec.localPath, '/data/models/gemma3-1b-it-int4.task');
      expect(rec.status, ModelInstallationState.installed);
      expect(store.isInstalled('gemma_3_1b'), isTrue);
    });

    test('unknown model defaults to notInstalled', () {
      expect(store.statusOf('unknown'), ModelInstallationState.notInstalled);
      expect(store.isInstalled('unknown'), isFalse);
    });

    test('markCorrupt flips status and blocks usability', () async {
      await store.markInstalled(
        id: 'gemma_3_1b',
        version: 'v1',
        checksum: 'good',
        localPath: '/p',
      );
      await store.markCorrupt('gemma_3_1b');
      expect(store.statusOf('gemma_3_1b'), ModelInstallationState.corrupt);
      expect(store.isInstalled('gemma_3_1b'), isFalse);
    });

    test('installedModels lists only installed records', () async {
      await store.markInstalled(
        id: 'gemma_3_1b',
        version: 'v1',
        checksum: 'c1',
        localPath: '/a',
      );
      await store.markInstalled(
        id: 'qwen_2_5_1_5b',
        version: 'v2',
        checksum: 'c2',
        localPath: '/b',
      );
      await store.markCorrupt('qwen_2_5_1_5b');
      final installed = store.installedModels();
      expect(installed.map((r) => r.id), ['gemma_3_1b']);
    });

    test('clear removes record and clears active when pointing at it', () async {
      await store.markInstalled(
        id: 'gemma_3_1b',
        version: 'v1',
        checksum: 'c1',
        localPath: '/a',
      );
      await store.setActiveModel('gemma_3_1b');
      await store.clear('gemma_3_1b');
      expect(store.recordOf('gemma_3_1b'), isNull);
      expect(store.activeModelId, isNull);
    });

    test('no chat-history keys are ever written (model state only)', () async {
      await store.setActiveModel('gemma_3_1b');
      await store.markInstalled(
        id: 'gemma_3_1b',
        version: 'v1',
        checksum: 'c1',
        localPath: '/a',
      );
      for (final key in backing.keys()) {
        expect(key.contains('chat'), isFalse);
        expect(key.contains('message'), isFalse);
        expect(key.contains('history'), isFalse);
      }
    });
  });
}
