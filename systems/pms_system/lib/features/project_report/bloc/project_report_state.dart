import 'package:pms_system/core/utility/pms_exports.dart';

/// Base state for ProjectReportBloc
abstract class ProjectReportState {
  const ProjectReportState();
}

/// Initial state
class ProjectReportInitial extends ProjectReportState {
  const ProjectReportInitial();
}

/// Loading project report
class ProjectReportLoading extends ProjectReportState {
  const ProjectReportLoading();
}

/// Project report loaded successfully
class ProjectReportLoaded extends ProjectReportState {
  final ProjectReportModel report;

  const ProjectReportLoaded({required this.report});
}

/// Error loading project report
class ProjectReportFailure extends ProjectReportState {
  final String message;

  const ProjectReportFailure({required this.message});
}
