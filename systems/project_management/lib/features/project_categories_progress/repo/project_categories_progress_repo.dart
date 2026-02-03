import 'package:project_management/core/utility/pms_exports.dart';

abstract class ProjectCategoriesProgressRepo {
  Future<dynamic> getProjectCategoriesProgress();
}

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
