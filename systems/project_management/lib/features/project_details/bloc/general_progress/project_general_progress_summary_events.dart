import 'package:project_management/core/utility/project_management_exports.dart';

/// Events for ProjectGeneralProgressSummaryBloc
abstract class ProjectGeneralProgressSummaryEvent {
  const ProjectGeneralProgressSummaryEvent();
}

/// Load general progress summary
class LoadGeneralProgressSummary extends ProjectGeneralProgressSummaryEvent {
  final int projectId;
  final ChartTime chartType;

  const LoadGeneralProgressSummary({
    required this.projectId,
    required this.chartType,
  });
}
