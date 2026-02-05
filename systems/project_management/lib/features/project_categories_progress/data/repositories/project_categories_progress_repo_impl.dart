import 'package:core_system/core/config/api_names.dart';
import 'package:core_system/core/network/network_layer.dart';
import 'package:project_management/features/project_categories_progress/domain/repositories/project_categories_progress_repo.dart';

class ProjectCategoriesProgressRepoImpl
    implements ProjectCategoriesProgressRepo {
  final Network network;

  ProjectCategoriesProgressRepoImpl({required this.network});

  @override
  Future<dynamic> getProjectCategoriesProgress() async {
    return await network.requestOrThrow(
      ApiNames.projectCategoriesProgress,
      method: ServerMethods.GET,
    );
  }
}
