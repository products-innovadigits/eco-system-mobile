import 'package:pms_system/core/utility/pms_exports.dart';
import 'package:pms_system/features/projects_progress/bloc/projects_progress_state.dart';
import 'package:pms_system/features/projects_progress/repo/projects_progress_repo.dart';

class ProjectsProgressCubit extends Cubit<ProjectsProgressState> {
  ProjectsProgressCubit() : super(const ProjectsProgressInitial());

  Future<void> loadProjectsProgress() async {
    try {
      emit(const ProjectsProgressLoading());

      Response res = await ProjectProgressRepo.getProjectProgress();

      if (res.statusCode == 200 && res.data != null) {
        List<ProjectsOverviewData> data = List<ProjectsOverviewData>.from(
          res.data["data"].map((e) => ProjectsOverviewData.fromJson(e)),
        );

        if (data.isEmpty) {
          emit(const ProjectsProgressEmpty());
        } else {
          emit(ProjectsProgressLoaded(projects: data));
        }
      } else {
        emit(
          const ProjectsProgressFailure(
            message: 'Failed to load projects progress',
          ),
        );
      }
    } catch (e) {
      emit(
        const ProjectsProgressFailure(
          message: 'Failed to load projects progress',
        ),
      );
    }
  }
}
