import 'package:core_system/core/utility/export.dart';

class ProjectTimelineModel extends SingleMapper {
  final List<MilestoneModel>? milestones;

  ProjectTimelineModel({this.milestones});

  ProjectTimelineModel.fromJson(Map<String, dynamic> json)
    : milestones = json['milestones'] != null
          ? (json['milestones'] as List)
                .map((e) => MilestoneModel.fromJson(e))
                .toList()
          : json['data'] != null && json['data'] is List
          ? (json['data'] as List)
                .map((e) => MilestoneModel.fromJson(e))
                .toList()
          : null;

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (milestones != null) {
      data['milestones'] = milestones!.map((e) => e.toJson()).toList();
    }
    return data;
  }

  @override
  Mapper fromJson(Map<String, dynamic> json) {
    return ProjectTimelineModel.fromJson(json);
  }
}

class MilestoneModel {
  final int? id;
  final String? name;
  final String? description;
  final int? projectId;
  final DateTime? startDate;
  final DateTime? endDate;
  final List<SubActivityModel>? subActivities;

  MilestoneModel({
    this.id,
    this.name,
    this.description,
    this.projectId,
    this.startDate,
    this.endDate,
    this.subActivities,
  });

  MilestoneModel.fromJson(Map<String, dynamic> json)
    : id = json['id'],
      name = json['name'],
      description = json['description'],
      projectId = json['projectId'],
      startDate = json['startDate'] != null
          ? DateTime.parse(json['startDate'])
          : null,
      endDate = json['endDate'] != null
          ? DateTime.parse(json['endDate'])
          : null,
      subActivities = json['subActivities'] != null
          ? (json['subActivities'] as List)
                .map((e) => SubActivityModel.fromJson(e))
                .toList()
          : null;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['description'] = description;
    data['projectId'] = projectId;
    data['startDate'] = startDate?.toIso8601String();
    data['endDate'] = endDate?.toIso8601String();
    if (subActivities != null) {
      data['subActivities'] = subActivities!.map((e) => e.toJson()).toList();
    }
    return data;
  }
}

class SubActivityModel {
  final int? id;
  final String? name;
  final String? description;
  final int? activityId;
  final DateTime? startDate;
  final DateTime? endDate;
  final int? outputId;
  final double? budgetValue;
  final bool? isWithOutput;
  final bool? isHaveBudget;
  final bool? isDelivered;
  final DateTime? updatedAt;

  SubActivityModel({
    this.id,
    this.name,
    this.description,
    this.activityId,
    this.startDate,
    this.endDate,
    this.outputId,
    this.budgetValue,
    this.isWithOutput,
    this.isHaveBudget,
    this.isDelivered,
    this.updatedAt,
  });

  SubActivityModel.fromJson(Map<String, dynamic> json)
    : id = json['id'],
      name = json['name'],
      description = json['description'],
      activityId = json['activityId'],
      startDate = json['startDate'] != null
          ? DateTime.parse(json['startDate'])
          : null,
      endDate = json['endDate'] != null
          ? DateTime.parse(json['endDate'])
          : null,
      outputId = json['outputId'],
      budgetValue = json['budgetValue'] != null
          ? (json['budgetValue'] as num).toDouble()
          : null,
      isWithOutput = json['isWithOutput'],
      isHaveBudget = json['isHaveBudget'],
      isDelivered = json['isDelivered'],
      updatedAt = json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : null;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['description'] = description;
    data['activityId'] = activityId;
    data['startDate'] = startDate?.toIso8601String();
    data['endDate'] = endDate?.toIso8601String();
    data['outputId'] = outputId;
    data['budgetValue'] = budgetValue;
    data['isWithOutput'] = isWithOutput;
    data['isHaveBudget'] = isHaveBudget;
    data['isDelivered'] = isDelivered;
    data['updatedAt'] = updatedAt?.toIso8601String();
    return data;
  }
}
