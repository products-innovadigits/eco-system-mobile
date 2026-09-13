import 'package:project_management/core/utility/project_management_exports.dart';

class ProjectsProgressCubit extends Cubit<ProjectsProgressState> {
  final ProjectProgressRepo repo;

  ProjectsProgressCubit({required this.repo})
    : super(const ProjectsProgressInitial());

  Future<void> loadProjectsProgress() async {
    try {
      emit(const ProjectsProgressLoading());

      final res = await repo.getProjectProgress();

      if (res.succeeded != true) {
        emit(
          const ProjectsProgressFailure(
            message: 'Failed to load projects progress',
          ),
        );
      } else if (res.data == null || res.data!.isEmpty) {
        emit(const ProjectsProgressEmpty());
      } else {
        emit(ProjectsProgressLoaded(projects: res.data!));
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
