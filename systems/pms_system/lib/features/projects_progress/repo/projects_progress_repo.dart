import '../../../core/utility/pms_exports.dart';

abstract class ProjectProgressRepo {
  static Future<dynamic> getProjectProgress() async {
    return await Network().request(
      ApiNames.projectProgress,
      method: ServerMethods.GET,
    );
  }
}
