import 'package:project_management/features/project_categories_progress/model/projects_progress_model.dart';

abstract class ProjectProgressRepo {
  Future<ProjectsOverviewModel> getProjectProgress();
}
