import 'package:core_package/core/utility/export.dart';

abstract class ProfileRepo {
  static Future<dynamic> getCandidateDetails(id) async {
    return await Network().request(ApiNames.candidateDetails(id),
        systemTypeEnum: ActiveSystemEnum.ats,
        method: ServerMethods.GET, query: {"scope": "profile.mini"});
  }
}
