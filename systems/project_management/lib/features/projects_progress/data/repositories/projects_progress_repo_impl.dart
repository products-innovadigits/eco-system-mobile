import 'package:core_system/core/config/api_names.dart';
import 'package:core_system/core/network/network_layer.dart';
import 'package:project_management/features/project_categories_progress/model/projects_progress_model.dart';
import 'package:project_management/features/projects_progress/domain/repositories/projects_progress_repo.dart';

class ProjectProgressRepoImpl implements ProjectProgressRepo {
  final Network network;

  ProjectProgressRepoImpl({required this.network});

  @override
  Future<ProjectsOverviewModel> getProjectProgress() async {
    final res = await network.requestOrThrow(
      ApiNames.projectProgress,
      method: ServerMethods.GET,
      model: ProjectsOverviewModel(),
    );
    return res as ProjectsOverviewModel;
  }
}
