import 'package:project_management/core/utility/pms_exports.dart';

abstract class ProjectDetailsRepo {
  Future<dynamic> getProjectDetails(int id);
  Future<dynamic> getProjectGeneralProgressSummary(
    int id, {
    ChartTime chartType = ChartTime.monthly,
  });
  Future<dynamic> projectTimeline(int projectId);
}

class ProjectDetailsRepoImpl implements ProjectDetailsRepo {
  final Network network;

  ProjectDetailsRepoImpl({required this.network});

  @override
  Future<dynamic> getProjectDetails(int id) async {
    return await network.requestOrThrow(
      ApiNames.projectDetails(id),
      method: ServerMethods.GET,
    );
  }

  @override
  Future<dynamic> getProjectGeneralProgressSummary(
    int id, {
    ChartTime chartType = ChartTime.monthly,
  }) async {
    return await network.requestOrThrow(
      ApiNames.projectGeneralProgressSummary(id),
      query: {'type': chartType == ChartTime.monthly ? 'monthly' : 'yearly'},
      method: ServerMethods.GET,
    );
  }

  @override
  Future<dynamic> projectTimeline(int projectId) async {
    return await network.requestOrThrow(
      ApiNames.projectTimeline(projectId),
      method: ServerMethods.GET,
    );
  }
}
