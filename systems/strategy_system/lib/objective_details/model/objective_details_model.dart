import 'package:core_system/core/utility/export.dart';

class ObjectiveDetailsModel extends SingleMapper {
  int? id;
  String? title;
  String? description;
  int? weightScaleLookUpId;
  double? weight;
  List<String>? subObjectActives;
  DateTime? startDate;
  DateTime? endDate;
  int? strategicAxisId;
  int? manzorId;
  int? visionId;
  bool? isVisionActive;
  String? createdBy;
  int? relatedCountAll;
  String? status;
  String? strategicAxisType;

  ObjectiveDetailsModel(
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
      this.strategicAxisType,
      this.status});

  ObjectiveDetailsModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    description = json['description'];
    weightScaleLookUpId = json['weightScaleLookUpId'];
    weight = json['weight'];
    subObjectActives = json['subObjectActives'].cast<String>();
    startDate =
        json['startDate'] != null ? DateTime.parse(json['startDate']) : null;
    endDate = json['endDate'] != null ? DateTime.parse(json['endDate']) : null;
    strategicAxisId = json['strategicAxisId'];
    manzorId = json['manzorId'];
    visionId = json['visionId'];
    isVisionActive = json['isVisionActive'];
    createdBy = json['createdBy'];
    relatedCountAll = json['relatedCountAll'];
    status = json['status'];
    strategicAxisType = json['strategicAxisType'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['description'] = description;
    data['weightScaleLookUpId'] = weightScaleLookUpId;
    data['weight'] = weight;
    data['subObjectActives'] = subObjectActives;
    data['startDate'] = startDate;
    data['endDate'] = endDate;
    data['strategicAxisId'] = strategicAxisId;
    data['manzorId'] = manzorId;
    data['visionId'] = visionId;
    data['isVisionActive'] = isVisionActive;
    data['createdBy'] = createdBy;
    data['relatedCountAll'] = relatedCountAll;
    data['status'] = status;
    data['strategicAxisType'] = strategicAxisType;
    return data;
  }

  @override
  Mapper fromJson(Map<String, dynamic> json) {
    return ObjectiveDetailsModel.fromJson(json);
  }
}
