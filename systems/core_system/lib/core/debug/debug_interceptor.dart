import 'package:dio/dio.dart';

import 'debug_log_store.dart';
import 'log_sanitizer.dart';

/// Feeds every request/response through [LogSanitizer] into [DebugLogStore]
/// so the on-screen [DebugOverlay] can show them.
///
/// Console output stays the job of `NetworkLogger.logger`, which is registered
/// alongside this — printing here too would only double every line.
///
/// Registered in [Network] behind `AppConfig.enableDebugOverlay`.
class DebugInterceptor extends Interceptor {
  /// Keys holding the per-request bookkeeping in the request `extra` map.
  static const String _logIdKey = '_debugLogId';
  static const String _startTimeKey = '_debugStartTime';

  final DebugLogStore _store = DebugLogStore.instance;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final id = _store.logRequest(
      method: options.method,
      url: options.uri.toString(),
      headers: LogSanitizer.sanitizeHeaders(options.headers),
      body: LogSanitizer.sanitizeBody(options.data),
      queryParameters: options.queryParameters.isEmpty
          ? null
          : Map<String, dynamic>.from(
              LogSanitizer.sanitizeBody(options.queryParameters) as Map,
            ),
    );
    options.extra[_logIdKey] = id;
    options.extra[_startTimeKey] = DateTime.now();
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    final id = response.requestOptions.extra[_logIdKey] as String?;
    if (id != null) {
      _store.logResponse(
        id: id,
        statusCode: response.statusCode,
        headers: _headersToMap(response.headers),
        body: LogSanitizer.sanitizeBody(response.data),
        duration: _elapsed(response.requestOptions),
      );
    }
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final id = err.requestOptions.extra[_logIdKey] as String?;
    if (id != null) {
      _store.logError(
        id: id,
        statusCode: err.response?.statusCode,
        headers: err.response == null
            ? null
            : _headersToMap(err.response!.headers),
        responseBody: LogSanitizer.sanitizeBody(err.response?.data),
        error: err.message ?? err.toString(),
        duration: _elapsed(err.requestOptions),
      );
    }
    handler.next(err);
  }

  Duration? _elapsed(RequestOptions options) {
    final start = options.extra[_startTimeKey];
    if (start is! DateTime) return null;
    return DateTime.now().difference(start);
  }

  Map<String, dynamic> _headersToMap(Headers headers) {
    final map = <String, dynamic>{};
    headers.forEach((name, values) {
      map[name] = values.length == 1 ? values.first : values;
    });
    return LogSanitizer.sanitizeHeaders(map);
  }
}
