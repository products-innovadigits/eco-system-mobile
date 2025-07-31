import 'package:core_package/core/utility/export.dart';
import 'package:strategy_package/okr/model/okr_model.dart';

abstract class OkrRepo {
  static Future<OkrModel> getOkrData() async {
    return await Network().request(
      ApiNames.bsc,
      method: ServerMethods.GET,
      model: OkrModel()
    );
  }
}
