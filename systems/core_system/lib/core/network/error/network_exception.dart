/// Exception thrown by [Network.requestOrThrow] when a network request fails.
class NetworkException implements Exception {
  final String message;
  final NetworkExceptionType type;
  final int? statusCode;

  const NetworkException(
    this.message, {
    this.type = NetworkExceptionType.unknown,
    this.statusCode,
  });

  const NetworkException.unauthorized({String? message})
      : message = message ?? 'Unauthorized',
        type = NetworkExceptionType.unauthorized,
        statusCode = 401;

  const NetworkException.timeout({String? message})
      : message = message ?? 'Request timed out',
        type = NetworkExceptionType.timeout,
        statusCode = null;

  const NetworkException.noConnection({String? message})
      : message = message ?? 'No internet connection',
        type = NetworkExceptionType.noConnection,
        statusCode = null;

  bool get isUnauthorized => type == NetworkExceptionType.unauthorized;
  bool get isTimeout => type == NetworkExceptionType.timeout;
  bool get isNoConnection => type == NetworkExceptionType.noConnection;

  @override
  String toString() => message;
}

/// Type of network exception for categorizing errors.
enum NetworkExceptionType {
  /// 401 Unauthorized response
  unauthorized,

  /// Connection, send, or receive timeout
  timeout,

  /// No internet connection or connection error
  noConnection,

  /// 4xx client errors (except 401)
  badRequest,

  /// 5xx server errors
  serverError,

  /// Request was cancelled
  cancelled,

  /// Unknown or unhandled error
  unknown,
}
