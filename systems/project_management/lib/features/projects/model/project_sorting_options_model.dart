import 'package:core_system/core/network/mapper.dart';

class ProjectSortingOptionsModel extends SingleMapper {
  bool? succeeded;
  List<ProjectSortingOptionModel>? data;
  dynamic warningErrors;
  List<dynamic>? validationErrors;

  ProjectSortingOptionsModel({
    this.succeeded,
    this.data,
    this.warningErrors,
    this.validationErrors,
  });

  ProjectSortingOptionsModel.fromJson(Map<String, dynamic> json) {
    succeeded = json['succeeded'];
    if (json['data'] != null) {
      data = <ProjectSortingOptionModel>[];
      json['data'].forEach((v) {
        data!.add(
          ProjectSortingOptionModel.fromJson(v as Map<String, dynamic>),
        );
      });
    }
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
    return ProjectSortingOptionsModel.fromJson(json);
  }
}

class ProjectSortingOptionModel {
  int? id;
  String? nameAr;
  String? nameEn;

  ProjectSortingOptionModel({this.id, this.nameAr, this.nameEn});

  ProjectSortingOptionModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    nameAr = json['nameAr'];
    nameEn = json['nameEn'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['nameAr'] = nameAr;
    data['nameEn'] = nameEn;
    return data;
  }
}
