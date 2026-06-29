/// One POC measurement for a single inference attempt. POC-only telemetry.
///
/// No PII, no prompt/response contents, no secrets — numbers + ids only.
class PocMetric {
  const PocMetric({
    required this.modelId,
    required this.lang,
    required this.latencyFullMs,
    this.latencyFirstTokenMs,
    this.deviceTier,
    this.promptId,
    this.qualityScore,
  });

  final String modelId;

  /// Detected request language (e.g. 'ar' / 'en' / 'mixed').
  final String lang;

  /// Full generation latency in milliseconds.
  final int latencyFullMs;

  final int? latencyFirstTokenMs;
  final String? deviceTier;
  final String? promptId;

  /// Optional manual quality rating (1–5), filled during benchmarking.
  final int? qualityScore;
}

/// Collects [PocMetric]s. In-memory only (POC); not persisted, no chat history.
abstract class PocMetrics {
  void record(PocMetric metric);
  List<PocMetric> get all;
  void clear();
}

class InMemoryPocMetrics implements PocMetrics {
  final List<PocMetric> _items = [];

  @override
  void record(PocMetric metric) => _items.add(metric);

  @override
  List<PocMetric> get all => List.unmodifiable(_items);

  @override
  void clear() => _items.clear();
}
