
import 'package:pms_system/core/utility/pms_exports.dart';

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
