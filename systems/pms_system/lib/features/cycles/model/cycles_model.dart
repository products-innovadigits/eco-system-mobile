import 'package:pms_system/core/utility/pms_exports.dart';

class CyclesModel extends SingleMapper {
  bool? succeeded;
  CyclesDataModel? data;
  CyclesLinksModel? links;
  CyclesMetaModel? meta;
  int? status;
  dynamic warningErrors;
  List<dynamic>? validationErrors;

  CyclesModel({
    this.succeeded,
    this.data,
    this.links,
    this.meta,
    this.status,
    this.warningErrors,
    this.validationErrors,
  });

  CyclesModel.fromJson(Map<String, dynamic> json) {
    succeeded = json['succeeded'] ?? (json['status'] == 200);
    data = CyclesDataModel.fromResponse(json);
    links = json['links'] != null
        ? CyclesLinksModel.fromJson(json['links'] as Map<String, dynamic>)
        : null;
    meta = json['meta'] != null
        ? CyclesMetaModel.fromJson(json['meta'] as Map<String, dynamic>)
        : null;
    status = json['status'];
    warningErrors = json['warningErrors'];
    validationErrors = json['validationErrors'] != null
        ? List<dynamic>.from(json['validationErrors'])
        : null;
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['succeeded'] = succeeded;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    if (links != null) {
      data['links'] = links!.toJson();
    }
    if (meta != null) {
      data['meta'] = meta!.toJson();
    }
    data['status'] = status;
    data['warningErrors'] = warningErrors;
    if (validationErrors != null) {
      data['validationErrors'] = validationErrors;
    }
    return data;
  }

  @override
  Mapper fromJson(Map<String, dynamic> json) {
    return CyclesModel.fromJson(json);
  }
}

class CyclesDataModel {
  List<CycleItemModel>? items;
  int? currentPage;
  int? pageSize;
  int? totalPages;
  int? nextPage;
  int? previousPage;
  bool? isLastPage;
  int? totalCount;

  CyclesDataModel({
    this.items,
    this.currentPage,
    this.pageSize,
    this.totalPages,
    this.nextPage,
    this.previousPage,
    this.isLastPage,
    this.totalCount,
  });

