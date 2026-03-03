import 'package:project_management/core/utility/project_management_exports.dart';

abstract class ProjectDetailsRepo {
  Future<ProjectDetailsModel> getProjectDetails(int id);
  Future<dynamic> getProjectGeneralProgressSummary(
    int id, {
    ChartTime chartType = ChartTime.monthly,
  });
  Future<dynamic> projectTimeline(int projectId);
}
