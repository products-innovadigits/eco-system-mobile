import 'package:project_management/features/project_management_home/model/kpis_initiatives_progress_model.dart';

abstract class ProjectDetailsRepo {
  Future<dynamic> getProjectDetails(int id);
  Future<dynamic> getProjectGeneralProgressSummary(
    int id, {
    ChartTime chartType = ChartTime.monthly,
  });
  Future<dynamic> projectTimeline(int projectId);
}
