import 'package:project_management/core/utility/pms_exports.dart';

/// Base state for ProjectsProgressCubit
abstract class ProjectsProgressState {
  const ProjectsProgressState();
}

/// Initial state
class ProjectsProgressInitial extends ProjectsProgressState {
  const ProjectsProgressInitial();
}

/// Loading projects progress
class ProjectsProgressLoading extends ProjectsProgressState {
  const ProjectsProgressLoading();
}

/// Projects progress loaded successfully
class ProjectsProgressLoaded extends ProjectsProgressState {
  final List<ProjectsOverviewData> projects;

  const ProjectsProgressLoaded({required this.projects});
}

/// No projects found (empty result)
class ProjectsProgressEmpty extends ProjectsProgressState {
  const ProjectsProgressEmpty();
}

/// Error loading projects progress
class ProjectsProgressFailure extends ProjectsProgressState {
  final String message;

  const ProjectsProgressFailure({required this.message});
}
