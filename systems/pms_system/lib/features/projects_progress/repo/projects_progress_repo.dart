import '../../../core/utility/pms_exports.dart';

abstract class ProjectProgressRepo {
  static Future<dynamic> getProjectProgress() async {
    return await Network().request(
      ApiNames.ProjectProgress,
      method: ServerMethods.GET,
    );
  }
}
