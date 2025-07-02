import 'package:core_package/core/utility/export.dart';

abstract class ObjectiveActiveRepo {
  static Future<dynamic> getObjectivePercentage() async {
    return await Network()
        .request(ApiNames.objectActivePercentage, method: ServerMethods.GET);
  }

  static Future<dynamic> getObjectActiveCategorized() async {
    return await Network()
        .request(ApiNames.objectActiveCategorized, method: ServerMethods.GET);
  }
}
