import 'package:core_system/core/config/api_names.dart';
import 'package:core_system/core/network/network_layer.dart';
import 'package:dio/dio.dart';
import 'package:project_management/features/project_details/domain/repositories/project_details_repo.dart';
import 'package:project_management/features/project_details/model/general_progress_chart_model.dart';
import 'package:project_management/features/project_details/model/project_details_model.dart';
import 'package:project_management/features/project_details/model/project_timeline_model.dart';
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
    return res as ProjectDetailsModel;
  }

  @override
  Future<GeneralProgressChartModel> getProjectGeneralProgressSummary(
    int id, {
    ChartTime chartType = ChartTime.monthly,
  }) async {
    final res = await network.requestOrThrow(
      ApiNames.projectGeneralProgressSummary(id),
      query: {'type': chartType == ChartTime.monthly ? 'monthly' : 'yearly'},
      method: ServerMethods.GET,
      model: GeneralProgressChartModel(),
    );
    return res as GeneralProgressChartModel;
  }

  @override
  Future<List<MilestoneModel>> projectTimeline(int projectId) async {
    final res = await network.requestOrThrow(
      ApiNames.projectTimeline(projectId),
      method: ServerMethods.GET,
    );

    // The endpoint answers with a bare array of milestones; an enveloped
    // `{ "data": [...] }` is tolerated so a backend change does not blank the
    // timeline silently.
    final body = res is Response ? res.data : res;
    final items = body is List
        ? body
        : (body is Map ? body['data'] : null);
    if (items is! List) return const [];

    return items
        .whereType<Map>()
        .map((e) => MilestoneModel.fromJson(e.cast<String, dynamic>()))
        .toList();
  }
}
