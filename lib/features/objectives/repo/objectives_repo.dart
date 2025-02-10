import 'package:eco_system/model/search_engine.dart';

import '../../../config/api_names.dart';
import '../../../network/network_layer.dart';
import '../model/objectives_model.dart';

abstract class ObjectivesRepo {
  static Future<ObjectivesModel> getObjectives(SearchEngine data) async {
    return await Network().request(
      ApiNames.objectives,
      method: ServerMethods.GET,
      model: ObjectivesModel(),
    );
  }
}
