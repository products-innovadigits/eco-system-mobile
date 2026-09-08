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

  /// The message the API sent with a failed response, or null when the body
  /// carried none.
  ///
  /// Unlike [getException] this applies no fallback, so callers can tell a
  /// real backend message apart from a generic failure. Used by
  /// [ApiErrorToastInterceptor] to stay silent on connection blips.
  static String? getApiMessage(dynamic error) {
    if (error is! DioException) return null;
    final rawData = error.response?.data;
    return _extractApiMessage(_normalizeResponseMap(rawData), rawData);
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
      // ───────────────────────────────────────────────────────────────────
      // validationErrors support.
      // The API reports failures with a localized text in
      // `validationErrors[].errorMessageEn`, while `errorMessage` only holds
      // a code, so it is deliberately not used as a fallback here:
      //   {"succeeded": false, "data": null, "warningErrors": null,
      //    "validationErrors": [{"errorCode": "-1", "errorMessage": "-1",
      //     "errorMessageEn": "هذه العملية غير مرتبطه بهذا المشروع"}]}
      // Nothing below was removed, this block only runs before the old
      // lookups and falls through to them when it finds nothing.
      //
      // TO REVERT: delete the 4 lines below and the
      // `_extractValidationErrorMessage` method at the bottom of this class.
      // ───────────────────────────────────────────────────────────────────
      final validationMessage = _extractValidationErrorMessage(map);
      if (validationMessage != null) {
        return validationMessage;
      }

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

  /// Returns the first non empty `errorMessageEn` out of `validationErrors`,
  /// or null when the body carries none.
  ///
  /// Part of the validationErrors support described in [_extractApiMessage],
  /// delete this method together with its call there to revert.
  static String? _extractValidationErrorMessage(Map<String, dynamic> map) {
    final validationErrors = map['validationErrors'];
    if (validationErrors is! List) return null;

    for (final error in validationErrors) {
      if (error is Map) {
        final errorMessage = error['errorMessageEn'];
        if (errorMessage is String && errorMessage.trim().isNotEmpty) {
          return errorMessage.trim();
        }
      }
    }
    return null;
  }
}
