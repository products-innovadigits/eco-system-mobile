/// Typed error codes for Project AI `/projects/query` failures.
enum AiAssistantQueryErrorCode {
  unknown,
  llmRateLimited,
  conversationContextRequired,
  conversationContextConflict,
  requestTimeout,
  projectAiPipelineError,
  llmProviderError,
}

/// Thrown when the AI `/projects/query` API returns a failure payload or structured HTTP error.
///
/// [message] is a short diagnostic token (not necessarily user-facing). Prefer mapping [code] in UI.
class AiAssistantQueryException implements Exception {
  AiAssistantQueryException(
    this.message, {
    this.code = AiAssistantQueryErrorCode.unknown,
    this.status,
    this.httpStatusCode,
    this.retryAfterSeconds,
    this.rawSafeMessage,
  });

  final String message;
  final AiAssistantQueryErrorCode code;
  final String? status;
  final int? httpStatusCode;
  final int? retryAfterSeconds;

  /// Non-debug backend summary for logs only (do not show raw provider details in UI).
  final String? rawSafeMessage;

  @override
  String toString() => message;
}
