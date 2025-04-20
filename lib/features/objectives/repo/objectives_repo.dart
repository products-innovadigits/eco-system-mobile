import 'package:eco_system/model/search_engine.dart';

import '../../../config/api_names.dart';
import '../../../model/custom_field_model.dart';
import '../../../network/network_layer.dart';
import '../model/objectives_model.dart';

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
