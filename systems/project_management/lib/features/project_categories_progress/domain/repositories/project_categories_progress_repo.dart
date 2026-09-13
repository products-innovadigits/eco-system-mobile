import 'package:project_management/features/project_categories_progress/model/project_categories_progress_response_model.dart';

abstract class ProjectCategoriesProgressRepo {
  Future<ProjectCategoriesProgressResponseModel> getProjectCategoriesProgress();
}
