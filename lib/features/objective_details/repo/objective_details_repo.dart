import '../../../config/api_names.dart';
import '../../../network/network_layer.dart';

abstract class ObjectiveDetailsRepo {
  static Future<dynamic> getObjectDetails(id) async {
    return await Network()
        .request(ApiNames.objectiveDetails(id), method: ServerMethods.GET);
  }
}
