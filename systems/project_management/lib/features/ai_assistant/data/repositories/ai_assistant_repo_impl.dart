import 'dart:convert';

import 'package:core_system/core/network/error/network_exception.dart';
import 'package:core_system/core/network/network_layer.dart';
import 'package:core_system/core/utility/utility.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:project_management/features/ai_assistant/domain/repositories/ai_assistant_repo.dart';
import 'package:project_management/features/ai_assistant/exceptions/ai_assistant_query_exception.dart';
import 'package:project_management/features/ai_assistant/model/ai_assistant_models.dart';
import 'package:project_management/features/ai_assistant/util/ai_assistant_query_error_mapper.dart';

class AiAssistantRepoImpl implements AiAssistantRepo {
  /// Production API — Project AI server (always-on, trusted HTTPS).
  /// Full POST URL: https://188-166-44-162.sslip.io/projects/query
  static const String _queryBaseUrl = 'https://188-166-44-162.sslip.io/';

  static const String _queryPath = 'projects/query';

  /// JSON `debug` flag: off in release/production builds; on in debug/profile.
  static bool get _projectsQueryDebugBody => !kReleaseMode;

  final Network network;

  AiAssistantRepoImpl({required this.network});

  @override
  Future<AiAssistantQueryProjectsResult> queryProjects(
    String query, {
    required String conversationId,
    bool resetContext = false,
  }) async {
    try {
      final raw = await network.requestOrThrow(
        _queryPath,
        baseUrl: _queryBaseUrl,
        body: {
          'conversation_id': conversationId,
          'query': query,
          'debug': _projectsQueryDebugBody,
          'reset_context': resetContext,
        },
        method: ServerMethods.POST,
        model: null,
      );
      final data = raw is Response ? raw.data : raw;
      _logQueryResponse(data);
      _throwIfQueryFailed(data, httpStatusCode: 200);
      return _parseQueryProjectsResult(data);
    } on NetworkException catch (e, stackTrace) {
      final mapped = mapNetworkExceptionToAiAssistantQueryException(e);
      if (mapped != null) {
        if (!kReleaseMode) _logQueryError(mapped, stackTrace);
        throw mapped;
      }
      if (!kReleaseMode) _logQueryError(e, stackTrace);
      rethrow;
    } catch (e, stackTrace) {
      if (!kReleaseMode) _logQueryError(e, stackTrace);
      rethrow;
    }
  }

  @override
  Future<Map<String, dynamic>?> deepHealth() async {
    try {
      final raw = await network.requestOrThrow(
        'health/deep',
        baseUrl: _queryBaseUrl,
        method: ServerMethods.GET,
        model: null,
      );
      final data = raw is Response ? raw.data : raw;
      return normalizeAiAssistantJsonMap(data);
    } catch (e, stackTrace) {
      if (!kReleaseMode) _logQueryError(e, stackTrace);
      rethrow;
    }
  }

  static void _logQueryResponse(dynamic data) {
    if (kReleaseMode) return;
    try {
      String out;
      if (data is Map || data is List) {
        out = jsonEncode(data);
      } else {
        out = data?.toString() ?? 'null';
      }
      const maxLen = 6000;
      if (out.length > maxLen) {
        cprint(
          '${out.substring(0, maxLen)}…',
          label: 'AiAssistantQuery response (truncated)',
        );
      } else {
        cprint(out, label: 'AiAssistantQuery response');
      }
    } catch (_) {
      cprint(data?.toString() ?? 'null', label: 'AiAssistantQuery response');
    }
  }

  static void _logQueryError(Object error, StackTrace stackTrace) {
    cprint(error, errorIn: stackTrace.toString(), label: 'AiAssistantQuery');
  }

  /// When the server returns HTTP 200 with a failure envelope (`success: false`, non-success `status`, etc.).
  static void _throwIfQueryFailed(dynamic data, {int? httpStatusCode}) {
    if (data is! Map) return;
    final map = data is Map<String, dynamic>
        ? data
        : Map<String, dynamic>.from(data);
    if (!_indicatesQueryFailure(map)) return;

    final structured = mapBackendFailureEnvelope(
      map,
      httpStatusCode: httpStatusCode,
      retryAfterSeconds: null,
    );
    if (structured != null) throw structured;

    throw AiAssistantQueryException(
      'UNKNOWN',
      code: AiAssistantQueryErrorCode.unknown,
      httpStatusCode: httpStatusCode,
      rawSafeMessage: _extractResponseMessage(map),
    );
  }

  static bool _indicatesQueryFailure(Map<String, dynamic> map) {
    final success = map['success'];
    if (success is bool) {
      return !success;
    }
    final status = map['status'];
    if (status is String) {
      return status.toLowerCase() != 'success';
    }
    return false;
  }

  static String? _extractResponseMessage(Map<String, dynamic> map) {
    final message = map['message'];
    if (message is String && message.trim().isNotEmpty) {
      return message.trim();
    }
    final error = map['error'];
    if (error is Map) {
      final errMap = error is Map<String, dynamic>
          ? error
          : Map<String, dynamic>.from(error);
      final em = errMap['message'];
      if (em is String && em.trim().isNotEmpty) {
        return em.trim();
      }
    }
    if (error is String && error.trim().isNotEmpty) {
      return error.trim();
    }
    final data = map['data'];
    if (data is Map) {
      final nested = data is Map<String, dynamic>
          ? data
          : Map<String, dynamic>.from(data);
      final inner = nested['message'];
      if (inner is String && inner.trim().isNotEmpty) {
        return inner.trim();
      }
    }
    return null;
  }

