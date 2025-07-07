import 'package:pms_package/shared/pms_exports.dart';

abstract class ProjectsRepo {
  static Future<ProjectsModel> getProjects(SearchEngine data) async {
    return await Network().request(
      ApiNames.projects,
      query: data.query,
      method: ServerMethods.GET,
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
}
