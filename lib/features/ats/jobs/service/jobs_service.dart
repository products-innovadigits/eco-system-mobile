import 'package:eco_system/features/ats/jobs/repo/jobs_repo.dart';
import 'package:eco_system/utility/export.dart';

class JobsService {
  static Future<List<JobDataModel>> getJobs(
      {required SearchEngine engine}) async {
    engine.query = {
      "page": engine.currentPage + 1,
      "limit": engine.limit,
      "search": engine.searchText,
      "title": engine.searchText
    };

    final res = await JobsRepo.getJobs(engine);
    if (res.data != null && res.data!.isNotEmpty) {
      engine.currentPage += 1;
      engine.maxPages += 1;
      return res.data!;
    }

    return [];
  }
}
