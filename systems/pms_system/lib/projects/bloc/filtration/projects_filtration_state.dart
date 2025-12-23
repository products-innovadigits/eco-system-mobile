import 'package:pms_system/projects/model/projects_filters_model.dart';

/// Base state for ProjectsFiltrationBloc
abstract class ProjectsFiltrationState {
  const ProjectsFiltrationState();
}

/// Initial state
class ProjectsFiltrationInitial extends ProjectsFiltrationState {
  const ProjectsFiltrationInitial();
}

/// Loading filter options
class ProjectsFiltrationLoading extends ProjectsFiltrationState {
  const ProjectsFiltrationLoading();
}

/// Filter options loaded successfully
class ProjectsFiltrationLoaded extends ProjectsFiltrationState {
  final ProjectsFiltersData filterOptions;
  final bool isFilterApplied;

  const ProjectsFiltrationLoaded({
    required this.filterOptions,
    this.isFilterApplied = false,
  });

  ProjectsFiltrationLoaded copyWith({
    ProjectsFiltersData? filterOptions,
    bool? isFilterApplied,
  }) {
    return ProjectsFiltrationLoaded(
      filterOptions: filterOptions ?? this.filterOptions,
      isFilterApplied: isFilterApplied ?? this.isFilterApplied,
    );
  }
}

/// Error loading filter options
class ProjectsFiltrationFailure extends ProjectsFiltrationState {
  final String message;

  const ProjectsFiltrationFailure({required this.message});
}

