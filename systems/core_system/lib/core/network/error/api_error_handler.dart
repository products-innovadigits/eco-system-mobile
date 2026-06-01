import 'dart:convert';

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
    final rawData = error.response?.data;
    final normalizedMap = _normalizeResponseMap(rawData);
    final headers = error.response?.headers.map;

    final message = _extractApiMessage(normalizedMap, rawData) ?? 'Request failed';

    switch (statusCode) {
      case 401:
        return NetworkException(
          message,
          type: NetworkExceptionType.unauthorized,
          statusCode: 401,
          responseData: normalizedMap ?? rawData,
          responseHeaders: headers,
        );
      case 404:
        return NetworkException(
          message,
          type: NetworkExceptionType.badRequest,
          statusCode: 404,
          responseData: normalizedMap ?? rawData,
          responseHeaders: headers,
        );
      case 500:
      case 503:
        return NetworkException(
          message,
          type: NetworkExceptionType.serverError,
          statusCode: statusCode,
          responseData: normalizedMap ?? rawData,
          responseHeaders: headers,
        );
      default:
        return NetworkException(
          message,
          type: NetworkExceptionType.unknown,
          statusCode: statusCode,
          responseData: normalizedMap ?? rawData,
          responseHeaders: headers,
        );
    }
  }

  /// Returns a [Map<String, dynamic>] when [data] is a JSON object map or JSON string.
  static Map<String, dynamic>? _normalizeResponseMap(dynamic data) {
    if (data == null) return null;
    if (data is Map<String, dynamic>) return data;
    if (data is Map) return Map<String, dynamic>.from(data);
    if (data is String) {
      try {
        final decoded = jsonDecode(data);
        return _normalizeResponseMap(decoded);
      } catch (_) {
        return null;
      }
    }
    return null;
  }

  static String? _extractApiMessage(
    Map<String, dynamic>? map,
    dynamic rawData,
  ) {
    if (map != null) {
      final message = map['message'];
      if (message is String && message.trim().isNotEmpty) {
        return message.trim();
      }
      final nestedData = map['data'];
      if (nestedData is Map) {
        final m = nestedData is Map<String, dynamic>
            ? nestedData
            : Map<String, dynamic>.from(nestedData);
        final inner = m['message'];
        if (inner is String && inner.trim().isNotEmpty) return inner.trim();
      }
      final error = map['error'];
      if (error is Map) {
        final errMap = error is Map<String, dynamic>
            ? error
            : Map<String, dynamic>.from(error);
        final em = errMap['message'];
        if (em is String && em.trim().isNotEmpty) return em.trim();
      }
      if (error is String && error.trim().isNotEmpty) return error.trim();
    }
    if (rawData is String && rawData.trim().isNotEmpty) {
      return rawData.trim();
    }
    return null;
  }
}
