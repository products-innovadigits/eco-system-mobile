import 'package:core_system/core/network/mapper.dart';

class ProjectsFiltersModel extends SingleMapper {
  bool? succeeded;
  List<ProjectSortModel>? data;
  dynamic warningErrors;
  List<dynamic>? validationErrors;

  ProjectsFiltersModel({
    this.succeeded,
    this.data,
    this.warningErrors,
    this.validationErrors,
  });

  ProjectsFiltersModel.fromJson(Map<String, dynamic> json) {
    succeeded = json['succeeded'];
    data = json['data']?.map((v) => ProjectSortModel.fromJson(v)).toList();
    warningErrors = json['warningErrors'];
    if (json['validationErrors'] != null) {
      validationErrors = <dynamic>[];
      json['validationErrors'].forEach((v) {
        validationErrors!.add(v);
      });
    }
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['succeeded'] = succeeded;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['warningErrors'] = warningErrors;
    if (validationErrors != null) {
      data['validationErrors'] = validationErrors!.map((v) => v).toList();
    }
    return data;
  }

  @override
  Mapper fromJson(Map<String, dynamic> json) {
    return ProjectsFiltersModel.fromJson(json);
  }
}

class ProjectSortModel {
  String? name;
  int? id;

  ProjectSortModel({this.name, this.id});

  ProjectSortModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['id'] = id;
    return data;
  }
}
