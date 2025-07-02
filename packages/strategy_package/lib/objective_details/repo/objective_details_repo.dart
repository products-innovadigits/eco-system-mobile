import 'package:core_package/core/utility/export.dart';

abstract class ObjectiveDetailsRepo {
  static Future<dynamic> getObjectDetails(id) async {
    return await Network()
        .request(ApiNames.objectiveDetails(id), method: ServerMethods.GET);
  }

  static Future<dynamic> getObjectiveKPIS(id) async {
    return await Network().request(ApiNames.objectiveKPIS,
        query: {"id": id}, method: ServerMethods.GET);
  }

  static Future<dynamic> getObjectiveInitiatives(id) async {
    return await Network().request(ApiNames.objectiveInitiatives,
        query: {"id": id}, method: ServerMethods.GET);
  }

  static Future<dynamic> getObjectiveChartData(
      {required int id, required String time}) async {
    return await Network().request(ApiNames.objectiveChartData(id, time),
        method: ServerMethods.GET);
  }
}
