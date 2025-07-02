import 'package:core_package/core/utility/export.dart';

abstract class ProjectProgressRepo {
  static Future<dynamic> getProjectProgress() async {
    return await Network()
        .request(ApiNames.ProjectProgress, method: ServerMethods.GET);
  }
}
