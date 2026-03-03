import 'package:pms_system/core/utility/pms_exports.dart';

class CyclesModel extends SingleMapper {
  bool? succeeded;
  CyclesDataModel? data;
  dynamic warningErrors;
  List<dynamic>? validationErrors;

  CyclesModel({
    this.succeeded,
    this.data,
    this.warningErrors,
    this.validationErrors,
  });

  CyclesModel.fromJson(Map<String, dynamic> json) {
    succeeded = json['succeeded'];
    data =
        json['data'] != null ? CyclesDataModel.fromJson(json['data']) : null;
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
    title = json['title'];
    status = json['status'];
    dueDate = json['dueDate'];
    if (json['assignees'] != null) {
      assignees = <CycleAssigneeModel>[];
      json['assignees'].forEach((v) {
        assignees!.add(CycleAssigneeModel.fromJson(v));
      });
    }
    if (json['reviews'] != null) {
      reviews = <CycleReviewModel>[];
      json['reviews'].forEach((v) {
        reviews!.add(CycleReviewModel.fromJson(v));
      });
    }
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
  String? imageUrl;

  CycleAssigneeModel({this.id, this.name, this.imageUrl});

  CycleAssigneeModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    imageUrl = json['imageUrl'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
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
