import '../../../config/api_names.dart';
import '../../../network/network_layer.dart';

abstract class ObjectiveDetailsRepo {
  static Future<dynamic> getObjectDetails(id) async {
    return await Network()
        .request(ApiNames.objectiveDetails(id), method: ServerMethods.GET);
  }

  static Future<dynamic> getObjectiveIndicators(id) async {
    return await Network()
        .request(ApiNames.objectiveIndicators(id), method: ServerMethods.GET);
  }

  static Future<dynamic> getObjectiveInitiatives(id) async {
    return await Network()
        .request(ApiNames.objectiveInitiatives(id), method: ServerMethods.GET);
  }

  static Future<dynamic> getObjectiveChartData(
      {required int id, required String filterType}) async {
    return await Network().request(ApiNames.objectiveChartData(id),
        query: {"filterType": filterType}, method: ServerMethods.GET);
  }
}
