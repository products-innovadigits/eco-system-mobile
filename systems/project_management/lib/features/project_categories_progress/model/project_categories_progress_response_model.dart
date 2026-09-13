import 'package:core_system/core/network/mapper.dart';
import 'package:project_management/features/project_categories_progress/model/project_categories_progress_model.dart';

/// Envelope for the project categories progress endpoint.
///
/// The categories sit under `data.categories`, not directly under `data`.
class ProjectCategoriesProgressResponseModel extends SingleMapper {
  final bool? succeeded;
  final List<ProjectCategoriesProgressModel> categories;
  final dynamic warningErrors;
  final List<dynamic>? validationErrors;

  ProjectCategoriesProgressResponseModel({
    this.succeeded,
    this.categories = const [],
    this.warningErrors,
    this.validationErrors,
  });

  factory ProjectCategoriesProgressResponseModel.fromJson(
    Map<String, dynamic> json,
  ) {
    final data = json['data'];
    final rawCategories = data is Map ? data['categories'] : null;

    return ProjectCategoriesProgressResponseModel(
      succeeded: json['succeeded'] as bool?,
      categories: rawCategories is List
          ? rawCategories
                .whereType<Map>()
                .map(
                  (e) => ProjectCategoriesProgressModel.fromJson(
                    e.cast<String, dynamic>(),
                  ),
                )
                .toList()
          : const [],
      warningErrors: json['warningErrors'],
      validationErrors: json['validationErrors'] as List<dynamic>?,
    );
  }

  @override
  Map<String, dynamic> toJson() => {
    'succeeded': succeeded,
    'data': {'categories': categories.map((e) => e.toJson()).toList()},
    'warningErrors': warningErrors,
    'validationErrors': validationErrors,
  };

  @override
  Mapper fromJson(Map<String, dynamic> json) =>
      ProjectCategoriesProgressResponseModel.fromJson(json);
}
