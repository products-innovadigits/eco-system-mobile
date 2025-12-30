import 'package:pms_system/core/utility/pms_exports.dart';

/// Base state for ProjectDetailsBloc
abstract class ProjectDetailsState {
  const ProjectDetailsState();
}

/// Initial state
class ProjectDetailsInitial extends ProjectDetailsState {
  const ProjectDetailsInitial();
}

/// Loading project details
class ProjectDetailsLoading extends ProjectDetailsState {
  const ProjectDetailsLoading();
}

/// Project details loaded successfully
class ProjectDetailsLoaded extends ProjectDetailsState {
  final ProjectDetailsModel projectDetails;

  const ProjectDetailsLoaded({required this.projectDetails});
}

/// Loading timeline/milestones
class ProjectTimelineLoading extends ProjectDetailsState {
  const ProjectTimelineLoading();
}

/// Timeline/milestones loaded successfully
class ProjectTimelineLoaded extends ProjectDetailsState {
  final List<MilestoneModel> milestones;

  const ProjectTimelineLoaded({required this.milestones});
}

/// Error loading project details
class ProjectDetailsFailure extends ProjectDetailsState {
  final String message;

  const ProjectDetailsFailure({required this.message});
}

/// Error loading timeline
class ProjectTimelineFailure extends ProjectDetailsState {
  final String message;

  const ProjectTimelineFailure({required this.message});
}
