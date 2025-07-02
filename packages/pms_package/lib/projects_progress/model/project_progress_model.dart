import 'package:core_package/core/utility/export.dart';

class ProjectProgressModel extends SingleMapper {
  String? categoryName;
  double? value;

  ProjectProgressModel({this.categoryName, this.value});

  ProjectProgressModel.fromJson(Map<String, dynamic> json) {
    categoryName = json['categoryName'];
    value = json['value'];
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['categoryName'] = categoryName;
    data['value'] = value;
    return data;
  }

  @override
  Mapper fromJson(Map<String, dynamic> json) {
    return ProjectProgressModel.fromJson(json);
  }
}
