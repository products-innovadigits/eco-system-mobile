import '../../../config/api_names.dart';
import '../../../network/network_layer.dart';

abstract class ObjectiveActiveRepo {
  static Future<dynamic> getObjectActivePercentage() async {
    return await Network()
        .request(ApiNames.objectActivePercentage, method: ServerMethods.GET);
  }

  static Future<dynamic> getObjectActiveCategorized() async {
    return await Network()
        .request(ApiNames.objectActiveCategorized, method: ServerMethods.GET);
  }
}
