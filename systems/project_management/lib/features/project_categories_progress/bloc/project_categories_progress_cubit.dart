import 'package:project_management/core/utility/project_management_exports.dart';

class ProjectCategoriesProgressCubit
    extends Cubit<ProjectCategoriesProgressState> {
  final ProjectCategoriesProgressRepo repo;

  ProjectCategoriesProgressCubit({required this.repo})
      : super(const ProjectCategoriesProgressInitial());

  Future<void> loadCategoriesProgress() async {
    try {
      emit(const ProjectCategoriesProgressLoading());

      Response res = await repo.getProjectCategoriesProgress();

      if (res.statusCode == 200 && res.data != null) {
        List<ProjectCategoriesProgressModel> data =
            List<ProjectCategoriesProgressModel>.from(
              res.data["data"].map(
                (e) => ProjectCategoriesProgressModel.fromJson(e),
              ),
            );

        if (data.isEmpty) {
          emit(const ProjectCategoriesProgressEmpty());
        } else {
          emit(ProjectCategoriesProgressLoaded(categories: data));
        }
      } else {
        emit(
          const ProjectCategoriesProgressFailure(
            message: 'Failed to load categories progress',
          ),
        );
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
