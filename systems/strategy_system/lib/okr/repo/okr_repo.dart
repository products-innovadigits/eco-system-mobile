import 'package:core_system/core/utility/export.dart';
import 'package:strategy_system/okr/model/okr_model.dart';

abstract class OkrRepo {
  static Future<OkrModel> getOkrData() async {
    return await Network().request(
      ApiNames.bsc,
      method: ServerMethods.GET,
      model: OkrModel()
    );
  }
}
