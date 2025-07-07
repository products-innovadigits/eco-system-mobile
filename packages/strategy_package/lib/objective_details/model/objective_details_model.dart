import 'package:core_package/core/utility/export.dart';

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

  @override
  Mapper fromJson(Map<String, dynamic> json) {
    return ObjectiveDetailsModel.fromJson(json);
  }
}
