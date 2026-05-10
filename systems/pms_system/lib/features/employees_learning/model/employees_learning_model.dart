import 'package:pms_system/core/utility/pms_exports.dart';

int? _jsonInt(dynamic value) {
  if (value == null) return null;
  if (value is int) return value;
  if (value is double) return value.round();
  if (value is String) return int.tryParse(value.trim());
  return null;
}

bool? _jsonBool(dynamic value) {
  if (value == null) return null;
  if (value is bool) return value;
  if (value is int) return value != 0;
  if (value is String) {
    final s = value.trim().toLowerCase();
    if (s == 'true' || s == '1' || s == 'yes') return true;
    if (s == 'false' || s == '0' || s == 'no') return false;
  }
  return null;
}

String? _jsonString(dynamic value) {
  if (value == null) return null;
  if (value is String) return value;
  return value.toString();
}

Map<String, dynamic>? _jsonMap(dynamic value) {
  if (value == null) return null;
  if (value is Map<String, dynamic>) return value;
  if (value is Map) return Map<String, dynamic>.from(value);
  return null;
}

class EmployeesLearningModel extends SingleMapper {
  bool? succeeded;
  EmployeesDataModel? data;
  int? status;
  dynamic warningErrors;
  List<dynamic>? validationErrors;

  EmployeesLearningModel({
    this.succeeded,
    this.data,
    this.status,
    this.warningErrors,
    this.validationErrors,
  });

  EmployeesLearningModel.fromJson(Map<String, dynamic> json) {
    status = _jsonInt(json['status']);
    succeeded = _jsonBool(json['succeeded']) ?? (status == 200);
    data = EmployeesDataModel.fromResponse(json);
    warningErrors = json['warningErrors'];
    final rawValidation = json['validationErrors'];
    validationErrors = rawValidation is List
        ? List<dynamic>.from(rawValidation)
        : null;
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['succeeded'] = succeeded;
    if (this.data != null) data['data'] = this.data!.toJson();
    data['status'] = status;
    data['warningErrors'] = warningErrors;
    if (validationErrors != null) data['validationErrors'] = validationErrors;
    return data;
  }

  @override
  Mapper fromJson(Map<String, dynamic> json) {
    return EmployeesLearningModel.fromJson(json);
  }
}

class EmployeesDataModel {
  List<EmployeeItemModel>? items;
  int? currentPage;
  int? pageSize;
  int? totalPages;
  int? nextPage;
  int? previousPage;
  bool? isLastPage;
  int? totalCount;

  EmployeesDataModel({
    this.items,
    this.currentPage,
    this.pageSize,
    this.totalPages,
    this.nextPage,
    this.previousPage,
    this.isLastPage,
    this.totalCount,
  });

  EmployeesDataModel.fromJson(Map<String, dynamic> json) {
    final rawItems = json['items'];
    if (rawItems is List) {
      items = <EmployeeItemModel>[];
      for (final v in rawItems) {
        final m = _jsonMap(v);
        if (m != null) {
          items!.add(EmployeeItemModel.fromJson(m));
        }
      }
    }
    currentPage = _jsonInt(json['currentPage']);
    pageSize = _jsonInt(json['pageSize']);
    totalPages = _jsonInt(json['totalPages']);
    nextPage = _jsonInt(json['nextPage']);
    previousPage = _jsonInt(json['previousPage']);
    isLastPage = _jsonBool(json['isLastPage']);
    totalCount = _jsonInt(json['totalCount']);
  }

