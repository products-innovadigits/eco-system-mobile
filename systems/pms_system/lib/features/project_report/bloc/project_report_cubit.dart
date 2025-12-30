import 'package:pms_system/core/utility/pms_exports.dart';

class ProjectReportCubit extends Cubit<ProjectReportState> {
  ProjectReportCubit() : super(const ProjectReportInitial());

  Future<void> loadProjectReport(int projectId) async {
    try {
      emit(const ProjectReportLoading());

      Response res = await ProjectReportRepo.getProjectReport(projectId);

      if (res.statusCode == 200 && res.data != null) {
        ProjectReportModel model = ProjectReportModel.fromJson(res.data);
        emit(ProjectReportLoaded(report: model));
      } else {
        emit(
          const ProjectReportFailure(message: 'Failed to load project report'),
        );
      }
    } catch (e) {
      emit(
        const ProjectReportFailure(message: 'Failed to load project report'),
      );
    }
  }
}
