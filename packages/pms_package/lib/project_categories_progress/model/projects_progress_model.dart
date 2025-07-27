import 'package:core_package/core/network/mapper.dart';

class ProjectsOverviewModel extends SingleMapper {
  final bool? succeeded;
  final List<ProjectsOverviewData>? data;
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
        data: (json['data'] as List<dynamic>?)
            ?.map((e) => ProjectsOverviewData.fromJson(e as Map<String, dynamic>))
            .toList(),
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
    'data': data?.map((e) => e.toJson()).toList(),
    'warningErrors': warningErrors,
    'validationErrors': validationErrors,
  };

  @override
  ProjectsOverviewModel fromJson(Map<String, dynamic> json) =>
      ProjectsOverviewModel.fromJson(json);
}

class ProjectsOverviewData extends SingleMapper {
  final String? name;
  final String? hexColor;
  final num? percentage;
  final num? count;

  ProjectsOverviewData({
    this.name,
    this.hexColor,
    this.percentage,
    this.count,
  });

  factory ProjectsOverviewData.fromJson(Map<String, dynamic> json) =>
      ProjectsOverviewData(
        name: json['name'] as String?,
        hexColor: json['hexColor'] as String?,
        percentage: json['percentage'] as num?,
        count: json['count'] as num?,
      );

  @override
  Map<String, dynamic> toJson() => {
    'name': name,
    'hexColor': hexColor,
    'percentage': percentage,
    'count': count,
  };

  @override
  ProjectsOverviewData fromJson(Map<String, dynamic> json) =>
      ProjectsOverviewData.fromJson(json);
}
