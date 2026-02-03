import 'package:dio/dio.dart';

import 'network_exception.dart';

/// Pure error handler that maps DioException to NetworkException.
/// Does NOT perform logout, navigation, or any side-effects.
class ApiErrorHandler {
  /// Maps a DioException or other error to a NetworkException.
  static NetworkException getException(dynamic error) {
    if (error is DioException) {
      return _handleDioException(error);
    }
    return NetworkException(error.toString());
  }

  /// Legacy method for backwards compatibility — returns message string.
  /// @deprecated Use [getException] instead.
  static Future<String> getMessage(dynamic error) async {
    return getException(error).message;
  }

  static NetworkException _handleDioException(DioException error) {
    switch (error.type) {
      case DioExceptionType.cancel:
        return const NetworkException(
          'Request cancelled',
          type: NetworkExceptionType.cancelled,
        );
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return const NetworkException.timeout();
      case DioExceptionType.connectionError:
      case DioExceptionType.unknown:
        return const NetworkException.noConnection();
      case DioExceptionType.badCertificate:
        return const NetworkException(
          'Certificate error',
          type: NetworkExceptionType.unknown,
        );
      case DioExceptionType.badResponse:
        return _handleBadResponse(error);
    }
  }

  static NetworkException _handleBadResponse(DioException error) {
    final statusCode = error.response?.statusCode;
    final data = error.response?.data;

    String message = 'Request failed';
    if (data is Map<String, dynamic>) {
      message = data['message'] as String? ??
          (data['data'] as Map<String, dynamic>?)?['message'] as String? ??
          message;
    }

    switch (statusCode) {
      case 401:
        return NetworkException.unauthorized(message: message);
      case 404:
        return NetworkException(
          message,
          type: NetworkExceptionType.badRequest,
          statusCode: 404,
        );
      case 500:
      case 503:
        return NetworkException(
          message,
          type: NetworkExceptionType.serverError,
          statusCode: statusCode,
        );
      default:
        return NetworkException(
          message,
          type: NetworkExceptionType.unknown,
          statusCode: statusCode,
        );
    }
  }
}
