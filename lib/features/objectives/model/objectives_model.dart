import '../../../model/meta.dart';
import '../../../network/mapper.dart';

class ObjectivesModel extends SingleMapper {
  List<ObjectiveModel>? data;
  int? statusCode;
  String? message;
  Meta? meta;

  ObjectivesModel({this.data, this.statusCode, this.meta, this.message});

  ObjectivesModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null && json['data']["items"] != null) {
      data = [];
      json['data']["items"].forEach((v) {
        data!.add(ObjectiveModel.fromJson(v));
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
    return ObjectivesModel.fromJson(json);
  }
}

class ObjectiveModel {
  int? id;
  String? title;
  String? description;
  int? weightScaleLookUpId;
  double? weight;
  List<String>? subObjectActives;
  String? startDate;
  String? endDate;
  int? strategicAxisId;
  int? manzorId;
  int? visionId;
  bool? isVisionActive;
  String? createdBy;
  int? relatedCountAll;
  String? status;

  ObjectiveModel(
      {this.id,
      this.title,
      this.description,
      this.weightScaleLookUpId,
      this.weight,
      this.subObjectActives,
      this.startDate,
      this.endDate,
      this.strategicAxisId,
      this.manzorId,
      this.visionId,
      this.isVisionActive,
      this.createdBy,
      this.relatedCountAll,
      this.status});

  ObjectiveModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    description = json['description'];
    weightScaleLookUpId = json['weightScaleLookUpId'];
    weight = json['weight'];
    subObjectActives = json['subObjectActives'].cast<String>();
    startDate = json['startDate'];
    endDate = json['endDate'];
    strategicAxisId = json['strategicAxisId'];
    manzorId = json['manzorId'];
    visionId = json['visionId'];
    isVisionActive = json['isVisionActive'];
    createdBy = json['createdBy'];
    relatedCountAll = json['relatedCountAll'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['description'] = this.description;
    data['weightScaleLookUpId'] = this.weightScaleLookUpId;
    data['weight'] = this.weight;
    data['subObjectActives'] = this.subObjectActives;
    data['startDate'] = this.startDate;
    data['endDate'] = this.endDate;
    data['strategicAxisId'] = this.strategicAxisId;
    data['manzorId'] = this.manzorId;
    data['visionId'] = this.visionId;
    data['isVisionActive'] = this.isVisionActive;
    data['createdBy'] = this.createdBy;
    data['relatedCountAll'] = this.relatedCountAll;
    data['status'] = this.status;
    return data;
  }
}
