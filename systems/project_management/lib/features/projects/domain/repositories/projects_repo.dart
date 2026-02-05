import 'package:core_system/core/model/search_engine.dart';
import 'package:core_system/core/model/custom_field_model.dart';
import 'package:project_management/features/projects/model/projects_filters_model.dart';
import 'package:project_management/features/projects/model/projects_model.dart';

abstract class ProjectsRepo {
  Future<ProjectsModel> getProjects(SearchEngine data);
  Future<CustomFieldsModel> getProjectPriorityLevel();
  Future<ProjectsFiltersModel> getProjectFilterOptions();
  Future<dynamic> getProjectSortingOptions();
}
