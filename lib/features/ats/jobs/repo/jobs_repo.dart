import 'package:eco_system/features/ats/jobs/model/jobs_model.dart';
import 'package:eco_system/utility/export.dart';

abstract class JobsRepo {
  static Future<JobsModel> getJobs(SearchEngine data) async {
    return await Network().request(
      ApiNames.jobs,
      query: data.query,
      method: ServerMethods.GET,
      model: JobsModel(),
    );
  }
}
