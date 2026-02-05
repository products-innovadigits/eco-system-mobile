import 'package:core_system/core/config/api_names.dart';
import 'package:core_system/core/network/network_layer.dart';
import 'package:project_management/features/projects_progress/domain/repositories/projects_progress_repo.dart';

class ProjectProgressRepoImpl implements ProjectProgressRepo {
  final Network network;

  ProjectProgressRepoImpl({required this.network});

  @override
  Future<dynamic> getProjectProgress() async {
    return await network.requestOrThrow(
      ApiNames.projectProgress,
      method: ServerMethods.GET,
    );
  }
}
