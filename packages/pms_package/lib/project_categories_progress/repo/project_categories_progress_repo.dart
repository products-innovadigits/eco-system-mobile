import 'package:core_package/core/utility/export.dart';

abstract class ProjectCategoriesProgressRepo {
  static Future<dynamic> getProjectCategoriesProgress() async {
    return await Network()
        .request(ApiNames.ProjectCategoriesProgress, method: ServerMethods.GET);
  }


}
