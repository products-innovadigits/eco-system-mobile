import 'package:project_management/core/utility/pms_exports.dart';

/// Base state for ProjectsBloc
abstract class ProjectsState {
  const ProjectsState();
}

/// Initial state
class ProjectsInitial extends ProjectsState {
  const ProjectsInitial();
}

/// Loading first page
class ProjectsLoading extends ProjectsState {
  const ProjectsLoading();
}

/// Successfully loaded projects
class ProjectsLoaded extends ProjectsState {
  final List<ProjectDetailsModel> projects;
  final bool isLoadingMore;
  final int currentPage;
  final int totalPages;
  final bool hasMore;

  const ProjectsLoaded({
    required this.projects,
    this.isLoadingMore = false,
    this.currentPage = 0,
    this.totalPages = 1,
    this.hasMore = false,
  });

  ProjectsLoaded copyWith({
    List<ProjectDetailsModel>? projects,
    bool? isLoadingMore,
    int? currentPage,
    int? totalPages,
    bool? hasMore,
  }) {
    return ProjectsLoaded(
      projects: projects ?? this.projects,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      currentPage: currentPage ?? this.currentPage,
      totalPages: totalPages ?? this.totalPages,
      hasMore: hasMore ?? this.hasMore,
    );
  }
}

/// No projects found (empty result)
class ProjectsEmpty extends ProjectsState {
  final bool isInitial;

  const ProjectsEmpty({this.isInitial = false});
}

/// Error loading projects
class ProjectsFailure extends ProjectsState {
  final String message;

  const ProjectsFailure({required this.message});
}
