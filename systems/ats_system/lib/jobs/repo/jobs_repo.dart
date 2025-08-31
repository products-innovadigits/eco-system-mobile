import 'package:ats_system/shared/ats_exports.dart';
import 'package:core_system/core/utility/export.dart';

abstract class JobsRepo {
  static Future<JobsModel> getJobs(SearchEngine data) async {
    return await Network().request(
      ApiNames.jobs,
      query: data.query,
      method: ServerMethods.GET,
      model: JobsModel(),
      systemTypeEnum: ActiveSystemEnum.ats,
    );
  }
}
