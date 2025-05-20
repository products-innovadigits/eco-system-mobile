import 'package:eco_system/features/ats/talent_pool/model/candidate_model.dart';
import 'package:eco_system/features/ats/talent_pool/repo/talent_pool_repo.dart';
import 'package:eco_system/utility/export.dart';

class TalentPoolService {
  static Future<List<CandidateModel>> getTalents(SearchEngine engine) async {
    engine.query = {
      "page": engine.currentPage + 1,
      "limit": engine.limit,
      "search": engine.searchText,
      "embed": "profile",
    };

    final res = await TalentPoolRepo.getTalents(engine);
    if (res.data != null && res.data!.isNotEmpty) {
      engine.currentPage += 1;
      engine.maxPages += 1;
      return res.data!;
    }

    return [];
  }
}
