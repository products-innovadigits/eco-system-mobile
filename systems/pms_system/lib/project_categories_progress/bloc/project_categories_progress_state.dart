import 'package:pms_system/project_categories_progress/model/project_categories_progress_model.dart';

/// Base state for ProjectCategoriesProgressCubit
abstract class ProjectCategoriesProgressState {
  const ProjectCategoriesProgressState();
}

/// Initial state
class ProjectCategoriesProgressInitial extends ProjectCategoriesProgressState {
  const ProjectCategoriesProgressInitial();
}

/// Loading categories progress
class ProjectCategoriesProgressLoading extends ProjectCategoriesProgressState {
  const ProjectCategoriesProgressLoading();
}

/// Categories progress loaded successfully
class ProjectCategoriesProgressLoaded extends ProjectCategoriesProgressState {
  final List<ProjectCategoriesProgressModel> categories;

  const ProjectCategoriesProgressLoaded({required this.categories});
}

/// No categories found (empty result)
class ProjectCategoriesProgressEmpty extends ProjectCategoriesProgressState {
  const ProjectCategoriesProgressEmpty();
}

/// Error loading categories progress
class ProjectCategoriesProgressFailure extends ProjectCategoriesProgressState {
  final String message;

  const ProjectCategoriesProgressFailure({required this.message});
}