  /// Supports legacy `{ data: { items, ... } }` and Laravel
  /// `{ data: [...], meta: { current_page, ... } }`.
  factory EmployeesDataModel.fromResponse(Map<String, dynamic> json) {
    final rawData = json['data'];
    final rawMeta = _jsonMap(json['meta']);

    if (rawData is Map<String, dynamic>) {
      return EmployeesDataModel.fromJson(rawData);
    }

    if (rawData is Map) {
      return EmployeesDataModel.fromJson(Map<String, dynamic>.from(rawData));
    }

    if (rawData is List) {
      final parsedItems = <EmployeeItemModel>[];
      for (final v in rawData) {
        final m = _jsonMap(v);
        if (m != null) {
          parsedItems.add(EmployeeItemModel.fromJson(m));
        }
      }
      return EmployeesDataModel(
        items: parsedItems,
        currentPage: _jsonInt(rawMeta?['current_page']),
        pageSize: _jsonInt(rawMeta?['per_page']),
        totalPages: _jsonInt(rawMeta?['last_page']),
        nextPage: _resolveNextPage(rawMeta),
        previousPage: _resolvePreviousPage(rawMeta),
        isLastPage: _resolveIsLastPage(rawMeta),
        totalCount: _jsonInt(rawMeta?['total']),
      );
    }

    return EmployeesDataModel();
  }

  static int? _resolveNextPage(Map<String, dynamic>? meta) {
    if (meta == null) return null;
    final current = _jsonInt(meta['current_page']);
    final last = _jsonInt(meta['last_page']);
    if (current == null || last == null) return null;
    return current < last ? current + 1 : null;
  }

  static int? _resolvePreviousPage(Map<String, dynamic>? meta) {
    if (meta == null) return null;
    final current = _jsonInt(meta['current_page']);
    if (current == null || current <= 1) return null;
    return current - 1;
  }

  static bool? _resolveIsLastPage(Map<String, dynamic>? meta) {
    if (meta == null) return null;
    final current = _jsonInt(meta['current_page']);
    final last = _jsonInt(meta['last_page']);
    if (current == null || last == null) return null;
    return current >= last;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (items != null) data['items'] = items!.map((v) => v.toJson()).toList();
    data['currentPage'] = currentPage;
    data['pageSize'] = pageSize;
    data['totalPages'] = totalPages;
    data['nextPage'] = nextPage;
    data['previousPage'] = previousPage;
    data['isLastPage'] = isLastPage;
    data['totalCount'] = totalCount;
    return data;
  }
}

class EmployeeItemModel {
  int? id;
  String? name;
  String? jobTitle;
  String? email;
  String? phone;
  String? seniority;
  String? team;
  String? imageUrl;
  String? initials;

  EmployeeItemModel({
    this.id,
    this.name,
    this.jobTitle,
    this.email,
    this.phone,
    this.seniority,
    this.team,
    this.imageUrl,
    this.initials,
  });

  EmployeeItemModel.fromJson(Map<String, dynamic> json) {
    id = _jsonInt(json['id']);
    name = _jsonString(json['name']);
    jobTitle =
        _jsonString(json['jobTitle']) ?? _jsonString(json['role_name']);
    email = _jsonString(json['email']);
    phone = _jsonString(json['phone']);
    seniority =
        _jsonString(json['seniority']) ?? _jsonString(json['seniority_level']);
    team = _jsonString(json['team']);
    imageUrl =
        _jsonString(json['imageUrl']) ?? _jsonString(json['profile_photo']);
    initials =
        _jsonString(json['initials']) ?? initialsFromEmployeeName(name);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['jobTitle'] = jobTitle;
    data['email'] = email;
    data['phone'] = phone;
    data['seniority'] = seniority;
    data['team'] = team;
    data['imageUrl'] = imageUrl;
    data['initials'] = initials;
    return data;
  }
}

/// Builds initials for avatar fallback when API does not send [initials].
String? initialsFromEmployeeName(String? name) {
  if (name == null || name.trim().isEmpty) return null;
  final parts = name
      .trim()
      .split(RegExp(r'\s+'))
      .where((p) => p.isNotEmpty)
      .toList();
  if (parts.isEmpty) return null;
  String firstChar(String s) {
    if (s.isEmpty) return '';
    final i = s.runes.first;
    return String.fromCharCode(i);
  }

  if (parts.length >= 2) {
    return '${firstChar(parts[0])}${firstChar(parts[1])}'.toUpperCase();
  }
  final first = parts[0];
  if (first.length >= 2) {
    return first.substring(0, 2).toUpperCase();
  }
  return first.toUpperCase();
}
