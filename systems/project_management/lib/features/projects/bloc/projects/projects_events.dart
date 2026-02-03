import 'package:project_management/core/utility/pms_exports.dart';

/// Events for ProjectsBloc
abstract class ProjectsEvent {
  const ProjectsEvent();
}

/// Load projects (initial load or pagination)
class LoadProjects extends ProjectsEvent {
  final SearchEngine searchEngine;

  const LoadProjects({required this.searchEngine});
}

/// Refresh projects list
class RefreshProjects extends ProjectsEvent {
  const RefreshProjects();
}

/// Search text changed - triggers new search
class SearchChanged extends ProjectsEvent {
  final String text;

  const SearchChanged(this.text);
}

/// Load more projects (pagination) - triggered by UI scroll
class LoadMoreProjects extends ProjectsEvent {
  const LoadMoreProjects();
}
