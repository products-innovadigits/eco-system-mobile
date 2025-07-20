import 'package:core_package/core/utility/export.dart';
import 'package:strategy_package/bsc/model/bsc_model.dart';

abstract class BscRepo {
  static Future<BscModel> getBscData() async {
    return await Network().request(
      ApiNames.bsc,
      method: ServerMethods.GET,
      model: BscModel()
    );
  }
}
