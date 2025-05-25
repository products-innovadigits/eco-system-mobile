import 'package:eco_system/features/ats/talent_pool/repo/talent_pool_repo.dart';
import 'package:eco_system/utility/export.dart';

class TalentPoolService {
  static Future<List<CandidateModel>> getTalents(
      {required SearchEngine engine,
      List<String>? skills,
      List<String>? tags}) async {
    engine.query = {
      "page": engine.currentPage + 1,
      "limit": engine.limit,
      "search": engine.searchText,
      if (skills != null)
        ...{for (var i = 0; i < skills.length; i++) "skills[$i]": skills[i]},
      if (tags != null)
        ...{for (var i = 0; i < tags.length; i++) "tags[$i]": tags[i]},
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
