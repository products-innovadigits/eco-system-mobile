import 'package:core_system/core/network/network_layer.dart';
import 'package:dio/dio.dart';
import 'package:project_management/features/ai_assistant/domain/repositories/ai_assistant_repo.dart';
import 'package:project_management/features/project_details/model/project_details_model.dart';

class AiAssistantRepoImpl implements AiAssistantRepo {
  /// Local / dev AI query service (same host as user-provided endpoint).
  static const String _queryBaseUrl = 'http://172.16.1.61:8000';
  static const String _queryPath = '/projects/query';

  final Network network;

  AiAssistantRepoImpl({required this.network});

  @override
  Future<List<ProjectDetailsDataModel>> queryProjects(String query) async {
    final raw = await network.requestOrThrow(
      _queryPath,
      baseUrl: _queryBaseUrl,
      body: {'query': query},
      method: ServerMethods.POST,
      model: null,
    );
    final data = raw is Response ? raw.data : raw;
    return _parseProjectsList(data);
  }

  static List<ProjectDetailsDataModel> _parseProjectsList(dynamic data) {
    if (data == null) return [];

    if (data is List) {
      return data.map(_projectFromDynamic).whereType<ProjectDetailsDataModel>().toList();
    }

    if (data is Map) {
      final map = Map<String, dynamic>.from(data);

      if (map['data'] != null) {
        return _parseProjectsList(map['data']);
      }
      if (map['items'] != null) {
        return _parseProjectsList(map['items']);
      }
      if (map['projects'] != null) {
        return _parseProjectsList(map['projects']);
      }
      if (map['results'] != null) {
        return _parseProjectsList(map['results']);
      }

      if (map['id'] != null) {
        final p = _projectFromDynamic(map);
        return p != null ? [p] : [];
      }
    }

    return [];
  }

  static ProjectDetailsDataModel? _projectFromDynamic(dynamic e) {
    if (e is! Map) return null;
    final m = e is Map<String, dynamic> ? e : Map<String, dynamic>.from(e);
    try {
      return ProjectDetailsDataModel.fromJson(_normalizeAiQueryProjectMap(m));
    } catch (_) {
      return null;
    }
  }

  /// Maps legacy / alternate AI `/projects/query` item keys onto names [ProjectDetailsDataModel.fromJson] expects.
  ///
  /// Canonical API shape (camelCase) is parsed directly in the model; this layer only fills gaps for older payloads (`name`, `start_date`, `risk`, etc.).
  static Map<String, dynamic> _normalizeAiQueryProjectMap(Map<String, dynamic> json) {
    final out = Map<String, dynamic>.from(json);

    if (out['title'] == null && out['name'] != null) {
      out['title'] = out['name'];
    }

    if (out['riskLevelName'] == null && out['risk'] != null) {
      out['riskLevelName'] = out['risk'];
    }

    if (out['periortyLevelName'] == null && out['priority'] != null) {
      out['periortyLevelName'] = out['priority'];
    }
    if (out['priorityLevelName'] == null && out['priority'] != null) {
      out['priorityLevelName'] = out['priority'];
    }

    if (out['startDate'] == null && out['start_date'] != null) {
      out['startDate'] = _coerceDateString(out['start_date']);
    }
    if (out['endDate'] == null && out['end_date'] != null) {
      out['endDate'] = _coerceDateString(out['end_date']);
    }

    if (out['deliveredOutputs'] == null && out['deliveredOutputCount'] != null) {
      out['deliveredOutputs'] = out['deliveredOutputCount'];
    }

    if (out['progress'] == null &&
        out['progressRation'] == null &&
        out['progressRatio'] == null) {
      out['progressRation'] = 0;
    }

    if (out['statusAr'] == null && out['status'] != null) {
      out['statusAr'] = out['status'];
    }

    return out;
  }

  static String _coerceDateString(dynamic value) {
    if (value is! String) return value.toString();
    final trimmed = value.trim();
    if (trimmed.contains(' ') && !trimmed.contains('T')) {
      return trimmed.replaceFirst(' ', 'T');
    }
    return trimmed;
  }
}
