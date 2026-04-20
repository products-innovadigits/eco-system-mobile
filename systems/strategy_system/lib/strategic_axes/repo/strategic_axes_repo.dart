import 'package:core_system/core/utility/export.dart';
import 'package:strategy_system/bsc/model/bsc_model.dart';

abstract class StrategicAxesRepo {
  static Future<BscModel> getBscData() async {
    return await Network().request(
      ApiNames.bsc,
      method: ServerMethods.GET,
      model: BscModel(),
    );
  }
}
