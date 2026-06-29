/// Lifecycle state of a single local SLM model on the device.
///
/// Phase 1 (M1): pure value type only — no download/install logic here.
/// `corrupt` covers checksum/version mismatch (a model whose file no longer
/// matches the catalog's expected `sha256`/`version`).
enum ModelInstallationState {
  /// No local file for this model (default).
  notInstalled,

  /// A user-initiated download is in progress. Never set automatically.
  downloading,

  /// File present and verified (checksum + version match catalog).
  installed,

  /// A download/install attempt failed (network/IO). Recoverable via retry.
  failed,

  /// File present but checksum or version does not match the catalog.
  /// Must NOT be treated as usable; offer repair/redownload.
  corrupt,
}

extension ModelInstallationStateX on ModelInstallationState {
  /// Only `installed` models may be activated / used for inference.
  bool get isUsable => this == ModelInstallationState.installed;

  /// True when a (user-initiated) download could be started from this state.
  bool get isDownloadable =>
      this == ModelInstallationState.notInstalled ||
      this == ModelInstallationState.failed ||
      this == ModelInstallationState.corrupt;

  String get wireName => name;

  static ModelInstallationState fromWireName(String? value) {
    return ModelInstallationState.values.firstWhere(
      (s) => s.name == value,
      orElse: () => ModelInstallationState.notInstalled,
    );
  }
}
