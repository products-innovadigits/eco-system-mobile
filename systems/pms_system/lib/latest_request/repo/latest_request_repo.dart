import 'package:pms_system/latest_request/model/latest_request_models.dart';
import 'package:pms_system/shared/pms_exports.dart';

class LatestRequestRepo {
  static Future<LatestRequestModel> getLatestRequest() async {
    return await Network().request(
      ApiNames.latestRequest,
      method: ServerMethods.GET,
      model: LatestRequestModel(),
    );
  }
}
