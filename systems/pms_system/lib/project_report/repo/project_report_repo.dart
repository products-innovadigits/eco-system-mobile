import 'package:core_system/core/utility/export.dart';

abstract class ProjectReportRepo {
  static Future<dynamic> getProjectReport(int id) async {
    return await Network().request(
      ApiNames.projectReport(67),
      // ApiNames.projectReport(id),
      method: ServerMethods.GET,
    );
  }
}

