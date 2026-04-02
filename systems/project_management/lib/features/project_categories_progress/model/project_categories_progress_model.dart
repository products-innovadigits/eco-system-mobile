import 'package:project_management/core/utility/project_management_exports.dart';

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
    final raw = json['color'];
    if (raw is Color) {
      color = raw;
    } else if (raw is int) {
      color = Color(raw);
    } else if (raw is String && raw.isNotEmpty) {
      final hex = raw.replaceAll('#', '');
      color = Color(
        int.parse(hex.length == 6 ? 'ff$hex' : hex, radix: 16),
      );
    } else {
      color = null;
    }
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
