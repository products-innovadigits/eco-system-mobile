/// Thrown when the AI `/projects/query` API returns a failure payload (e.g. `success: false`)
/// with an optional user-facing [message] from the response body.
class AiAssistantQueryException implements Exception {
  AiAssistantQueryException(this.message);

  final String message;

  @override
  String toString() => message;
}