  static AiAssistantQueryProjectsResult _parseQueryProjectsResult(
    dynamic data,
  ) {
    if (data == null) {
      return AiAssistantQueryProjectsResult(items: []);
    }

    if (data is List) {
      return AiAssistantQueryProjectsResult(
        items: data
            .map((e) => _itemFromDynamic(e, null))
            .whereType<AiAssistantQueryItem>()
            .toList(),
      );
    }

    if (data is Map) {
      final map = data is Map<String, dynamic>
          ? data
          : Map<String, dynamic>.from(data);
      final columnOrder = _columnOrderFromMeta(map['meta']);
      final resultType = _resultTypeFromMeta(map['meta']);
      final clarification = _asMap(map['clarification']);

      // Clarification / empty carry a message + clickable suggestion chips.
      // Prefer the clarification block's own message, else the top-level one.
      final message = _firstNonEmptyString([
        clarification?['message'],
        map['message'],
      ]);
      final suggestions = _parseSuggestions(
        clarification?['suggestions'] ?? map['suggestions'],
      );

      if (map['data'] != null) {
        final inner = map['data'];
        if (inner is List) {
          return AiAssistantQueryProjectsResult(
            items: inner
                .map((e) => _itemFromDynamic(e, columnOrder))
                .whereType<AiAssistantQueryItem>()
                .toList(),
            resultType: resultType,
            message: message,
            suggestions: suggestions,
          );
        }
      }
      if (map['items'] != null) {
        return _parseQueryProjectsResult(map['items']);
      }
      if (map['projects'] != null) {
        return _parseQueryProjectsResult(map['projects']);
      }
      if (map['results'] != null) {
        return _parseQueryProjectsResult(map['results']);
      }

      if (map['id'] != null || map['projects_id'] != null) {
        final item = _itemFromDynamic(map, columnOrder);
        return AiAssistantQueryProjectsResult(
          items: item != null ? [item] : [],
        );
      }
    }

    return AiAssistantQueryProjectsResult(items: []);
  }

  static Map<String, dynamic>? _asMap(dynamic v) {
    if (v is Map<String, dynamic>) return v;
    if (v is Map) return Map<String, dynamic>.from(v);
    return null;
  }

  static String? _resultTypeFromMeta(dynamic meta) {
    final m = _asMap(meta);
    final rt = m?['result_type'];
    return rt is String && rt.isNotEmpty ? rt : null;
  }

  static String? _firstNonEmptyString(List<dynamic> candidates) {
    for (final c in candidates) {
      if (c is String && c.trim().isNotEmpty) return c.trim();
    }
    return null;
  }

  /// Parses the `suggestions` array (objects with id/label/question). Drops any
  /// entry missing a usable `question` — that is what a tap re-sends.
  static List<AiAssistantSuggestion> _parseSuggestions(dynamic raw) {
    if (raw is! List) return const [];
    final out = <AiAssistantSuggestion>[];
    for (final e in raw) {
      final m = _asMap(e);
      if (m == null) continue;
      final question = m['question'];
      if (question is! String || question.trim().isEmpty) continue;
      final label = m['label'];
      out.add(
        AiAssistantSuggestion(
          id: (m['id']?.toString() ?? '').trim(),
          label: (label is String && label.trim().isNotEmpty)
              ? label.trim()
              : question.trim(),
          question: question.trim(),
        ),
      );
    }
    return out;
  }

  static List<String>? _columnOrderFromMeta(dynamic meta) {
    if (meta is! Map) return null;
    final m = meta is Map<String, dynamic>
        ? meta
        : Map<String, dynamic>.from(meta);
    final cols = m['columns'];
    if (cols is! List) return null;
    return cols
        .map((e) => e?.toString() ?? '')
        .where((s) => s.isNotEmpty)
        .toList();
  }

  static AiAssistantQueryItem? _itemFromDynamic(
    dynamic e,
    List<String>? columnOrder,
  ) {
    if (e is! Map) return null;
    final m = e is Map<String, dynamic> ? e : Map<String, dynamic>.from(e);

    final fields = <String, String>{};
    for (final entry in m.entries) {
      final v = entry.value;
      if (v == null) continue;
      final s = _stringifyValue(v);
      fields[entry.key] = s;
    }

    if (fields.isEmpty) return null;

    final projectId = _parseIntId(m['projects_id']) ?? _parseIntId(m['id']);

    final displayKeyOrder = _orderedKeys(fields.keys, columnOrder);

    return AiAssistantQueryItem(
      projectId: projectId,
      fields: fields,
      displayKeyOrder: displayKeyOrder,
    );
  }

  static int? _parseIntId(dynamic v) {
    if (v is int) return v;
    if (v is num) return v.toInt();
    if (v is String) return int.tryParse(v.trim());
    return null;
  }

  static String _stringifyValue(dynamic v) {
    if (v is String) return v;
    if (v is num || v is bool) return v.toString();
    if (v is Map || v is List) {
      try {
        return jsonEncode(v);
      } catch (_) {
        return v.toString();
      }
    }
    return v.toString();
  }

  static List<String> _orderedKeys(
    Iterable<String> keys,
    List<String>? columnOrder,
  ) {
    final keysList = keys.toList();
    final keySet = keysList.toSet();
    final ordered = <String>[];
    final seen = <String>{};

    if (columnOrder != null) {
      for (final k in columnOrder) {
        if (keySet.contains(k) && !seen.contains(k)) {
          ordered.add(k);
          seen.add(k);
        }
      }
    }

    for (final k in keysList) {
      if (!seen.contains(k)) {
        ordered.add(k);
        seen.add(k);
      }
    }
    return ordered;
  }
}
