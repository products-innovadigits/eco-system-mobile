import '../../shared/strategy_exports.dart';

abstract class ObjectivesRepo {
  static Future<ObjectivesModel> getObjectives(SearchEngine data) async {

    return await Network().request(
      ApiNames.objectives,
      query: data.query,
      method: ServerMethods.GET,
      model: ObjectivesModel(),
    );
  }

  static Future<CustomFieldsModel> getStrategicAxis() async {
    return await Network().request(
      ApiNames.strategicAxis,
      model: CustomFieldsModel(),
      method: ServerMethods.GET,
    );
  }
}
