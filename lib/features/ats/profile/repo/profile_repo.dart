import '../../../../utility/export.dart';

abstract class ProfileRepo {
  static Future<dynamic> getCandidateDetails(id) async {
    return await Network().request(ApiNames.candidateDetails(id),
        method: ServerMethods.GET, query: {"scope": "profile.mini"});
  }
}
