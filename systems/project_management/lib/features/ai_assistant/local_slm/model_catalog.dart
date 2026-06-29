/// Static catalog of local SLM models offered in the Model Selection UI.
///
/// Phase 1 (M1): catalog data + lookup only. **No model files are bundled**;
/// the app ships only this manifest. Download metadata (`downloadUrl`,
/// `sha256`) are placeholders until FU-2 resolves final distribution.
///
/// Seed data comes from M0 verification (see `research.md` → "M0 Execution
/// Findings"): `litert-community/Gemma3-1B-IT` and
/// `litert-community/Qwen2.5-1.5B-Instruct`.

/// Why a model exists in the catalog.
enum ModelRole {
  /// First integration model — lightweight, recommended default.
  firstIntegration,

  /// Arabic-quality challenger — benchmarked against the first model.
  arabicChallenger,

  /// Optional fallback for weak devices.
  weakDeviceFallback,
}

/// On-device file format the runtime (`flutter_gemma`) consumes.
enum ModelFormat {
  /// MediaPipe `.task` (mobile).
  mediapipeTask,

  /// LiteRT-LM `.litertlm` (desktop / LiteRT-LM).
  litertLm,
}

/// Verification/readiness status carried from M0.
enum ModelSupportStatus {
  /// Desk-verified; on-device spike still pending (FU-1).
  deskVerified,

  /// Conditional inclusion (e.g. size caveat / pending decision — FU-3).
  conditional,

  /// Fully verified on a real target device.
  deviceVerified,
}

/// One immutable catalog entry. UI reads display fields; M3 reads download
/// metadata. Equality is by [id].
class ModelCatalogEntry {
  const ModelCatalogEntry({
    required this.id,
    required this.displayName,
    required this.role,
    required this.shortDescription,
    required this.recommendationLabel,
    required this.format,
    required this.expectedFileName,
    required this.expectedSizeBytes,
    required this.estimatedSizeLabel,
    required this.version,
    required this.gated,
    required this.accessNote,
    required this.supportStatus,
    this.minRamMb = 6144,
    this.downloadUrl,
    this.sha256,
  });

  /// Stable identifier (e.g. `gemma_3_1b`). Used as the persistence key.
  final String id;

  final String displayName;
  final ModelRole role;
  final String shortDescription;

  /// Short label shown on the card (e.g. "Recommended", "Better Arabic").
  final String recommendationLabel;

  final ModelFormat format;

  /// Expected on-device file name (e.g. `gemma3-1b-it-int4.task`).
  final String expectedFileName;

  /// Approximate size in bytes (for storage pre-flight + display).
  final int expectedSizeBytes;

  /// Human label (e.g. "~529 MB").
  final String estimatedSizeLabel;

  /// Catalog version of the model artifact (used for version validation).
  final String version;

  /// True when distribution requires license acceptance / token (e.g. Gemma).
  final bool gated;

  /// Human note about access/distribution constraints.
  final String accessNote;

  final ModelSupportStatus supportStatus;

  /// Minimum device RAM (MB) to allow install/run. Phase-1 floor: 6 GB.
  final int minRamMb;

  /// Final resolved download URL. **Placeholder until FU-2** (esp. gated Gemma).
  final String? downloadUrl;

  /// Expected SHA-256 of the file. **Placeholder until FU-2**; verified by
  /// ModelManager (M3) after download.
  final String? sha256;

  bool get isPrimary => role == ModelRole.firstIntegration;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ModelCatalogEntry && other.id == id);

  @override
  int get hashCode => id.hashCode;
}

/// Read-only catalog of available models (manifest only — no files bundled).
class ModelCatalog {
  ModelCatalog({List<ModelCatalogEntry>? entries})
    : entries = List.unmodifiable(entries ?? _seed);

  final List<ModelCatalogEntry> entries;

  /// Lookup by id; null when absent.
  ModelCatalogEntry? byId(String id) {
    for (final e in entries) {
      if (e.id == id) return e;
    }
    return null;
  }

  /// The recommended first integration model (Gemma 3 1B in phase 1).
  ModelCatalogEntry get primary =>
      entries.firstWhere((e) => e.isPrimary, orElse: () => entries.first);

  /// Seed entries from M0 findings. Download URL + SHA256 are intentionally
  /// null placeholders (resolved in FU-2 before M3 download work).
  static const List<ModelCatalogEntry> _seed = [
    ModelCatalogEntry(
      id: 'gemma_3_1b',
      displayName: 'Gemma 3 1B',
      role: ModelRole.firstIntegration,
      shortDescription:
          'Lightweight on-device model. Recommended first integration model for offline free-text.',
      recommendationLabel: 'Recommended',
      format: ModelFormat.mediapipeTask,
      expectedFileName: 'gemma3-1b-it-int4.task',
      expectedSizeBytes: 529 * 1024 * 1024,
      estimatedSizeLabel: '~529 MB',
      version: 'int4-2026.06',
      gated: true,
      accessNote:
          'Gemma Terms — gated on Hugging Face (litert-community/Gemma3-1B-IT). '
          'Distribution must be resolved before download (FU-2): self-host/mirror or token proxy.',
      supportStatus: ModelSupportStatus.deskVerified,
      downloadUrl: null, // FU-2: set after resolving gated distribution.
      sha256: null, // FU-2: capture at catalog-build time.
    ),
    ModelCatalogEntry(
      id: 'qwen_2_5_1_5b',
      displayName: 'Qwen2.5 1.5B',
      role: ModelRole.arabicChallenger,
      shortDescription:
          'Demo-ready Arabic/English model. Public (Apache-2.0). Large download.',
      recommendationLabel: 'Demo ready',
      format: ModelFormat.mediapipeTask,
      expectedFileName: 'Qwen2.5-1.5B-Instruct_seq128_q8_ekv1280.task',
      expectedSizeBytes: 1570 * 1024 * 1024,
      estimatedSizeLabel: '~1.57 GB',
      version: 'q8-seq128-ekv1280',
      gated: false,
      accessNote:
          'Apache-2.0 — public/ungated (litert-community/Qwen2.5-1.5B-Instruct). '
          'POC demo model. Exceeds ~1.2 GB soft cap (FU-3 decision pending).',
      supportStatus: ModelSupportStatus.conditional,
      // POC_DEMO_REAL_CHAT: real public, ungated resolve URL so the demo can
      // actually download + run. TODO(prod-hardening): finalize production
      // distribution + capture SHA256 (sha256 stays null → demo skips checksum).
      downloadUrl:
          'https://huggingface.co/litert-community/Qwen2.5-1.5B-Instruct/resolve/main/Qwen2.5-1.5B-Instruct_seq128_q8_ekv1280.task',
      sha256: null, // TODO(prod-hardening): capture + enforce for production.
    ),
  ];
}
