import 'package:pms_system/shared/pms_exports.dart';

abstract class ProjectsRepo {
  static Future<ProjectsModel> getProjects(SearchEngine data) async {
    return await Network().request(
      ApiNames.projects,
      query: data.query,
      method: ServerMethods.POST,
      model: ProjectsModel(),
    );
  }

  static Future<CustomFieldsModel> getProjectPriorityLevel() async {
    return await Network().request(
      ApiNames.projectPriorityLevels,
      model: CustomFieldsModel(),
      method: ServerMethods.GET,
    );
  }

  static Future<ProjectsFiltersModel> getProjectFilterOptions() async {
    return await Network().request(
      ApiNames.projectFilterOptions,
      model: ProjectsFiltersModel(),
      method: ServerMethods.GET,
    );
  }
  static Future<Response> getProjectSortingOptions() async {
    return await Network().request(
      ApiNames.projectSortingOptions,
      method: ServerMethods.GET,
    );
  }
}
