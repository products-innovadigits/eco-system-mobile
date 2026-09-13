import 'package:core_system/core/config/api_names.dart';
import 'package:core_system/core/network/network_layer.dart';
import 'package:project_management/features/project_report/domain/repositories/project_report_repo.dart';
import 'package:project_management/features/project_report/model/project_report_model.dart';

class ProjectReportRepoImpl implements ProjectReportRepo {
  final Network network;

  ProjectReportRepoImpl({required this.network});

  @override
  Future<ProjectReportModel> getProjectReport(int id) async {
    final res = await network.requestOrThrow(
      ApiNames.projectReport(id),
      method: ServerMethods.GET,
      model: ProjectReportModel(),
    );
    return res as ProjectReportModel;
  }
}
