import 'package:project_management/core/utility/pms_exports.dart';

class ProjectCategoriesProgressModel extends SingleMapper {
  int? id;
  String? name;
  double? progress;
  Color? color;

  ProjectCategoriesProgressModel({
    this.id,
    this.name,
    this.progress,
    this.color,
  });

  ProjectCategoriesProgressModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    progress = (json['progress'] is! double) ? 0.0 : json['progress'];
    color = json['color'];
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['progress'] = progress;
    data['color'] = color;
    return data;
  }

  @override
  Mapper fromJson(Map<String, dynamic> json) {
    return ProjectCategoriesProgressModel.fromJson(json);
  }
}
