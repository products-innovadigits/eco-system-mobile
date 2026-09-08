import 'dart:convert';

import 'package:flutter/foundation.dart';

/// A single network request/response captured for the debug overlay.
///
/// Instances are immutable: the response is attached by replacing the entry in
/// [DebugLogStore], so a widget holding an entry never sees it change underneath.
@immutable
class DebugNetworkLog {
  final String id;
  final DateTime timestamp;
  final String method;
  final String url;
  final Map<String, dynamic> requestHeaders;
  final dynamic requestBody;
  final Map<String, dynamic>? queryParameters;
  final int? statusCode;
  final Map<String, dynamic>? responseHeaders;
  final dynamic responseBody;
  final String? error;
  final Duration? duration;

  const DebugNetworkLog({
    required this.id,
    required this.timestamp,
    required this.method,
    required this.url,
    required this.requestHeaders,
    this.requestBody,
    this.queryParameters,
    this.statusCode,
    this.responseHeaders,
    this.responseBody,
    this.error,
    this.duration,
  });

  bool get isPending => statusCode == null && error == null;

  bool get isSuccess =>
      error == null &&
      statusCode != null &&
      statusCode! >= 200 &&
      statusCode! < 300;

  DebugNetworkLog copyWith({
    int? statusCode,
    Map<String, dynamic>? responseHeaders,
    dynamic responseBody,
    String? error,
    Duration? duration,
  }) {
    return DebugNetworkLog(
      id: id,
      timestamp: timestamp,
      method: method,
      url: url,
      requestHeaders: requestHeaders,
      requestBody: requestBody,
      queryParameters: queryParameters,
      statusCode: statusCode ?? this.statusCode,
      responseHeaders: responseHeaders ?? this.responseHeaders,
      responseBody: responseBody ?? this.responseBody,
      error: error ?? this.error,
      duration: duration ?? this.duration,
    );
  }

  /// The whole entry as text, for the copy button in the detail view.
  String toClipboardText() {
    final buffer = StringBuffer()
      ..writeln('[$method] $url')
      ..writeln('Time: $timestamp');
    if (duration != null) {
      buffer.writeln('Duration: ${duration!.inMilliseconds}ms');
    }
    buffer
      ..writeln('Status: ${statusCode ?? (error != null ? 'ERROR' : 'PENDING')}')
      ..writeln()
      ..writeln('--- Request Headers ---')
      ..writeln(prettyJson(requestHeaders));

    if (queryParameters != null && queryParameters!.isNotEmpty) {
      buffer
        ..writeln()
        ..writeln('--- Query Parameters ---')
        ..writeln(prettyJson(queryParameters));
    }
    if (requestBody != null) {
      buffer
        ..writeln()
        ..writeln('--- Request Body ---')
        ..writeln(prettyJson(requestBody));
    }
    if (responseHeaders != null) {
      buffer
        ..writeln()
        ..writeln('--- Response Headers ---')
        ..writeln(prettyJson(responseHeaders));
    }
    if (responseBody != null) {
      buffer
        ..writeln()
        ..writeln('--- Response Body ---')
        ..writeln(prettyJson(responseBody));
    }
    if (error != null) {
      buffer
        ..writeln()
        ..writeln('--- Error ---')
        ..writeln(error);
    }
    return buffer.toString();
  }

  /// Indented JSON, falling back to `toString()` for anything not encodable.
  static String prettyJson(dynamic data) {
    try {
      return const JsonEncoder.withIndent('  ').convert(data);
    } catch (_) {
      return data?.toString() ?? 'null';
    }
  }
}

/// In-memory store of the requests captured by [DebugInterceptor].
///
/// Holds at most [maxLogs] entries so a long session cannot grow without
/// bound. Nothing is persisted — the log dies with the process.
class DebugLogStore extends ChangeNotifier {
  DebugLogStore._();

  static final DebugLogStore instance = DebugLogStore._();

  static const int maxLogs = 200;

  final List<DebugNetworkLog> _logs = [];

  /// Newest first.
  List<DebugNetworkLog> get logs => List.unmodifiable(_logs);

  /// Records a request and returns its id, so the response can be attached
  /// to the same entry once it arrives.
  String logRequest({
    required String method,
    required String url,
    required Map<String, dynamic> headers,
    dynamic body,
    Map<String, dynamic>? queryParameters,
  }) {
    final id = '${DateTime.now().microsecondsSinceEpoch}';
    _logs.insert(
      0,
      DebugNetworkLog(
        id: id,
        timestamp: DateTime.now(),
        method: method,
        url: url,
        requestHeaders: headers,
        requestBody: body,
        queryParameters: queryParameters,
      ),
    );
    if (_logs.length > maxLogs) {
      _logs.removeRange(maxLogs, _logs.length);
    }
    notifyListeners();
    return id;
  }

  /// Attaches a response to the entry [id] created by [logRequest].
  ///
  /// Does nothing when the entry has already been evicted by [maxLogs].
  void logResponse({
    required String id,
    required int? statusCode,
    Map<String, dynamic>? headers,
    dynamic body,
    Duration? duration,
  }) {
    _patch(
      id,
      (log) => log.copyWith(
        statusCode: statusCode,
        responseHeaders: headers,
        responseBody: body,
        duration: duration,
      ),
    );
  }

  /// Attaches a failure to the entry [id] created by [logRequest].
  void logError({
    required String id,
    required String error,
    int? statusCode,
    Map<String, dynamic>? headers,
    dynamic responseBody,
    Duration? duration,
  }) {
    _patch(
      id,
      (log) => log.copyWith(
        statusCode: statusCode,
        responseHeaders: headers,
        responseBody: responseBody,
        error: error,
        duration: duration,
      ),
    );
  }

  void clear() {
    _logs.clear();
    notifyListeners();
  }

  void _patch(String id, DebugNetworkLog Function(DebugNetworkLog) update) {
    final index = _logs.indexWhere((log) => log.id == id);
    if (index == -1) return;
    _logs[index] = update(_logs[index]);
    notifyListeners();
  }
}
