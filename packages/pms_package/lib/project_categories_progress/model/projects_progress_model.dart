import 'package:core_package/core/network/mapper.dart';

class ProjectsOverviewModel extends SingleMapper {
  final bool? succeeded;
  final ProjectsOverviewData? data;
  final List<String>? warningErrors;
  final List<String>? validationErrors;

  ProjectsOverviewModel({
    this.succeeded,
    this.data,
    this.warningErrors,
    this.validationErrors,
  });

  factory ProjectsOverviewModel.fromJson(Map<String, dynamic> json) =>
      ProjectsOverviewModel(
        succeeded: json['succeeded'] as bool?,
        data: json['data'] != null
            ? ProjectsOverviewData.fromJson(json['data'] as Map<String, dynamic>)
            : null,
        warningErrors: (json['warningErrors'] as List<dynamic>?)
            ?.map((e) => e as String)
            .toList(),
        validationErrors: (json['validationErrors'] as List<dynamic>?)
            ?.map((e) => e as String)
            .toList(),
      );

  @override
  Map<String, dynamic> toJson() => {
    'succeeded': succeeded,
    'data': data?.toJson(),
    'warningErrors': warningErrors,
    'validationErrors': validationErrors,
  };

  @override
  ProjectsOverviewModel fromJson(Map<String, dynamic> json) =>
      ProjectsOverviewModel.fromJson(json);
}

class ProjectsOverviewData extends SingleMapper {
  final num? totalProjects;
  final num? onTrackPercentage;
  final num? delayedPercentage;
  final num? completedPercentage;

  ProjectsOverviewData({
    this.totalProjects,
    this.onTrackPercentage,
    this.delayedPercentage,
    this.completedPercentage,
  });

  factory ProjectsOverviewData.fromJson(Map<String, dynamic> json) =>
      ProjectsOverviewData(
        totalProjects: json['totalProjects'] as num?,
        onTrackPercentage: json['onTrackPercentage'] as num?,
        delayedPercentage: json['delayedPercentage'] as num?,
        completedPercentage: json['completedPercentage'] as num?,
      );

  @override
  Map<String, dynamic> toJson() => {
    'totalProjects': totalProjects,
    'onTrackPercentage': onTrackPercentage,
    'delayedPercentage': delayedPercentage,
    'completedPercentage': completedPercentage,
  };

  @override
  ProjectsOverviewData fromJson(Map<String, dynamic> json) =>
      ProjectsOverviewData.fromJson(json);
}
