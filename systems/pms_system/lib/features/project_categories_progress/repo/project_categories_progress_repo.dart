import 'package:pms_system/core/utility/pms_exports.dart';

abstract class ProjectCategoriesProgressRepo {
  static Future<dynamic> getProjectCategoriesProgress() async {
    return await Network().request(
      ApiNames.ProjectCategoriesProgress,
      method: ServerMethods.GET,
    );
  }
}
