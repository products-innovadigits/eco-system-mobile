import 'package:core_package/core/model/meta.dart';
import 'package:pms_package/shared/pms_exports.dart';

class ProjectsModel extends SingleMapper {
  List<ProjectDetailsModel>? data;
  int? statusCode;
  String? message;
  Meta? meta;
  ProjectsModel({this.data, this.statusCode, this.meta, this.message});

  ProjectsModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null &&json['data'] is! String && json['data']["items"] != null) {
      data = [];
      json['data']["items"].forEach((v) {
        data!.add(ProjectDetailsModel.fromJson(v));
      });
    }
    statusCode = json['status_code'];
    meta = json['meta'] != null ? Meta.fromJson(json['meta']) : null;
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['status_code'] = statusCode;
    if (meta != null) {
      data['meta'] = meta!.toJson();
    }
    if (message != null) {
      data['message'] = message;
    }
    return data;
  }

  @override
  Mapper fromJson(Map<String, dynamic> json) {
    return ProjectsModel.fromJson(json);
  }
}
