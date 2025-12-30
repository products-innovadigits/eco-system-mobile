import 'package:pms_system/core/utility/pms_exports.dart';

class ProjectsModel extends SingleMapper {
  bool? succeeded;
  ProjectsDataModel? data;
  dynamic warningErrors;
  List<dynamic>? validationErrors;

  ProjectsModel({
    this.succeeded,
    this.data,
    this.warningErrors,
    this.validationErrors,
  });

  ProjectsModel.fromJson(Map<String, dynamic> json) {
    succeeded = json['succeeded'];
    data = json['data'] != null
        ? ProjectsDataModel.fromJson(json['data'])
        : null;
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
    return ProjectsModel.fromJson(json);
  }
}

class ProjectsDataModel {
  List<ProjectDetailsModel>? items;
  int? currentPage;
  int? pageSize;
  int? totalPages;
  int? nextPage;
  int? previousPage;
  bool? isLastPage;
  int? totalCount;

  ProjectsDataModel({
    this.items,
    this.currentPage,
    this.pageSize,
    this.totalPages,
    this.nextPage,
    this.previousPage,
    this.isLastPage,
    this.totalCount,
  });

  ProjectsDataModel.fromJson(Map<String, dynamic> json) {
    if (json['items'] != null) {
      items = <ProjectDetailsModel>[];
      json['items'].forEach((v) {
        items!.add(ProjectDetailsModel.fromJson(v));
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
