import 'package:pms_system/core/utility/pms_exports.dart';

class LatestRequestRepo {
  static Future<LatestRequestModel> getLatestRequest(SearchEngine data) async {
    return await Network().request(
      ApiNames.latestRequest,
      query: data.query,
      method: ServerMethods.GET,
      model: LatestRequestModel(),
    );
  }
}
