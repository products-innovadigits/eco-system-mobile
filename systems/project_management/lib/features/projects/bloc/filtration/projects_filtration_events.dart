// Events for ProjectsFiltrationBloc

/// Base event for filtration
abstract class ProjectsFiltrationEvent {
  const ProjectsFiltrationEvent();
}

/// Load filter options from API
class LoadProjectsFilterOptions extends ProjectsFiltrationEvent {
  const LoadProjectsFilterOptions();
}

/// Apply selected filters to projects
class ApplyProjectsFilters extends ProjectsFiltrationEvent {
  const ApplyProjectsFilters();
}

/// Reset all projects filters
class ResetProjectsFilters extends ProjectsFiltrationEvent {
  const ResetProjectsFilters();
}

/// Clear all filter selections for projects
class ClearProjectsFilters extends ProjectsFiltrationEvent {
  const ClearProjectsFilters();
}
