import 'package:pms_system/core/utility/pms_exports.dart';

class ProjectCategoriesProgressCubit
    extends Cubit<ProjectCategoriesProgressState> {
  ProjectCategoriesProgressCubit()
    : super(const ProjectCategoriesProgressInitial());

  Future<void> loadCategoriesProgress() async {
    try {
      emit(const ProjectCategoriesProgressLoading());

      Response res =
          await ProjectCategoriesProgressRepo.getProjectCategoriesProgress();

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
