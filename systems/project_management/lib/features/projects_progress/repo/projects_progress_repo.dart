import '../../../core/utility/pms_exports.dart';

abstract class ProjectProgressRepo {
  Future<dynamic> getProjectProgress();
}

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
