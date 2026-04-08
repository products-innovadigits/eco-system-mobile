import 'package:pms_system/core/utility/pms_exports.dart';

class EmployeeOfMonthHistoryModel extends SingleMapper {
  bool? succeeded;
  EmployeeOfMonthHistoryDataModel? data;
  int? status;
  dynamic warningErrors;
  List<dynamic>? validationErrors;

  EmployeeOfMonthHistoryModel({
    this.succeeded,
    this.data,
    this.status,
    this.warningErrors,
    this.validationErrors,
  });

  EmployeeOfMonthHistoryModel.fromJson(Map<String, dynamic> json) {
    status = json['status'] is int ? json['status'] as int : null;
    succeeded = json['succeeded'] ?? (status == 200);
    data = EmployeeOfMonthHistoryDataModel.fromResponse(json);
    warningErrors = json['warningErrors'];
    validationErrors = json['validationErrors'] != null
        ? List<dynamic>.from(json['validationErrors'])
        : null;
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> map = <String, dynamic>{};
    map['succeeded'] = succeeded;
    if (data != null) map['data'] = data!.toJson();
    map['status'] = status;
    map['warningErrors'] = warningErrors;
    if (validationErrors != null) map['validationErrors'] = validationErrors;
    return map;
  }

  @override
  Mapper fromJson(Map<String, dynamic> json) {
    return EmployeeOfMonthHistoryModel.fromJson(json);
  }
}

class EmployeeOfMonthHistoryDataModel {
  List<EmployeeOfMonthHistoryItemModel>? items;
  int? currentPage;
  int? pageSize;
  int? totalPages;
  int? nextPage;
  int? previousPage;
  bool? isLastPage;
  int? totalCount;

  EmployeeOfMonthHistoryDataModel({
    this.items,
    this.currentPage,
    this.pageSize,
    this.totalPages,
    this.nextPage,
    this.previousPage,
    this.isLastPage,
    this.totalCount,
  });

  EmployeeOfMonthHistoryDataModel.fromJson(Map<String, dynamic> json) {
    if (json['items'] != null) {
      items = <EmployeeOfMonthHistoryItemModel>[];
      json['items'].forEach((v) {
        items!.add(EmployeeOfMonthHistoryItemModel.fromJson(v));
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

  factory EmployeeOfMonthHistoryDataModel.fromResponse(
    Map<String, dynamic> json,
  ) {
    final rawData = json['data'];
    final rawMeta = json['meta'] as Map<String, dynamic>?;

    if (rawData is Map<String, dynamic>) {
      return EmployeeOfMonthHistoryDataModel.fromJson(rawData);
    }

    if (rawData is List) {
      final items = rawData
          .whereType<Map<String, dynamic>>()
          .map(EmployeeOfMonthHistoryItemModel.fromJson)
          .toList();
      return EmployeeOfMonthHistoryDataModel(
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

    return EmployeeOfMonthHistoryDataModel();
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
    final Map<String, dynamic> map = <String, dynamic>{};
    if (items != null) {
      map['items'] = items!.map((v) => v.toJson()).toList();
    }
    map['currentPage'] = currentPage;
    map['pageSize'] = pageSize;
    map['totalPages'] = totalPages;
    map['nextPage'] = nextPage;
    map['previousPage'] = previousPage;
    map['isLastPage'] = isLastPage;
    map['totalCount'] = totalCount;
    return map;
  }
}

class EmployeeOfMonthHistoryItemModel {
  String? name;
  String? email;
  String? jobTitle;
  String? month;
  String? year;
  String? score;
  double? percentage;

  EmployeeOfMonthHistoryItemModel({
    this.name,
    this.email,
    this.jobTitle,
    this.month,
    this.year,
    this.score,
    this.percentage,
  });

  EmployeeOfMonthHistoryItemModel.fromJson(Map<String, dynamic> json) {
    name = json['name'] as String?;
    email = json['email'] as String?;
    jobTitle = json['job_title'] as String?;
    month = json['month'] as String?;
    final rawYear = json['year'];
    year = rawYear?.toString();
    final rawScore = json['score'];
    score = rawScore?.toString();
    percentage = (json['percentage'] as num?)?.toDouble();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> map = <String, dynamic>{};
    map['name'] = name;
    map['email'] = email;
    map['job_title'] = jobTitle;
    map['month'] = month;
    map['year'] = year;
    map['score'] = score;
    map['percentage'] = percentage;
    return map;
  }
}
