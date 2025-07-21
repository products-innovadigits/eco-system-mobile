import 'package:core_package/core/utility/export.dart';

class ProjectProgressModel extends SingleMapper {
  String? categoryName;
  double? value;
  int? count;
  String? color;

  ProjectProgressModel({this.categoryName, this.value , this.color , this.count});

  ProjectProgressModel.fromJson(Map<String, dynamic> json) {
    categoryName = json['categoryName'];
    value = json['value'];
    count = json['count'];
    color = json['color'];
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['categoryName'] = categoryName;
    data['value'] = value;
    data['count'] = count;
    data['color'] = color; // Store color as an integer value
    return data;
  }

  @override
  Mapper fromJson(Map<String, dynamic> json) {
    return ProjectProgressModel.fromJson(json);
  }
}
