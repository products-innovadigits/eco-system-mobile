import 'package:core_system/core/config/api_names.dart';
import 'package:core_system/core/network/network_layer.dart';
import 'package:project_management/features/project_report/domain/repositories/project_report_repo.dart';

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
