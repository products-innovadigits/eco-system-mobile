import 'package:project_management/features/ai_assistant/local_slm/active_model_store.dart';
import 'package:project_management/features/ai_assistant/local_slm/ai_log.dart';
import 'package:project_management/features/ai_assistant/local_slm/model_catalog.dart';
import 'package:project_management/features/ai_assistant/local_slm/model_downloader.dart';
import 'package:project_management/features/ai_assistant/local_slm/model_install_event.dart';
import 'package:project_management/features/ai_assistant/local_slm/model_installation_state.dart';

/// Orchestrates the **user-initiated** model download/install lifecycle (M3).
///
/// Guarantees:
/// - Never downloads automatically. The only entry point,
///   [downloadSelectedModel], is called from the Model Selection "Download"
///   CTA (M2) — i.e. after explicit user selection.
/// - Never runs inference / chat generation (out of scope until M4/M6).
/// - Updates [ActiveModelStore] only after a successful, checksum-verified
///   install (then sets the model active).
/// - Real downloads are gated behind distribution readiness (FU-2): when a
///   catalog entry has no resolved `downloadUrl`/`sha256` or no real
///   [ModelDownloader] is wired, it reports [ModelInstallPhase.pendingDistribution]
///   instead of fetching bytes.
class ModelManager {
  ModelManager({
    required this.catalog,
    required this.activeModelStore,
    required this.downloader,
    required this.checksumVerifier,
    required this.pathResolver,
    required this.deviceProbe,
    this.storageHeadroomBytes = 200 * 1024 * 1024,
    this.allowUnverifiedInstall = false,
  });

  final ModelCatalog catalog;
  final ActiveModelStore activeModelStore;
  final ModelDownloader downloader;
  final ChecksumVerifier checksumVerifier;
  final ModelFilePathResolver pathResolver;
  final DeviceCapabilityProbe deviceProbe;

  /// Extra free space required beyond the model size before downloading.
  final int storageHeadroomBytes;

  /// POC_DEMO_REAL_CHAT: when true, a catalog entry with a `downloadUrl` but no
  /// `sha256` is allowed to install and the checksum verify step is skipped.
  /// TODO(prod-hardening): keep this `false` in production so SHA256 is
  /// mandatory for download validation, catalog integrity, and repair flows.
  final bool allowUnverifiedInstall;

  /// True when [id] is recorded installed AND still matches the catalog's
  /// expected version + checksum. A mismatch flips the record to `corrupt`
  /// so the UI shows a Repair CTA. Used to avoid redownloading a valid model.
  Future<bool> isInstalledAndValid(String id) async {
    final record = activeModelStore.recordOf(id);
    if (record == null || record.status != ModelInstallationState.installed) {
      return false;
    }
    final entry = catalog.byId(id);
    if (entry == null) return false;

    if (entry.version.isNotEmpty && record.version != entry.version) {
      await activeModelStore.markCorrupt(id);
      return false;
    }
    if (entry.sha256 != null && record.checksum != entry.sha256) {
      await activeModelStore.markCorrupt(id);
      return false;
    }
    return true;
  }

  /// EXPLICIT, user-triggered download+install. Emits lifecycle events and
  /// logs each phase (success or failure); per-progress ticks are not logged.
  Stream<ModelInstallEvent> downloadSelectedModel(String id) async* {
    aiLog('download start id=$id');
    await for (final event in _downloadSelectedModel(id)) {
      if (event.phase != ModelInstallPhase.downloading) {
        final failure =
            event.failure != null ? ' failure=${event.failure!.name}' : '';
        final msg = event.message != null ? ' msg=${event.message}' : '';
        aiLog('download id=$id phase=${event.phase.name}$failure$msg');
      }
      yield event;
    }
  }

