import 'package:project_management/features/ai_assistant/local_slm/model_catalog.dart';

/// Thrown by a [ModelDownloader] when a download is cancelled by the user.
class ModelDownloadCancelled implements Exception {
  const ModelDownloadCancelled(this.modelId);
  final String modelId;
}

/// Thrown by a [ModelDownloader] on a network/IO failure.
class ModelDownloadException implements Exception {
  const ModelDownloadException(this.message);
  final String message;
  @override
  String toString() => 'ModelDownloadException: $message';
}

/// Pluggable model-file downloader.
///
/// The real implementation (e.g. `flutter_gemma` install manager /
/// `background_downloader` with resume + foreground service) is injected once
/// FU-2 resolves Gemma distribution and final URLs/checksums exist. Until then
/// the registered default is [NoopModelDownloader] (`isAvailable == false`),
/// so `ModelManager` reports `pendingDistribution` instead of fetching bytes.
abstract class ModelDownloader {
  /// True when a real download backend is wired and usable.
  bool get isAvailable;

  /// Streams fractional progress (0.0–1.0) while downloading [entry] to
  /// [destinationPath]. Must support cancellation via [cancel] (throwing
  /// [ModelDownloadCancelled]). Throws [ModelDownloadException] on IO errors.
  Stream<double> download({
    required ModelCatalogEntry entry,
    required String destinationPath,
  });

  /// Requests cancellation of an in-flight download for [modelId] and cleans
  /// up any partial file (leaving a clean, not-installed state).
  Future<void> cancel(String modelId);
}

/// Default downloader used until FU-2 closes. Never fetches bytes.
class NoopModelDownloader implements ModelDownloader {
  const NoopModelDownloader();

  @override
  bool get isAvailable => false;

  @override
  Stream<double> download({
    required ModelCatalogEntry entry,
    required String destinationPath,
  }) async* {
    throw const ModelDownloadException(
      'No real download backend wired (distribution pending — FU-2).',
    );
  }

  @override
  Future<void> cancel(String modelId) async {}
}

/// Computes the SHA-256 of a downloaded file for integrity verification.
abstract class ChecksumVerifier {
  Future<String> sha256OfFile(String path);
}

/// Resolves the on-device destination path for a model file (e.g. app
/// documents dir + file name). Real impl uses `path_provider`; injected so
/// unit tests stay plugin-free.
abstract class ModelFilePathResolver {
  Future<String> resolve(ModelCatalogEntry entry);
}

/// Best-effort device capability probe for pre-flight checks. A `null` result
/// means "unknown" → the check is skipped (non-blocking). Real impl uses
/// device/storage plugins; injected for testability.
abstract class DeviceCapabilityProbe {
  /// Total device RAM in MB, or null if unknown.
  Future<int?> totalRamMb();

  /// Free storage in bytes, or null if unknown.
  Future<int?> freeStorageBytes();
}

/// Permissive default: everything unknown → pre-flight never blocks.
/// (Real probe is wired alongside the real downloader after FU-2.)
class PermissiveDeviceCapabilityProbe implements DeviceCapabilityProbe {
  const PermissiveDeviceCapabilityProbe();
  @override
  Future<int?> totalRamMb() async => null;
  @override
  Future<int?> freeStorageBytes() async => null;
}

/// Default resolver used until the real downloader is wired. Throws if invoked
/// (it never is while distribution is pending, since download is gated first).
class PendingModelFilePathResolver implements ModelFilePathResolver {
  const PendingModelFilePathResolver();
  @override
  Future<String> resolve(ModelCatalogEntry entry) {
    throw const ModelDownloadException(
      'Model file path resolver not wired (distribution pending — FU-2).',
    );
  }
}

/// Default checksum verifier placeholder used until the real downloader is
/// wired. Throws if invoked (never invoked while distribution is pending).
class PendingChecksumVerifier implements ChecksumVerifier {
  const PendingChecksumVerifier();
  @override
  Future<String> sha256OfFile(String path) {
    throw const ModelDownloadException(
      'Checksum verifier not wired (distribution pending — FU-2).',
    );
  }
}
