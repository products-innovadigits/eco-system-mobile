import 'package:core_system/core/core/enums.dart';

/// Events for ProjectDetailsBloc
abstract class ProjectDetailsEvent {
  const ProjectDetailsEvent();
}

/// Load project details
class LoadProjectDetails extends ProjectDetailsEvent {
  final int projectId;

  const LoadProjectDetails({required this.projectId});
}

/// Load project timeline/milestones
class LoadProjectTimeline extends ProjectDetailsEvent {
  final int projectId;

  const LoadProjectTimeline({required this.projectId});
}

/// Select a tab in project details
class SelectProjectTab extends ProjectDetailsEvent {
  final ProjectDetailsEnum tab;

  const SelectProjectTab({required this.tab});
}

