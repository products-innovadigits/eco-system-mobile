import 'package:project_management/features/project_report/model/project_report_model.dart';

abstract class ProjectReportRepo {
  Future<ProjectReportModel> getProjectReport(int id);
}
