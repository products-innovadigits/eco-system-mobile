import 'package:eco_system/features/ats/talent_pool/repo/talent_pool_repo.dart';
import 'package:eco_system/utility/export.dart';

class TalentPoolService {
  static Future<TalentPoolModel> getTalents({
    required SearchEngine engine,
    CandidateFilterModel? filters,
  }) async {
    Map<String, dynamic> queryParams = {
      "page": engine.currentPage + 1,
      "limit": engine.limit,
      "search": engine.searchText,
      "embed": "profile",
    };

    if (filters != null) {
      if (filters.expectedSalaryFrom != null) {
        queryParams['expected_salary_from'] = filters.expectedSalaryFrom;
      }
      if (filters.expectedSalaryTo != null) {
        queryParams['expected_salary_to'] = filters.expectedSalaryTo;
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

    final res = await TalentPoolRepo.getTalents(engine);

    engine.currentPage += 1;
    engine.maxPages += 1;
    return res;
  }
}
