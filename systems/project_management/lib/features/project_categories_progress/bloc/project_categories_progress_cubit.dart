import 'package:project_management/core/utility/project_management_exports.dart';

class ProjectCategoriesProgressCubit
    extends Cubit<ProjectCategoriesProgressState> {
  final ProjectCategoriesProgressRepo repo;

  ProjectCategoriesProgressCubit({required this.repo})
    : super(const ProjectCategoriesProgressInitial());

  Future<void> loadCategoriesProgress() async {
    try {
      emit(const ProjectCategoriesProgressLoading());

      final res = await repo.getProjectCategoriesProgress();

      if (res.succeeded != true) {
        emit(
          const ProjectCategoriesProgressFailure(
            message: 'Failed to load categories progress',
          ),
        );
      } else if (res.categories.isEmpty) {
        emit(const ProjectCategoriesProgressEmpty());
      } else {
        emit(ProjectCategoriesProgressLoaded(categories: res.categories));
      }
    } catch (e) {
      emit(
        const ProjectCategoriesProgressFailure(
          message: 'Failed to load categories progress',
        ),
      );
    }
  }
}
