import 'dart:convert';

import 'package:core_system/core/network/network_layer.dart';
import 'package:core_system/core/utility/utility.dart';
import 'package:dio/dio.dart';
import 'package:project_management/features/ai_assistant/domain/repositories/ai_assistant_repo.dart';
import 'package:project_management/features/ai_assistant/exceptions/ai_assistant_query_exception.dart';
import 'package:project_management/features/ai_assistant/model/ai_assistant_models.dart';

class AiAssistantRepoImpl implements AiAssistantRepo {
  /// Test / staging tunnel — change here when the host rotates (not read from `.env`).
  /// Full POST URL: https://strange-wrapping-composition-sent.trycloudflare.com/projects/query
  static const String _queryBaseUrl =
      'https://kinda-doctor-caroline-james.trycloudflare.com /';

  static const String _queryPath = 'projects/query';

  final Network network;

  AiAssistantRepoImpl({required this.network});

  @override
  Future<AiAssistantQueryProjectsResult> queryProjects(String query) async {
    try {
      final raw = await network.requestOrThrow(
        _queryPath,
        baseUrl: _queryBaseUrl,
        body: {'query': query},
        method: ServerMethods.POST,
        model: null,
      );
      final data = raw is Response ? raw.data : raw;
      _logQueryResponse(data);
      _throwIfQueryFailed(data);
      return _parseQueryProjectsResult(data);
    } catch (e, stackTrace) {
      _logQueryError(e, stackTrace);
      rethrow;
    }
  }

  static void _logQueryResponse(dynamic data) {
    try {
      if (data is Map || data is List) {
        cprint(jsonEncode(data), label: 'AiAssistantQuery response');
      } else {
        cprint(data?.toString() ?? 'null', label: 'AiAssistantQuery response');
      }
    } catch (_) {
      cprint(data?.toString() ?? 'null', label: 'AiAssistantQuery response');
    }
  }

  static void _logQueryError(Object error, StackTrace stackTrace) {
    cprint(error, errorIn: stackTrace.toString(), label: 'AiAssistantQuery');
  }

  /// When the server returns HTTP 200 with a failure envelope (`success: false`, non-success `status`, etc.).
  static void _throwIfQueryFailed(dynamic data) {
    if (data is! Map) return;
    final map = data is Map<String, dynamic>
        ? data
        : Map<String, dynamic>.from(data);
    if (!_indicatesQueryFailure(map)) return;

    final msg = _extractResponseMessage(map);
    throw AiAssistantQueryException(
      (msg != null && msg.isNotEmpty) ? msg : 'Request failed',
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

      if (map['data'] != null) {
        final inner = map['data'];
        if (inner is List) {
          return AiAssistantQueryProjectsResult(
            items: inner
                .map((e) => _itemFromDynamic(e, columnOrder))
                .whereType<AiAssistantQueryItem>()
                .toList(),
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
