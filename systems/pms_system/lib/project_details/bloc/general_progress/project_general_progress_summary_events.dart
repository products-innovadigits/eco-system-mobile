import 'package:pms_system/pms_home/model/kpis_initiatives_progress_model.dart';

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

