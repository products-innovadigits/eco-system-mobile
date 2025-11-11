import 'package:core_system/core/utility/export.dart';
import 'package:pms_system/pms_home/model/kpis_initiatives_progress_model.dart';
import 'package:pms_system/project_details/model/project_timeline_model.dart';

abstract class ProjectDetailsRepo {
  static Future<dynamic> getProjectDetails(int id) async {
    return await Network().request(
      ApiNames.projectDetails(id),
      method: ServerMethods.GET,
    );
  }

  static Future<dynamic> getProjectGeneralProgressSummary(
    int id, {
    ChartTime chartType = ChartTime.Month,
  }) async {
    return await Network().request(
      ApiNames.projectGeneralProgressSummary(id),
      query: {'type': chartType == ChartTime.Month ? 'monthly' : 'yearly'},
      method: ServerMethods.GET,
    );
  }

  static Future<dynamic> projectTimeline(int projectId) async {
    return await Network().request(
      ApiNames.projectTimeline(projectId),
      method: ServerMethods.GET,
    );
  }
}
