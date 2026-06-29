import 'package:flutter_test/flutter_test.dart';
import 'package:project_management/features/ai_assistant/local_slm/active_model_store.dart';
import 'package:project_management/features/ai_assistant/local_slm/model_catalog.dart';
import 'package:project_management/features/ai_assistant/local_slm/model_downloader.dart';
import 'package:project_management/features/ai_assistant/local_slm/model_install_event.dart';
import 'package:project_management/features/ai_assistant/local_slm/model_installation_state.dart';
import 'package:project_management/features/ai_assistant/local_slm/model_manager.dart';

// ── Test doubles ────────────────────────────────────────────────────────────

class FakeDownloader implements ModelDownloader {
  FakeDownloader({this.available = true, this.cancelAfter, this.throwIo = false});

  bool available;
  int? cancelAfter; // emit this many chunks then throw cancelled
  bool throwIo;
  int downloadCalls = 0;
  bool cancelCalled = false;

  @override
  bool get isAvailable => available;

  @override
  Stream<double> download({
    required ModelCatalogEntry entry,
    required String destinationPath,
  }) async* {
    downloadCalls++;
    if (throwIo) throw const ModelDownloadException('boom');
    const steps = [0.25, 0.5, 0.75, 1.0];
    var emitted = 0;
    for (final p in steps) {
      if (cancelAfter != null && emitted >= cancelAfter!) {
        throw ModelDownloadCancelled(entry.id);
      }
      yield p;
      emitted++;
    }
  }

  @override
  Future<void> cancel(String modelId) async {
    cancelCalled = true;
  }
}

class FakeChecksum implements ChecksumVerifier {
  FakeChecksum(this.value);
  final String value;
  @override
  Future<String> sha256OfFile(String path) async => value;
}

class FakePathResolver implements ModelFilePathResolver {
  @override
  Future<String> resolve(ModelCatalogEntry entry) async =>
      '/tmp/models/${entry.expectedFileName}';
}

class FakeProbe implements DeviceCapabilityProbe {
  FakeProbe({this.ram, this.free});
  final int? ram;
  final int? free;
  @override
  Future<int?> totalRamMb() async => ram;
  @override
  Future<int?> freeStorageBytes() async => free;
}

// A catalog whose entry HAS resolved url+sha256 (simulates post-FU-2).
ModelCatalog _readyCatalog({String sha = 'GOOD_SHA', String version = 'v1'}) {
  return ModelCatalog(
    entries: [
      ModelCatalogEntry(
        id: 'gemma_3_1b',
        displayName: 'Gemma 3 1B',
        role: ModelRole.firstIntegration,
        shortDescription: 'desc',
        recommendationLabel: 'Recommended',
        format: ModelFormat.mediapipeTask,
        expectedFileName: 'gemma3-1b-it-int4.task',
        expectedSizeBytes: 529 * 1024 * 1024,
        estimatedSizeLabel: '~529 MB',
        version: version,
        gated: true,
        accessNote: 'note',
        supportStatus: ModelSupportStatus.deskVerified,
        downloadUrl: 'https://example.com/gemma.task',
        sha256: sha,
      ),
    ],
  );
}

// Demo catalog: public URL, NO sha256 (POC_DEMO_REAL_CHAT relaxes checksum).
ModelCatalog _demoCatalog({String version = 'q8-demo'}) {
  return ModelCatalog(
    entries: [
      ModelCatalogEntry(
        id: 'qwen_2_5_1_5b',
        displayName: 'Qwen2.5 1.5B',
        role: ModelRole.arabicChallenger,
        shortDescription: 'demo',
        recommendationLabel: 'Demo ready',
        format: ModelFormat.mediapipeTask,
        expectedFileName: 'qwen.task',
        expectedSizeBytes: 1570 * 1024 * 1024,
        estimatedSizeLabel: '~1.57 GB',
        version: version,
        gated: false,
        accessNote: 'public',
        supportStatus: ModelSupportStatus.conditional,
        downloadUrl: 'https://example.com/qwen.task',
        sha256: null, // demo: no checksum
      ),
    ],
  );
}

