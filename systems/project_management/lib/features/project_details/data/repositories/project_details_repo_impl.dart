import 'package:core_system/core/config/api_names.dart';
import 'package:core_system/core/network/network_layer.dart';
import 'package:project_management/features/project_details/domain/repositories/project_details_repo.dart';
import 'package:project_management/features/project_details/model/project_details_model.dart';
import 'package:project_management/features/project_management_home/model/kpis_initiatives_progress_model.dart';

class ProjectDetailsRepoImpl implements ProjectDetailsRepo {
  final Network network;

  ProjectDetailsRepoImpl({required this.network});

  @override
  Future<ProjectDetailsModel> getProjectDetails(int id) async {
    final res = await network.requestOrThrow(
      ApiNames.projectDetails(id),
      method: ServerMethods.GET,
      model: ProjectDetailsModel(),
    );
    return res;
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
