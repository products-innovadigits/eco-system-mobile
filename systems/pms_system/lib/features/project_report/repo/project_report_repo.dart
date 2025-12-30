import 'package:pms_system/core/utility/pms_exports.dart';

abstract class ProjectReportRepo {
  static Future<dynamic> getProjectReport(int id) async {
    return await Network().request(
      // ApiNames.projectReport(67),
      ApiNames.projectReport(id),
      method: ServerMethods.GET,
    );
  }
}
