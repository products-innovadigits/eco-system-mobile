import 'package:project_management/core/utility/pms_exports.dart';

abstract class ProjectReportRepo {
  Future<dynamic> getProjectReport(int id);
}

class ProjectReportRepoImpl implements ProjectReportRepo {
  final Network network;

  ProjectReportRepoImpl({required this.network});

  @override
  Future<dynamic> getProjectReport(int id) async {
    return await network.requestOrThrow(
      ApiNames.projectReport(id),
      method: ServerMethods.GET,
    );
  }
}
