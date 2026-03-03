import 'package:pms_system/core/utility/pms_exports.dart';

class EmployeesLearningModel extends SingleMapper {
  bool? succeeded;
  EmployeesDataModel? data;
  dynamic warningErrors;
  List<dynamic>? validationErrors;

  EmployeesLearningModel({
    this.succeeded,
    this.data,
    this.warningErrors,
    this.validationErrors,
  });

  EmployeesLearningModel.fromJson(Map<String, dynamic> json) {
    succeeded = json['succeeded'];
    data = json['data'] != null
        ? EmployeesDataModel.fromJson(json['data'])
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
    if (this.data != null) data['data'] = this.data!.toJson();
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
    jobTitle = json['jobTitle'];
    email = json['email'];
    phone = json['phone'];
    seniority = json['seniority'];
    team = json['team'];
    imageUrl = json['imageUrl'];
    initials = json['initials'];
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
