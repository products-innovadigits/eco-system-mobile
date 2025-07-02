import 'package:core_package/core/utility/export.dart';

abstract class ProjectDetailsRepo {
  static Future<dynamic> getProjectDetails(id) async {
    return await Network()
        .request(ApiNames.projectDetails(id), method: ServerMethods.GET);
  }


}
