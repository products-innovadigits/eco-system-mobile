import 'package:project_management/core/utility/project_management_exports.dart';

/// Base state for ProjectGeneralProgressSummaryBloc
abstract class ProjectGeneralProgressSummaryState {
  const ProjectGeneralProgressSummaryState();
}

/// Initial state
class ProjectGeneralProgressSummaryInitial
    extends ProjectGeneralProgressSummaryState {
  const ProjectGeneralProgressSummaryInitial();
}

/// Loading progress summary
class ProjectGeneralProgressSummaryLoading
    extends ProjectGeneralProgressSummaryState {
  const ProjectGeneralProgressSummaryLoading();
}

/// Progress summary loaded successfully
class ProjectGeneralProgressSummaryLoaded
    extends ProjectGeneralProgressSummaryState {
  final GeneralProgressChartModel chartModel;

  const ProjectGeneralProgressSummaryLoaded({required this.chartModel});
}

/// Error loading progress summary
class ProjectGeneralProgressSummaryFailure
    extends ProjectGeneralProgressSummaryState {
  final String message;

  const ProjectGeneralProgressSummaryFailure({required this.message});
}
