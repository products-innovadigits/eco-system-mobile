import 'package:pms_system/core/utility/pms_exports.dart';

class SeniorityLevelsModel extends SingleMapper {
  bool? succeeded;
  List<SeniorityLevelItemModel>? data;
  int? status;

  SeniorityLevelsModel({this.succeeded, this.data, this.status});

  SeniorityLevelsModel.fromJson(Map<String, dynamic> json) {
    status = json['status'] is int ? json['status'] as int : null;
    succeeded = json['succeeded'] ?? (status == 200);
    final rawData = json['data'];
    if (rawData is List) {
      data = rawData
          .whereType<Map<String, dynamic>>()
          .map(SeniorityLevelItemModel.fromJson)
          .toList();
    }
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = <String, dynamic>{};
    json['succeeded'] = succeeded;
    if (data != null) json['data'] = data!.map((v) => v.toJson()).toList();
    json['status'] = status;
    return json;
  }

  @override
  Mapper fromJson(Map<String, dynamic> json) {
    return SeniorityLevelsModel.fromJson(json);
  }
}

class SeniorityLevelItemModel {
  int? id;
  String? name;
  int? sortOrder;

  SeniorityLevelItemModel({this.id, this.name, this.sortOrder});

  SeniorityLevelItemModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    sortOrder = json['sort_order'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['sort_order'] = sortOrder;
    return data;
  }
}
