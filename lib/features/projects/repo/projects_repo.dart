import 'package:eco_system/model/search_engine.dart';

import '../../../config/api_names.dart';
import '../../../model/custom_field_model.dart';
import '../../../network/network_layer.dart';
import '../model/projects_model.dart';

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
