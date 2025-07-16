import 'package:eco_system/features/reports/model/report_model.dart';
import 'package:pms_package/shared/pms_exports.dart';

abstract class ReportsRepo {
  static Future<ReportsModel> getReports(SearchEngine data) async {
    return await Network().request(
      ApiNames.projects,
      query: data.query,
      method: ServerMethods.GET,
      model: ReportsModel(),
    );
  }

  static Future<CustomFieldsModel> getReportsFilters() async {
    return await Network().request(
      ApiNames.projectPriorityLevels,
      model: CustomFieldsModel(),
      method: ServerMethods.GET,
    );
  }
}
