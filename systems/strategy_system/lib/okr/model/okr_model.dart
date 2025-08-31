import '../../shared/strategy_exports.dart';
class OkrModel extends SingleMapper {
  bool? succeeded;
  OkrVisionDataModel? data;
  dynamic warningErrors;
  List<dynamic>? validationErrors;

  OkrModel({
    this.succeeded,
    this.data,
    this.warningErrors,
    this.validationErrors,
  });

  OkrModel.fromJson(Map<String, dynamic> json) {
    succeeded = json['succeeded'] as bool?;
    data = json['data'] != null
        ? OkrVisionDataModel.fromJson(json['data'] as Map<String, dynamic>)
        : null;
    warningErrors = json['warningErrors'];
    validationErrors = json['validationErrors'] != null
        ? List<dynamic>.from(json['validationErrors'] as List)
        : null;
  }

  @override
  Mapper fromJson(Map<String, dynamic> json) => OkrModel.fromJson(json);

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> map = <String, dynamic>{};
    map['succeeded'] = succeeded;
    if (data != null) map['data'] = data!.toJson();
    map['warningErrors'] = warningErrors;
    map['validationErrors'] = validationErrors;
    return map;
  }
}

class OkrVisionDataModel {
  int? id;
  String? title;
  String? description;
  bool? isActive;
  List<OkrObjectivesModel>? objectives;

  OkrVisionDataModel({
    this.id,
    this.title,
    this.description,
    this.isActive,
    this.objectives,
  });

  OkrVisionDataModel.fromJson(Map<String, dynamic> json) {
    id = json['id'] as int?;
    title = json['title'] as String?;
    description = json['description'] as String?;
    isActive = json['isActive'] as bool?;
    if (json['objectActives'] != null) {
      objectives = <OkrObjectivesModel>[];
      for (var v in json['objectActives'] as List) {
        objectives!.add(OkrObjectivesModel.fromJson(v as Map<String, dynamic>));
      }
    }
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{
      'id': id,
      'title': title,
      'description': description,
      'isActive': isActive,
    };
    if (objectives != null) {
      map['objectActives'] = objectives!.map((e) => e.toJson()).toList();
    }
    return map;
  }
}

/// ObjectActive (with KeyResults)
class OkrObjectivesModel {
  int? id;
  String? title;
  String? description;
  List<IndicatorModel>? keyResults;

  OkrObjectivesModel({
    this.id,
    this.title,
    this.description,
    this.keyResults,
  });

  OkrObjectivesModel.fromJson(Map<String, dynamic> json) {
    id = json['id'] as int?;
    title = json['title'] as String?;
    description = json['description'] as String?;
    if (json['key_results'] != null) {
      keyResults = <IndicatorModel>[];
      for (var v in json['key_results'] as List) {
        keyResults!.add(IndicatorModel.fromJson(v as Map<String, dynamic>));
      }
    }
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{
      'id': id,
      'title': title,
      'description': description,
    };
    if (keyResults != null) {
      map['key_results'] = keyResults!.map((e) => e.toJson()).toList();
    }
    return map;
  }
}
