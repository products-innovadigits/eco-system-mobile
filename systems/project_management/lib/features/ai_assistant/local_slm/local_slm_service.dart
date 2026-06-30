/// Phase-1 **text-only** local inference abstraction.
///
/// The real implementation (e.g. `FlutterGemmaLocalSlmService`) is wired at the
/// FU-1/FU-2 boundary (on-device spike + resolved model distribution). Until
/// then the registered default is [UnavailableLocalSlmService], which never
/// runs inference and signals unavailability via [LocalSlmUnavailable].
///
/// Scope rules (locked): free-text only. **No `generateIntent`, no Intent JSON,
/// no JSON validation, no backend fallback.**
abstract class LocalSlmService {
  /// True once a model is loaded into memory and ready to generate.
  bool get isReady;

  /// Loads [modelId] (file at [modelFilePath]) into memory. Idempotent.
  /// Throws [LocalSlmUnavailable] when no real engine is wired.
  Future<void> load(String modelId, {required String modelFilePath});

  /// Streams free-text tokens for [prompt].
  Stream<String> generate(
    String prompt, {
    int maxTokens = 256,
    Duration? timeout,
  });

  /// Convenience: full free-text string for [prompt].
  Future<String> generateText(
    String prompt, {
    int maxTokens = 256,
    Duration? timeout,
  });

  /// **M0 dev probe only.** Fresh, history-free single generation: the
  /// implementation MUST NOT reuse any prior chat/session context (so a long
  /// running chat session cannot overflow the model context window). Used by the
  /// Intent JSON probe; not part of the normal chat path.
  Future<String> generateOneShotText(
    String prompt, {
    int maxTokens = 256,
    Duration? timeout,
  });

  /// Cancels the in-flight generation (if any).
  Future<void> cancel();

  /// Releases the loaded model/session.
  Future<void> dispose();
}

/// Thrown when the local inference engine is not available/wired yet.
class LocalSlmUnavailable implements Exception {
  const LocalSlmUnavailable(this.reason);
  final String reason;
  @override
  String toString() => 'LocalSlmUnavailable: $reason';
}

/// Thrown by an implementation when generation is cancelled.
class LocalSlmCancelled implements Exception {
  const LocalSlmCancelled();
}

/// Thrown by an implementation when generation exceeds its timeout.
class LocalSlmTimeout implements Exception {
  const LocalSlmTimeout();
}

/// Safe default until the real engine (flutter_gemma) is wired. Never performs
/// inference; every operation that would need a model signals unavailability.
class UnavailableLocalSlmService implements LocalSlmService {
  const UnavailableLocalSlmService();

  static const String _reason =
      'Local inference engine is not wired yet (flutter_gemma pending — FU-1/FU-2).';

  @override
  bool get isReady => false;

  @override
  Future<void> load(String modelId, {required String modelFilePath}) async =>
      throw const LocalSlmUnavailable(_reason);

  @override
  Stream<String> generate(
    String prompt, {
    int maxTokens = 256,
    Duration? timeout,
  }) async* {
    throw const LocalSlmUnavailable(_reason);
  }

  @override
  Future<String> generateText(
    String prompt, {
    int maxTokens = 256,
    Duration? timeout,
  }) async => throw const LocalSlmUnavailable(_reason);

  @override
  Future<String> generateOneShotText(
    String prompt, {
    int maxTokens = 256,
    Duration? timeout,
  }) async => throw const LocalSlmUnavailable(_reason);

  @override
  Future<void> cancel() async {}

  @override
  Future<void> dispose() async {}
}