  CyclesDataModel.fromJson(Map<String, dynamic> json) {
    if (json['items'] != null) {
      items = <CycleItemModel>[];
      json['items'].forEach((v) {
        items!.add(CycleItemModel.fromJson(v));
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

  factory CyclesDataModel.fromResponse(Map<String, dynamic> json) {
    final rawData = json['data'];
    final rawMeta = json['meta'] as Map<String, dynamic>?;

    if (rawData is Map<String, dynamic>) {
      return CyclesDataModel.fromJson(rawData);
    }

    if (rawData is List) {
      final items = rawData
          .whereType<Map<String, dynamic>>()
          .map(CycleItemModel.fromJson)
          .toList();
      return CyclesDataModel(
        items: items,
        currentPage: rawMeta?['current_page'],
        pageSize: rawMeta?['per_page'],
        totalPages: rawMeta?['last_page'],
        nextPage: _resolveNextPage(rawMeta),
        previousPage: _resolvePreviousPage(rawMeta),
        isLastPage: _resolveIsLastPage(rawMeta),
        totalCount: rawMeta?['total'],
      );
    }

    return CyclesDataModel();
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
    if (items != null) {
      data['items'] = items!.map((v) => v.toJson()).toList();
    }
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

class CycleItemModel {
  int? id;
  String? title;
  String? status;
  String? dueDate;
  List<CycleAssigneeModel>? assignees;
  List<CycleReviewModel>? reviews;

  CycleItemModel({
    this.id,
    this.title,
    this.status,
    this.dueDate,
    this.assignees,
    this.reviews,
  });

  CycleItemModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'] ?? json['name'];
    status = _mapStateToStatus(json['status'] ?? json['state']);
    dueDate = json['dueDate'] ?? json['start_date'];
    if (json['assignees'] != null || json['owners'] != null) {
      final rawAssignees = (json['assignees'] ?? json['owners']) as List?;
      assignees = <CycleAssigneeModel>[];
      rawAssignees?.forEach((v) {
        if (v is Map<String, dynamic>) {
          assignees!.add(CycleAssigneeModel.fromJson(v));
        }
      });
    }
    reviews = _reviewsFromJson(json);
  }

  static String? _mapStateToStatus(dynamic rawState) {
    final state = (rawState ?? '').toString().trim().toLowerCase();
    switch (state) {
      case 'active':
        return 'Active';
      case 'completed':
        return 'Completed';
      case 'canceled':
        return 'Canceled';
      case 'not started':
        return 'Not Started';
      default:
        return rawState?.toString();
    }
  }

  static List<CycleReviewModel> _reviewsFromJson(Map<String, dynamic> json) {
    if (json['reviews'] is List) {
      return (json['reviews'] as List)
          .whereType<Map<String, dynamic>>()
          .map(CycleReviewModel.fromJson)
          .toList();
    }

    return <CycleReviewModel>[
      CycleReviewModel(
        name: 'Manager Review',
        percentage: (json['manager_progress'] as num?)?.toDouble() ?? 0,
      ),
      CycleReviewModel(
        name: 'Direct Report Review',
        percentage: (json['direct_report_progress'] as num?)?.toDouble() ?? 0,
      ),
      CycleReviewModel(
        name: 'Peer Review',
        percentage: (json['peer_progress'] as num?)?.toDouble() ?? 0,
      ),
    ];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['status'] = status;
    data['dueDate'] = dueDate;
    if (assignees != null) {
      data['assignees'] = assignees!.map((v) => v.toJson()).toList();
    }
    if (reviews != null) {
      data['reviews'] = reviews!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class CycleAssigneeModel {
  int? id;
  String? name;
  String? jobTitle;
  String? imageUrl;

  CycleAssigneeModel({this.id, this.name, this.jobTitle, this.imageUrl});

  CycleAssigneeModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    jobTitle = json['jobTitle'] ?? json['job_title'];
    imageUrl = json['imageUrl'] ?? json['profile_photo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['jobTitle'] = jobTitle;
    data['imageUrl'] = imageUrl;
    return data;
  }
}

class CycleReviewModel {
  String? name;
  double? percentage;

  CycleReviewModel({this.name, this.percentage});

  CycleReviewModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    percentage = (json['percentage'] as num?)?.toDouble();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['percentage'] = percentage;
    return data;
  }
}

class CyclesLinksModel {
  String? first;
  String? last;
  String? prev;
  String? next;

  CyclesLinksModel({this.first, this.last, this.prev, this.next});

  CyclesLinksModel.fromJson(Map<String, dynamic> json) {
    first = json['first'];
    last = json['last'];
    prev = json['prev'];
    next = json['next'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['first'] = first;
    data['last'] = last;
    data['prev'] = prev;
    data['next'] = next;
    return data;
  }
}

class CyclesMetaModel {
  int? currentPage;
  int? from;
  int? lastPage;
  int? perPage;
  int? to;
  int? total;
  String? path;

  CyclesMetaModel({
    this.currentPage,
    this.from,
    this.lastPage,
    this.perPage,
    this.to,
    this.total,
    this.path,
  });

  CyclesMetaModel.fromJson(Map<String, dynamic> json) {
    currentPage = json['current_page'];
    from = json['from'];
    lastPage = json['last_page'];
    perPage = json['per_page'];
    to = json['to'];
    total = json['total'];
    path = json['path'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['current_page'] = currentPage;
    data['from'] = from;
    data['last_page'] = lastPage;
    data['per_page'] = perPage;
    data['to'] = to;
    data['total'] = total;
    data['path'] = path;
    return data;
  }
}
