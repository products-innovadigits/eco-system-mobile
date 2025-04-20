import '../../../network/mapper.dart';

class ProjectProgressModel extends SingleMapper {
  int? id;
  String? name;
  double? progress;

  ProjectProgressModel({this.id, this.name, this.progress});

  ProjectProgressModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    progress = json['progress'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['progress'] = this.progress;
    return data;
  }

  @override
  Mapper fromJson(Map<String, dynamic> json) {
    return ProjectProgressModel.fromJson(json);
  }
}
