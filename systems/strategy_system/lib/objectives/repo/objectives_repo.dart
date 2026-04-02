import '../../shared/strategy_exports.dart';
import '../../shared/strategy_prototype_data.dart';

/// Prototype: simulated objectives list and filters — no API.
abstract class ObjectivesRepo {
  static Future<ObjectivesModel> getObjectives(SearchEngine data) async {
    await Future.delayed(const Duration(milliseconds: 200));
    return buildPrototypeObjectivesModel();
  }

  static Future<CustomFieldsModel> getStrategicAxis() async {
    await Future.delayed(const Duration(milliseconds: 150));
    return buildPrototypeStrategicAxisFilters();
  }
}
