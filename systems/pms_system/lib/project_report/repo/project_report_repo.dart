import 'package:core_system/core/utility/export.dart';

abstract class ProjectReportRepo {
  static Future<dynamic> getProjectReport(int id) async {
    return await Network().request(
      'Project/Report?id=67',
      method: ServerMethods.GET,
    );
  }
}

