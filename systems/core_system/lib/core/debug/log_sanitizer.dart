import 'package:dio/dio.dart';

/// Shared redaction rules for request/response logging.
///
/// Kept in one place so the console logger ([NetworkLogger]) and the on-screen
/// [DebugOverlay] apply the same policy — no drift between what is printed and
/// what is shown, and no secret leaking into a copied log.
class LogSanitizer {
  static const _bearerPrefix = 'Bearer ';

  /// Header names replaced wholesale.
  static const _maskedHeaders = {'x-api-key', 'cookie', 'set-cookie'};

  /// Body fields replaced wholesale, matched case-insensitively.
  static const _sensitiveBodyFields = {
    'password',
    'confirmpassword',
    'oldpassword',
    'newpassword',
    'token',
    'accesstoken',
    'refreshtoken',
    'access',
    'refresh',
    'idtoken',
    'secret',
    'clientsecret',
    'apikey',
    'cardnumber',
    'cvv',
    'otp',
  };

  static const _redacted = '<masked>';

  /// Keeps the first 8 characters of a bearer token so requests can still be
  /// told apart in a log, and drops the rest.
  static String maskAuthorization(String value) {
    final trimmed = value.trim();
    if (trimmed.length > _bearerPrefix.length + 8 &&
        trimmed.toLowerCase().startsWith(_bearerPrefix.toLowerCase())) {
      final token = trimmed.substring(_bearerPrefix.length);
      return 'Bearer ${token.substring(0, 8)}...$_redacted';
    }
    return _redacted;
  }

  static Map<String, dynamic> sanitizeHeaders(Map<String, dynamic> headers) {
    final out = <String, dynamic>{};
    headers.forEach((key, value) {
      final lower = key.toString().toLowerCase();
      if (lower == 'authorization') {
        out[key.toString()] = maskAuthorization(value.toString());
      } else if (_maskedHeaders.contains(lower) || lower.contains('api-key')) {
        out[key.toString()] = _redacted;
      } else {
        out[key.toString()] = value;
      }
    });
    return out;
  }

  /// Returns a JSON-encodable copy of [data] with sensitive values removed.
  ///
  /// [FormData] is flattened into a map so multipart uploads read as their
  /// fields plus a short description per file, instead of `Instance of
  /// 'FormData'`.
  static dynamic sanitizeBody(dynamic data) {
    if (data is FormData) return _sanitizeFormData(data);
    if (data is Map) {
      final out = <String, dynamic>{};
      for (final entry in data.entries) {
        final key = entry.key.toString();
        out[key] = _isSensitive(key) ? _redacted : sanitizeBody(entry.value);
      }
      return out;
    }
    if (data is List) return data.map(sanitizeBody).toList();
    if (data == null || data is num || data is bool || data is String) {
      return data;
    }
    return data.toString();
  }

  static Map<String, dynamic> _sanitizeFormData(FormData data) {
    final out = <String, dynamic>{};
    for (final field in data.fields) {
      out[field.key] = _isSensitive(field.key) ? _redacted : field.value;
    }
    for (final file in data.files) {
      out[file.key] =
          '[FILE] ${file.value.filename ?? 'unnamed'} '
          '(${file.value.length} bytes, ${file.value.contentType ?? 'unknown'})';
    }
    return out;
  }

  static bool _isSensitive(String key) {
    final normalized = key.toLowerCase().replaceAll(RegExp('[_-]'), '');
    return _sensitiveBodyFields.contains(normalized) ||
        _sensitiveBodyFields.contains(key.toLowerCase());
  }
}
