import 'package:core_package/core/utility/export.dart';

class ProjectCategoriesProgressModel extends SingleMapper {
  int? id;
  String? name;
  double? progress;

  ProjectCategoriesProgressModel({this.id, this.name, this.progress});

  ProjectCategoriesProgressModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    progress = json['progress'];
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['progress'] = progress;
    return data;
  }

  @override
  Mapper fromJson(Map<String, dynamic> json) {
    return ProjectCategoriesProgressModel.fromJson(json);
  }
}
