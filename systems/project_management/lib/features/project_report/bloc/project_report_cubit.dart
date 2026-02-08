import 'package:project_management/core/utility/project_management_exports.dart';

class ProjectReportCubit extends Cubit<ProjectReportState> {
  final ProjectReportRepo repo;

  ProjectReportCubit({required this.repo})
      : super(const ProjectReportInitial());

  Future<void> loadProjectReport(int projectId) async {
    try {
      emit(const ProjectReportLoading());

      Response res = await repo.getProjectReport(projectId);

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