  /// Core lifecycle. No-op-download fast paths: unknown model,
  /// already-installed-valid, failed pre-flight, or pending distribution all
  /// return WITHOUT fetching bytes.
  Stream<ModelInstallEvent> _downloadSelectedModel(String id) async* {
    final entry = catalog.byId(id);
    if (entry == null) {
      yield ModelInstallEvent.failed(id, ModelInstallFailure.unknownModel);
      return;
    }

    // Already installed & valid → do not redownload.
    if (await isInstalledAndValid(id)) {
      yield ModelInstallEvent.installed(id);
      return;
    }

    // Pre-flight: device tier + storage (best-effort; unknown → skip).
    yield ModelInstallEvent.preflight(id);
    final ram = await deviceProbe.totalRamMb();
    if (ram != null && ram < (entry.minRamMb)) {
      yield ModelInstallEvent.failed(
        id,
        ModelInstallFailure.unsupportedDevice,
        message: 'Device RAM ${ram}MB below required ${entry.minRamMb}MB.',
      );
      return;
    }
    final free = await deviceProbe.freeStorageBytes();
    if (free != null && free < entry.expectedSizeBytes + storageHeadroomBytes) {
      yield ModelInstallEvent.failed(
        id,
        ModelInstallFailure.insufficientStorage,
        message: 'Not enough free storage for ${entry.estimatedSizeLabel}.',
      );
      return;
    }

    // Distribution gate. Production requires a resolved URL AND a SHA256.
    // POC_DEMO_REAL_CHAT (allowUnverifiedInstall) relaxes the SHA256 gate so a
    // public URL alone is enough to run the demo.
    final missingChecksum = entry.sha256 == null;
    final blockedByChecksum = missingChecksum && !allowUnverifiedInstall;
    if (entry.downloadUrl == null || blockedByChecksum || !downloader.isAvailable) {
      yield ModelInstallEvent.pending(
        id,
        message: allowUnverifiedInstall
            ? 'Download is not available for this model in demo mode (no public URL or no downloader wired).'
            : 'Download is not yet available for this model (distribution pending — FU-2).',
      );
      return;
    }

    // Download (user-initiated only — we are already inside an explicit call).
    final destinationPath = await pathResolver.resolve(entry);
    try {
      yield ModelInstallEvent.downloading(id, 0);
      await for (final progress in downloader.download(
        entry: entry,
        destinationPath: destinationPath,
      )) {
        yield ModelInstallEvent.downloading(id, progress);
      }
    } on ModelDownloadCancelled {
      // Clean state: nothing marked installed.
      yield ModelInstallEvent.failed(id, ModelInstallFailure.cancelled);
      return;
    } on ModelDownloadException catch (e) {
      yield ModelInstallEvent.failed(
        id,
        ModelInstallFailure.downloadError,
        message: e.message,
      );
      return;
    }

    // Verify integrity before recording installed. Skipped only in demo mode
    // when the entry has no SHA256. TODO(prod-hardening): always verify.
    String recordedChecksum = entry.sha256 ?? '';
    if (entry.sha256 != null) {
      yield ModelInstallEvent.verifying(id);
      final actual = await checksumVerifier.sha256OfFile(destinationPath);
      if (actual != entry.sha256) {
        await activeModelStore.markCorrupt(id);
        yield ModelInstallEvent.failed(id, ModelInstallFailure.checksumMismatch);
        return;
      }
      recordedChecksum = actual;
    }

    // Success → record installed (path/version/checksum) then activate.
    await activeModelStore.markInstalled(
      id: id,
      version: entry.version,
      checksum: recordedChecksum,
      localPath: destinationPath,
    );
    await activeModelStore.setActiveModel(id);
    yield ModelInstallEvent.installed(id);
  }

  /// Repair a corrupt/mismatched model: clear its record, then redownload.
  Stream<ModelInstallEvent> repair(String id) async* {
    await activeModelStore.clear(id);
    yield* downloadSelectedModel(id);
  }

  /// Cancel an in-flight download for [id]; leaves a clean (not-installed) state.
  Future<void> cancel(String id) => downloader.cancel(id);
}
