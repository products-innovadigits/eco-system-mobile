import 'package:pms_system/core/utility/pms_exports.dart';

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
