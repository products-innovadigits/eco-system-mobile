import 'package:project_management/core/utility/project_management_exports.dart';

class ProjectsProgressCubit extends Cubit<ProjectsProgressState> {
  final ProjectProgressRepo repo;

  ProjectsProgressCubit({required this.repo})
      : super(const ProjectsProgressInitial());

  Future<void> loadProjectsProgress() async {
    try {
      emit(const ProjectsProgressLoading());

      Response res = await repo.getProjectProgress();

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
