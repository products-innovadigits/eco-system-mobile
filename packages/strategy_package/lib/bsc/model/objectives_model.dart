import 'package:core_package/core/model/meta.dart';
import 'package:core_package/core/network/mapper.dart';

class ObjectivesModel extends SingleMapper {
  List<ObjectiveDataModel>? data;
  int? statusCode;
  String? message;
  Meta? meta;

  ObjectivesModel({this.data, this.statusCode, this.message, this.meta});

  ObjectivesModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = (json['data'] as List)
          .map((e) => ObjectiveDataModel.fromJson(e))
          .toList();
    }
    statusCode = json['status_code'];
    message = json['message'];
    meta = json['meta'] != null ? Meta.fromJson(json['meta']) : null;
  }

  @override
  Mapper fromJson(Map<String, dynamic> json) => ObjectivesModel.fromJson(json);

  @override
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (data != null) {
      map['data'] = data!.map((e) => e.toJson()).toList();
    }
    map['status_code'] = statusCode;
    map['message'] = message;
    if (meta != null) map['meta'] = meta!.toJson();
    return map;
  }
}

class ObjectiveDataModel extends SingleMapper {
  int? id;
  String? title;
  String? description;
  double? weight;
  int? weightScaleLookUpId;
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
  List<IndicatorModel>? kpis;
  List<IndicatorModel>? initiatives;

  ObjectiveDataModel({
    this.id,
    this.title,
    this.description,
    this.weight,
    this.weightScaleLookUpId,
    this.subObjectActives,
    this.startDate,
    this.endDate,
    this.strategicAxisId,
    this.manzorId,
    this.visionId,
    this.isVisionActive,
    this.createdBy,
    this.relatedCountAll,
    this.status,
    this.kpis,
    this.initiatives,
  });

  factory ObjectiveDataModel.fromJson(Map<String, dynamic> json) =>
      ObjectiveDataModel(
        id: json['id'],
        title: json['title'],
        description: json['description'],
        weight: json['weight']?.toDouble(),
        weightScaleLookUpId: json['weightScaleLookUpId'],
        subObjectActives: (json['subObjectActives'] as List?)
            ?.map((e) => e.toString())
            .toList(),
        startDate:
        json['startDate'] != null ? DateTime.parse(json['startDate']) : null,
        endDate:
        json['endDate'] != null ? DateTime.parse(json['endDate']) : null,
        strategicAxisId: json['strategicAxisId'],
        manzorId: json['manzorId'],
        visionId: json['visionId'],
        isVisionActive: json['isVisionActive'],
        createdBy: json['createdBy'],
        relatedCountAll: json['relatedCountAll'],
        status: json['status'],
        kpis: (json['kpis'] as List?)
            ?.map((e) => IndicatorModel.fromJson(e))
            .toList(),
        initiatives: (json['initiatives'] as List?)
            ?.map((e) => IndicatorModel.fromJson(e))
            .toList(),
      );

  @override
  Mapper fromJson(Map<String, dynamic> json) =>
      ObjectiveDataModel.fromJson(json);

  @override
  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'description': description,
    'weight': weight,
    'weightScaleLookUpId': weightScaleLookUpId,
    'subObjectActives': subObjectActives,
    'startDate': startDate?.toIso8601String(),
    'endDate': endDate?.toIso8601String(),
    'strategicAxisId': strategicAxisId,
    'manzorId': manzorId,
    'visionId': visionId,
    'isVisionActive': isVisionActive,
    'createdBy': createdBy,
    'relatedCountAll': relatedCountAll,
    'status': status,
    'kpis': kpis?.map((e) => e.toJson()).toList(),
    'initiatives': initiatives?.map((e) => e.toJson()).toList(),
  };
}

// class KpiModel extends SingleMapper {
//   int? id;
//   String? kpiTitle;
//   List<IndicatorModel>? kpis;
//
//   KpiModel({this.id, this.kpiTitle, this.kpis});
//
//   factory KpiModel.fromJson(Map<String, dynamic> json) => KpiModel(
//     id: json['id'],
//     kpiTitle: json['kpiTitle'],
//     kpis: (json['indicators'] as List?)
//         ?.map((e) => IndicatorModel.fromJson(e))
//         .toList(),
//   );
//
//   @override
//   Mapper fromJson(Map<String, dynamic> json) => KpiModel.fromJson(json);
//
//   @override
//   Map<String, dynamic> toJson() => {
//     'id': id,
//     'kpiTitle': kpiTitle,
//     'indicators': kpis?.map((e) => e.toJson()).toList(),
//   };
// }
//
// class InitiativeModel extends SingleMapper {
//   int? id;
//   String? initiativeTitle;
//   List<IndicatorModel>? initiatives;
//
//   InitiativeModel({this.id, this.initiativeTitle, this.initiatives});
//
//   factory InitiativeModel.fromJson(Map<String, dynamic> json) =>
//       InitiativeModel(
//         id: json['id'],
//         initiativeTitle: json['initiativeTitle'],
//         initiatives: (json['indicators'] as List?)
//             ?.map((e) => IndicatorModel.fromJson(e))
//             .toList(),
//       );
//
//   @override
//   Mapper fromJson(Map<String, dynamic> json) => InitiativeModel.fromJson(json);
//
//   @override
//   Map<String, dynamic> toJson() => {
//     'id': id,
//     'initiativeTitle': initiativeTitle,
//     'indicators': initiatives?.map((e) => e.toJson()).toList(),
//   };
// }

class IndicatorModel {
  int? id;
  String? indicatorTitle;

  IndicatorModel({this.id, this.indicatorTitle});

  factory IndicatorModel.fromJson(Map<String, dynamic> json) => IndicatorModel(
    id: json['id'],
    indicatorTitle: json['indicatorTitle'],
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'indicatorTitle': indicatorTitle,
  };
}
