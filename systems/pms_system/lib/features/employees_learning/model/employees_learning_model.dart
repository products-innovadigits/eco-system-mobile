import 'package:pms_system/core/utility/pms_exports.dart';

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
    status = json['status'] is int ? json['status'] as int : null;
    succeeded = json['succeeded'] ?? (status == 200);
    data = EmployeesDataModel.fromResponse(json);
    warningErrors = json['warningErrors'];
    validationErrors = json['validationErrors'] != null
        ? List<dynamic>.from(json['validationErrors'])
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
    if (json['items'] != null) {
      items = <EmployeeItemModel>[];
      json['items'].forEach((v) {
        items!.add(EmployeeItemModel.fromJson(v));
      });
    }
    currentPage = json['currentPage'];
    pageSize = json['pageSize'];
    totalPages = json['totalPages'];
    nextPage = json['nextPage'];
    previousPage = json['previousPage'];
    isLastPage = json['isLastPage'];
    totalCount = json['totalCount'];
  }

  /// Supports legacy `{ data: { items, ... } }` and Laravel
  /// `{ data: [...], meta: { current_page, ... } }`.
  factory EmployeesDataModel.fromResponse(Map<String, dynamic> json) {
    final rawData = json['data'];
    final rawMeta = json['meta'] as Map<String, dynamic>?;

    if (rawData is Map<String, dynamic>) {
      return EmployeesDataModel.fromJson(rawData);
    }

    if (rawData is List) {
      final items = rawData
          .whereType<Map<String, dynamic>>()
          .map(EmployeeItemModel.fromJson)
          .toList();
      return EmployeesDataModel(
        items: items,
        currentPage: rawMeta?['current_page'] as int?,
        pageSize: rawMeta?['per_page'] as int?,
        totalPages: rawMeta?['last_page'] as int?,
        nextPage: _resolveNextPage(rawMeta),
        previousPage: _resolvePreviousPage(rawMeta),
        isLastPage: _resolveIsLastPage(rawMeta),
        totalCount: rawMeta?['total'] as int?,
      );
    }

    return EmployeesDataModel();
  }

  static int? _resolveNextPage(Map<String, dynamic>? meta) {
    if (meta == null) return null;
    final current = meta['current_page'] as int?;
    final last = meta['last_page'] as int?;
    if (current == null || last == null) return null;
    return current < last ? current + 1 : null;
  }

  static int? _resolvePreviousPage(Map<String, dynamic>? meta) {
    if (meta == null) return null;
    final current = meta['current_page'] as int?;
    if (current == null || current <= 1) return null;
    return current - 1;
  }

  static bool? _resolveIsLastPage(Map<String, dynamic>? meta) {
    if (meta == null) return null;
    final current = meta['current_page'] as int?;
    final last = meta['last_page'] as int?;
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
    id = json['id'];
    name = json['name'];
    jobTitle = json['jobTitle'] as String? ?? json['role_name'] as String?;
    email = json['email'];
    final rawPhone = json['phone'];
    phone = rawPhone?.toString();
    seniority =
        json['seniority'] as String? ?? json['seniority_level'] as String?;
    team = json['team'];
    imageUrl = json['imageUrl'] as String? ?? json['profile_photo'] as String?;
    initials = json['initials'] as String? ?? initialsFromEmployeeName(name);
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
