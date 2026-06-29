/// Lifecycle events emitted by `ModelManager.downloadSelectedModel`.
///
/// M3: download/install lifecycle only — no inference. Every download is
/// user-initiated; nothing here runs automatically.

/// Coarse phase of a user-initiated install attempt.
enum ModelInstallPhase {
  /// Pre-flight checks (device tier / storage) before any network use.
  preflight,

  /// Real download is blocked because final distribution is unresolved
  /// (e.g. gated Gemma — FU-2). No bytes are fetched. Not an error/crash.
  pendingDistribution,

  /// Downloading bytes (see [ModelInstallEvent.progress] 0.0–1.0).
  downloading,

  /// Verifying checksum / version after download.
  verifying,

  /// File present, verified, and recorded installed (now active).
  installed,

  /// Attempt ended without installing (see [ModelInstallEvent.failure]).
  failed,
}

/// Why an install attempt failed (or could not start).
enum ModelInstallFailure {
  unknownModel,
  unsupportedDevice,
  insufficientStorage,
  distributionPending,
  downloadError,
  checksumMismatch,
  versionMismatch,
  cancelled,
}

/// One observable lifecycle event. Immutable.
class ModelInstallEvent {
  const ModelInstallEvent({
    required this.modelId,
    required this.phase,
    this.progress = 0.0,
    this.failure,
    this.message,
  });

  final String modelId;
  final ModelInstallPhase phase;

  /// 0.0–1.0 while [phase] is [ModelInstallPhase.downloading].
  final double progress;

  /// Set only when [phase] is [ModelInstallPhase.failed].
  final ModelInstallFailure? failure;

  /// Optional human-readable note (no secrets).
  final String? message;

  bool get isTerminal =>
      phase == ModelInstallPhase.installed ||
      phase == ModelInstallPhase.failed ||
      phase == ModelInstallPhase.pendingDistribution;

  factory ModelInstallEvent.preflight(String id) =>
      ModelInstallEvent(modelId: id, phase: ModelInstallPhase.preflight);

  factory ModelInstallEvent.pending(String id, {String? message}) =>
      ModelInstallEvent(
        modelId: id,
        phase: ModelInstallPhase.pendingDistribution,
        message: message,
      );

  factory ModelInstallEvent.downloading(String id, double progress) =>
      ModelInstallEvent(
        modelId: id,
        phase: ModelInstallPhase.downloading,
        progress: progress.clamp(0.0, 1.0),
      );

  factory ModelInstallEvent.verifying(String id) =>
      ModelInstallEvent(modelId: id, phase: ModelInstallPhase.verifying);

  factory ModelInstallEvent.installed(String id) =>
      ModelInstallEvent(modelId: id, phase: ModelInstallPhase.installed);

  factory ModelInstallEvent.failed(
    String id,
    ModelInstallFailure failure, {
    String? message,
  }) => ModelInstallEvent(
    modelId: id,
    phase: ModelInstallPhase.failed,
    failure: failure,
    message: message,
  );
}