ModelManager _manager({
  required ModelCatalog catalog,
  required ActiveModelStore store,
  required FakeDownloader downloader,
  String checksum = 'GOOD_SHA',
  FakeProbe? probe,
  bool allowUnverifiedInstall = false,
}) {
  return ModelManager(
    catalog: catalog,
    activeModelStore: store,
    downloader: downloader,
    checksumVerifier: FakeChecksum(checksum),
    pathResolver: FakePathResolver(),
    deviceProbe: probe ?? FakeProbe(),
    allowUnverifiedInstall: allowUnverifiedInstall,
  );
}

void main() {
  late InMemoryModelStateStore backing;
  late ActiveModelStore store;

  setUp(() {
    backing = InMemoryModelStateStore();
    store = ActiveModelStore(store: backing);
  });

  test('production seed (no resolved URL) → pendingDistribution, no download', () async {
    final dl = FakeDownloader();
    final mgr = _manager(catalog: ModelCatalog(), store: store, downloader: dl);
    final events = await mgr.downloadSelectedModel('gemma_3_1b').toList();
    expect(events.last.phase, ModelInstallPhase.pendingDistribution);
    expect(dl.downloadCalls, 0); // never fetched bytes
    expect(store.activeModelId, isNull);
    expect(store.isInstalled('gemma_3_1b'), isFalse);
  });

  test('no auto-download: constructing the manager triggers no download', () {
    final dl = FakeDownloader();
    _manager(catalog: _readyCatalog(), store: store, downloader: dl);
    expect(dl.downloadCalls, 0);
  });

  test('explicit call emits progress then installs + activates (happy path)', () async {
    final dl = FakeDownloader();
    final mgr = _manager(catalog: _readyCatalog(), store: store, downloader: dl);
    final events = await mgr.downloadSelectedModel('gemma_3_1b').toList();

    final phases = events.map((e) => e.phase).toList();
    expect(phases, containsAllInOrder([
      ModelInstallPhase.preflight,
      ModelInstallPhase.downloading,
      ModelInstallPhase.verifying,
      ModelInstallPhase.installed,
    ]));
    // progress observable and monotonic-ish up to 1.0
    final progress = events
        .where((e) => e.phase == ModelInstallPhase.downloading)
        .map((e) => e.progress)
        .toList();
    expect(progress, isNotEmpty);
    expect(progress.last, 1.0);

    // active set ONLY after successful install
    expect(store.isInstalled('gemma_3_1b'), isTrue);
    expect(store.activeModelId, 'gemma_3_1b');
    final rec = store.recordOf('gemma_3_1b')!;
    expect(rec.version, 'v1');
    expect(rec.checksum, 'GOOD_SHA');
    expect(rec.localPath, '/tmp/models/gemma3-1b-it-int4.task');
    expect(dl.downloadCalls, 1);
  });

  test('already installed & valid → no redownload', () async {
    await store.markInstalled(
      id: 'gemma_3_1b',
      version: 'v1',
      checksum: 'GOOD_SHA',
      localPath: '/tmp/models/gemma3-1b-it-int4.task',
    );
    final dl = FakeDownloader();
    final mgr = _manager(catalog: _readyCatalog(), store: store, downloader: dl);
    final events = await mgr.downloadSelectedModel('gemma_3_1b').toList();
    expect(events.single.phase, ModelInstallPhase.installed);
    expect(dl.downloadCalls, 0);
  });

  test('checksum mismatch → corrupt, not installed, no active', () async {
    final dl = FakeDownloader();
    final mgr = _manager(
      catalog: _readyCatalog(sha: 'EXPECTED'),
      store: store,
      downloader: dl,
      checksum: 'ACTUAL_DIFFERENT',
    );
    final events = await mgr.downloadSelectedModel('gemma_3_1b').toList();
    expect(events.last.phase, ModelInstallPhase.failed);
    expect(events.last.failure, ModelInstallFailure.checksumMismatch);
    expect(store.statusOf('gemma_3_1b'), ModelInstallationState.corrupt);
    expect(store.isInstalled('gemma_3_1b'), isFalse);
    expect(store.activeModelId, isNull);
  });

  test('download IO error → failed(downloadError), not installed', () async {
    final dl = FakeDownloader(throwIo: true);
    final mgr = _manager(catalog: _readyCatalog(), store: store, downloader: dl);
    final events = await mgr.downloadSelectedModel('gemma_3_1b').toList();
    expect(events.last.failure, ModelInstallFailure.downloadError);
    expect(store.isInstalled('gemma_3_1b'), isFalse);
  });

  test('cancellation → failed(cancelled), clean state', () async {
    final dl = FakeDownloader(cancelAfter: 2);
    final mgr = _manager(catalog: _readyCatalog(), store: store, downloader: dl);
    final events = await mgr.downloadSelectedModel('gemma_3_1b').toList();
    expect(events.last.failure, ModelInstallFailure.cancelled);
    expect(store.isInstalled('gemma_3_1b'), isFalse);
    expect(store.activeModelId, isNull);
    await mgr.cancel('gemma_3_1b');
    expect(dl.cancelCalled, isTrue);
  });

  test('retry after failure succeeds', () async {
    final failing = FakeDownloader(throwIo: true);
    final mgr1 = _manager(catalog: _readyCatalog(), store: store, downloader: failing);
    expect((await mgr1.downloadSelectedModel('gemma_3_1b').toList()).last.failure,
        ModelInstallFailure.downloadError);

    final ok = FakeDownloader();
    final mgr2 = _manager(catalog: _readyCatalog(), store: store, downloader: ok);
    final events = await mgr2.downloadSelectedModel('gemma_3_1b').toList();
    expect(events.last.phase, ModelInstallPhase.installed);
    expect(store.isInstalled('gemma_3_1b'), isTrue);
  });

  test('unsupported device (RAM below min) → failed, no download', () async {
    final dl = FakeDownloader();
    final mgr = _manager(
      catalog: _readyCatalog(),
      store: store,
      downloader: dl,
      probe: FakeProbe(ram: 2048), // below minRamMb default
    );
    final events = await mgr.downloadSelectedModel('gemma_3_1b').toList();
    expect(events.last.failure, ModelInstallFailure.unsupportedDevice);
    expect(dl.downloadCalls, 0);
  });

  test('insufficient storage → failed, no download', () async {
    final dl = FakeDownloader();
    final mgr = _manager(
      catalog: _readyCatalog(),
      store: store,
      downloader: dl,
      probe: FakeProbe(free: 1024), // tiny
    );
    final events = await mgr.downloadSelectedModel('gemma_3_1b').toList();
    expect(events.last.failure, ModelInstallFailure.insufficientStorage);
    expect(dl.downloadCalls, 0);
  });

  test('downloader unavailable → pendingDistribution even with resolved URL', () async {
    final dl = FakeDownloader(available: false);
    final mgr = _manager(catalog: _readyCatalog(), store: store, downloader: dl);
    final events = await mgr.downloadSelectedModel('gemma_3_1b').toList();
    expect(events.last.phase, ModelInstallPhase.pendingDistribution);
    expect(dl.downloadCalls, 0);
  });

  test('unknown model → failed(unknownModel)', () async {
    final dl = FakeDownloader();
    final mgr = _manager(catalog: _readyCatalog(), store: store, downloader: dl);
    final events = await mgr.downloadSelectedModel('nope').toList();
    expect(events.single.failure, ModelInstallFailure.unknownModel);
  });

  test('repair clears corrupt then redownloads to installed', () async {
    await store.markCorrupt('gemma_3_1b');
    final dl = FakeDownloader();
    final mgr = _manager(catalog: _readyCatalog(), store: store, downloader: dl);
    final events = await mgr.repair('gemma_3_1b').toList();
    expect(events.last.phase, ModelInstallPhase.installed);
    expect(store.isInstalled('gemma_3_1b'), isTrue);
  });

  test('version mismatch invalidates installed (isInstalledAndValid=false)', () async {
    await store.markInstalled(
      id: 'gemma_3_1b',
      version: 'OLD',
      checksum: 'GOOD_SHA',
      localPath: '/p',
    );
    final mgr = _manager(
      catalog: _readyCatalog(version: 'v2'),
      store: store,
      downloader: FakeDownloader(),
    );
    expect(await mgr.isInstalledAndValid('gemma_3_1b'), isFalse);
    expect(store.statusOf('gemma_3_1b'), ModelInstallationState.corrupt);
  });

  test('no chat-history keys written during full install', () async {
    final mgr = _manager(catalog: _readyCatalog(), store: store, downloader: FakeDownloader());
    await mgr.downloadSelectedModel('gemma_3_1b').toList();
    for (final key in backing.keys()) {
      expect(key.contains('chat'), isFalse);
      expect(key.contains('message'), isFalse);
      expect(key.contains('history'), isFalse);
    }
  });

  // ── POC_DEMO_REAL_CHAT: relaxed-checksum demo path ────────────────────────
  group('demo mode (allowUnverifiedInstall)', () {
    test('public URL + no sha256 → downloads, installs (no verify), activates', () async {
      final dl = FakeDownloader();
      final mgr = _manager(
        catalog: _demoCatalog(),
        store: store,
        downloader: dl,
        allowUnverifiedInstall: true,
      );
      final events = await mgr.downloadSelectedModel('qwen_2_5_1_5b').toList();

      expect(events.map((e) => e.phase), containsAllInOrder([
        ModelInstallPhase.downloading,
        ModelInstallPhase.installed,
      ]));
      // No verifying phase (checksum skipped in demo).
      expect(
        events.map((e) => e.phase).contains(ModelInstallPhase.verifying),
        isFalse,
      );
      expect(dl.downloadCalls, 1);
      expect(store.isInstalled('qwen_2_5_1_5b'), isTrue);
      expect(store.activeModelId, 'qwen_2_5_1_5b');
      expect(store.recordOf('qwen_2_5_1_5b')!.checksum, '');
    });

    test('no auto-download: building the demo manager fetches nothing', () {
      final dl = FakeDownloader();
      _manager(
        catalog: _demoCatalog(),
        store: store,
        downloader: dl,
        allowUnverifiedInstall: true,
      );
      expect(dl.downloadCalls, 0);
    });

    test('production (no demo flag) + no sha256 → still pendingDistribution', () async {
      final dl = FakeDownloader();
      final mgr = _manager(
        catalog: _demoCatalog(),
        store: store,
        downloader: dl,
        // allowUnverifiedInstall defaults false → production gate holds.
      );
      final events = await mgr.downloadSelectedModel('qwen_2_5_1_5b').toList();
      expect(events.last.phase, ModelInstallPhase.pendingDistribution);
      expect(dl.downloadCalls, 0);
      expect(store.isInstalled('qwen_2_5_1_5b'), isFalse);
    });

    test('installed demo model is not re-downloaded', () async {
      await store.markInstalled(
        id: 'qwen_2_5_1_5b',
        version: 'q8-demo',
        checksum: '',
        localPath: 'flutter_gemma://installed/qwen',
      );
      final dl = FakeDownloader();
      final mgr = _manager(
        catalog: _demoCatalog(),
        store: store,
        downloader: dl,
        allowUnverifiedInstall: true,
      );
      final events = await mgr.downloadSelectedModel('qwen_2_5_1_5b').toList();
      expect(events.single.phase, ModelInstallPhase.installed);
      expect(dl.downloadCalls, 0);
    });
  });
}
