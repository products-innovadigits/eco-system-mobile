import 'package:core_system/core/utility/export.dart';

import '../../shared/ats_exports.dart';
import '../repo/talent_pool_repo.dart';

class TalentPoolService {
  static Future<TalentPoolModel> getTalents({
    required SearchEngine engine,
    CandidateFilterModel? filters,
    String? sortingKey,
  }) async {
    final Map<String, dynamic> queryParams = {
      "page": engine.currentPage + 1,
      "limit": engine.limit,
      "embed": "profile",
      if (sortingKey != null) "sorting_key": sortingKey,
    };
    final q = engine.searchText?.trim();
    if (q != null && q.isNotEmpty) {
      queryParams["search"] = q;
    }

    if (filters != null) {
      if (filters.salaryMin != null) {
        queryParams['salaryMin'] = filters.salaryMin;
      }
      if (filters.salaryMax != null) {
        queryParams['salaryMax'] = filters.salaryMax;
      }
      if (filters.currency != null) {
        queryParams['currency'] = filters.currency;
      }
      if (filters.experienceFrom != null) {
        queryParams['experience_from'] = filters.experienceFrom;
      }
      if (filters.experienceTo != null) {
        queryParams['experience_to'] = filters.experienceTo;
      }
      if (filters.location != null) {
        queryParams['location'] = filters.location;
      }
      if (filters.applicationDate != null) {
        queryParams['application_date'] = filters.applicationDate;
      }
      if (filters.compatibilityRate != null) {
        queryParams['compatibility_rate'] = filters.compatibilityRate;
      }
      if (filters.gender != null) {
        queryParams['gender'] = filters.gender;
      }
      if (filters.selectedSkills.isNotEmpty) {
        for (var i = 0; i < filters.selectedSkills.length; i++) {
          queryParams['skills[$i]'] = filters.selectedSkills[i].name;
        }
      }
      if (filters.selectedTags.isNotEmpty) {
        for (var i = 0; i < filters.selectedTags.length; i++) {
          queryParams['tags[$i]'] = filters.selectedTags[i].name;
        }
      }
    }

    engine.query = queryParams;

    final dynamic raw = await TalentPoolRepo.getTalents(engine);
    if (raw is! TalentPoolModel) {
      throw FormatException(
        raw is String ? raw : 'Unexpected talents response type',
      );
    }
    final TalentPoolModel model = raw;
    if (model.meta?.lastPage != null) {
      engine.maxPages = model.meta!.lastPage!;
    }
    if (model.data != null && model.data!.isNotEmpty) {
      engine.currentPage += 1;
    }
    return model;
  }
}
