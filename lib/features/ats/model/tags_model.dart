import 'package:eco_system/utility/export.dart';

class TagsModel extends SingleMapper {
  List<TagDataModel>? data;

  TagsModel({this.data});

  TagsModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data!.add(TagDataModel.fromJson(v));
      });
    }
  }

  @override
  Mapper fromJson(Map<String, dynamic> json) {
    return TagsModel.fromJson(json);
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    if (this.data != null) {
      data['data'] = this.data!.map((e) => e.toJson()).toList();
    }
    return data;
  }
}

class TagDataModel extends SingleMapper {
  String? value;
  String? label;

  TagDataModel({this.value, this.label});

  TagDataModel.fromJson(Map<String, dynamic> json) {
    value = json['value'];
    label = json['label'];
  }

  @override
  Mapper fromJson(Map<String, dynamic> json) {
    return TagDataModel.fromJson(json);
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['value'] = value;
    data['label'] = label;
    return data;
  }
}
