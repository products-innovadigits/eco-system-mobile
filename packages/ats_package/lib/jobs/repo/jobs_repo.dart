import 'package:ats_package/shared/ats_exports.dart';
import 'package:core_package/core/utility/export.dart';

abstract class JobsRepo {
  static Future<JobsModel> getJobs(SearchEngine data) async {
    return await Network().request(
      ApiNames.jobs,
      query: data.query,
      method: ServerMethods.GET,
      model: JobsModel(),
      systemType: 'ats',
    );
  }
}
