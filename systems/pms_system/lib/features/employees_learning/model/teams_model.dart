import 'package:pms_system/core/utility/pms_exports.dart';

class TeamsModel extends SingleMapper {
  bool? succeeded;
  List<TeamItemModel>? data;
  String? message;
  int? status;

  TeamsModel({this.succeeded, this.data, this.message, this.status});

  TeamsModel.fromJson(Map<String, dynamic> json) {
    status = json['status'] is int ? json['status'] as int : null;
    succeeded = json['succeeded'] ?? (status == 200);
    message = json['message'];
    final rawData = json['data'];
    if (rawData is List) {
      data = rawData
          .whereType<Map<String, dynamic>>()
          .map(TeamItemModel.fromJson)
          .toList();
    }
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = <String, dynamic>{};
    json['succeeded'] = succeeded;
    if (data != null) json['data'] = data!.map((v) => v.toJson()).toList();
    json['message'] = message;
    json['status'] = status;
    return json;
  }

  @override
  Mapper fromJson(Map<String, dynamic> json) {
    return TeamsModel.fromJson(json);
  }
}

class TeamItemModel {
  int? id;
  String? name;
  String? color;

  TeamItemModel({this.id, this.name, this.color});

  TeamItemModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    color = json['color'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['color'] = color;
    return data;
  }
}
