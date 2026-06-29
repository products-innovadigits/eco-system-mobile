import 'dart:convert';

import 'package:core_system/core/network/error/network_exception.dart';
import 'package:core_system/core/network/network_layer.dart';
import 'package:core_system/core/utility/utility.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:project_management/features/ai_assistant/domain/repositories/ai_assistant_repo.dart';
import 'package:project_management/features/ai_assistant/exceptions/ai_assistant_query_exception.dart';
import 'package:project_management/features/ai_assistant/model/ai_assistant_models.dart';
import 'package:project_management/features/ai_assistant/util/ai_assistant_config.dart';
import 'package:project_management/features/ai_assistant/util/ai_assistant_query_error_mapper.dart';

class AiAssistantRepoImpl implements AiAssistantRepo {
  /// Relative path; full URL is [AiAssistantConfig.queryUrl].
  static const String _queryPath = 'projects/query';

  final Network network;

  AiAssistantRepoImpl({required this.network});

  @override
  Future<AiAssistantQueryProjectsResult> queryProjects(
    String query, {
    required String conversationId,
    bool resetContext = false,
    int page = 1,
    int pageSize = 10,
  }) async {
    final safePage = page < 1 ? 1 : page;
    final safePageSize = pageSize < 1 ? 10 : pageSize;
    final url = AiAssistantConfig.queryUrl;

    _logQueryRequest(
      url: url,
      conversationId: conversationId,
      query: query,
      page: safePage,
      pageSize: safePageSize,
      resetContext: resetContext,
    );

    try {
      final raw = await network.requestOrThrow(
        _queryPath,
        baseUrl: AiAssistantConfig.queryBaseUrl,
        body: {
          'conversation_id': conversationId,
          'query': query,
          'page': safePage,
          'page_size': safePageSize,
          'debug': AiAssistantConfig.projectsQueryDebugBody,
          if (resetContext) 'reset_context': true,
        },
        method: ServerMethods.POST,
        model: null,
      );
      final response = raw is Response ? raw : null;
      final data = response?.data ?? raw;
      final httpStatus = response?.statusCode ?? 200;

      _logQueryOutcome(data, httpStatus: httpStatus);
      _logQueryResponse(data);

      _throwIfQueryFailed(data, httpStatusCode: httpStatus);
      return _parseQueryProjectsResult(data);
    } on NetworkException catch (e, stackTrace) {
      _logQueryOutcome(e.responseData, httpStatus: e.statusCode);
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
        baseUrl: AiAssistantConfig.queryBaseUrl,
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

  static void _logQueryRequest({
    required String url,
    required String conversationId,
    required String query,
    required int page,
    required int pageSize,
    required bool resetContext,
  }) {
    if (kReleaseMode) return;
    cprint(
      'url=$url conversation_id=$conversationId query=$query page=$page page_size=$pageSize reset_context=$resetContext debug=${AiAssistantConfig.projectsQueryDebugBody}',
      label: 'AiAssistantQuery request',
    );
  }

  static void _logQueryOutcome(dynamic data, {required int? httpStatus}) {
    if (kReleaseMode) return;
    final map = normalizeAiAssistantJsonMap(data);
    if (map == null) {
      cprint('http=$httpStatus', label: 'AiAssistantQuery outcome');
      return;
    }
    final status = map['status'];
    final message = map['message'];
    final success = map['success'];
    final pagination = _paginationFromMeta(map['meta']);
    cprint(
      'http=$httpStatus success=$success status=$status message=$message has_more=${pagination.hasMore} next_page=${pagination.nextPage}',
      label: 'AiAssistantQuery outcome',
    );
  }

  static void _logQueryResponse(dynamic data) {
    if (kReleaseMode) return;
    try {
      final map = normalizeAiAssistantJsonMap(data);
      if (map != null && map['debug'] != null) {
        // Never log backend debug payloads (may contain SQL/DSN).
        cprint('<debug omitted>', label: 'AiAssistantQuery response debug');
      }

      String out;
      if (data is Map || data is List) {
        final copy = map != null ? Map<String, dynamic>.from(map) : data;
        if (copy is Map<String, dynamic>) {
          copy.remove('debug');
        }
        out = jsonEncode(copy);
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
      return AiAssistantQueryProjectsResult.empty();
    }

    if (data is List) {
      return AiAssistantQueryProjectsResult(
        items: data
            .map((e) => _itemFromDynamic(e, null))
            .whereType<AiAssistantQueryItem>()
            .toList(),
        pagination: AiAssistantQueryPagination.initial(),
      );
    }

    if (data is Map) {
      final map = data is Map<String, dynamic>
          ? data
          : Map<String, dynamic>.from(data);
      final columnOrder = _columnOrderFromMeta(map['meta']);
      final pagination = _paginationFromMeta(map['meta']);

      if (map['data'] != null) {
        final inner = map['data'];
        if (inner is List) {
          return AiAssistantQueryProjectsResult(
            items: inner
                .map((e) => _itemFromDynamic(e, columnOrder))
                .whereType<AiAssistantQueryItem>()
                .toList(),
            pagination: pagination,
          );
        }
      }
      if (map['items'] != null) {
        final nested = _parseQueryProjectsResult(map['items']);
        return AiAssistantQueryProjectsResult(
          items: nested.items,
          pagination: pagination.hasMore || pagination.nextPage != null
              ? pagination
              : nested.pagination,
        );
      }
      if (map['projects'] != null) {
        final nested = _parseQueryProjectsResult(map['projects']);
        return AiAssistantQueryProjectsResult(
          items: nested.items,
          pagination: pagination.hasMore || pagination.nextPage != null
              ? pagination
              : nested.pagination,
        );
      }
      if (map['results'] != null) {
        final nested = _parseQueryProjectsResult(map['results']);
        return AiAssistantQueryProjectsResult(
          items: nested.items,
          pagination: pagination.hasMore || pagination.nextPage != null
              ? pagination
              : nested.pagination,
        );
      }

      if (map['id'] != null || map['projects_id'] != null) {
        final item = _itemFromDynamic(map, columnOrder);
        return AiAssistantQueryProjectsResult(
          items: item != null ? [item] : [],
          pagination: pagination,
        );
      }
    }

    return AiAssistantQueryProjectsResult.empty();
  }

  static AiAssistantQueryPagination _paginationFromMeta(dynamic meta) {
    if (meta is! Map) {
      return AiAssistantQueryPagination.initial();
    }
    final m = meta is Map<String, dynamic>
        ? meta
        : Map<String, dynamic>.from(meta);
    final p = m['pagination'];
    if (p is! Map) {
      return AiAssistantQueryPagination.initial();
    }
    final pm = p is Map<String, dynamic> ? p : Map<String, dynamic>.from(p);
    return AiAssistantQueryPagination(
      page: _parseInt(pm['page']) ?? 1,
      pageSize: _parseInt(pm['page_size']) ?? 10,
      hasMore: pm['has_more'] == true,
      nextPage: _parseInt(pm['next_page']),
    );
  }

  static int? _parseInt(dynamic v) {
    if (v is int) return v;
    if (v is num) return v.toInt();
    if (v is String) return int.tryParse(v.trim());
    return null;
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

  static int? _parseIntId(dynamic v) => _parseInt(v);

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
