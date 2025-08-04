import 'package:core_system/core/utility/export.dart';

abstract class ProjectDetailsRepo {
  static Future<dynamic> getProjectDetails(id) async {
    return await Network()
        .request(ApiNames.projectDetails(id), method: ServerMethods.GET);
  }


}
