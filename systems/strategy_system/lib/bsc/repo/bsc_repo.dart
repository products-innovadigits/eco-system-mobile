import 'package:core_system/core/utility/export.dart';
import 'package:strategy_system/bsc/model/bsc_model.dart';
import 'package:strategy_system/shared/strategy_prototype_data.dart';

/// Prototype: simulated BSC tree — no API.
abstract class BscRepo {
  static Future<BscModel> getBscData() async {
    await Future.delayed(const Duration(milliseconds: 250));
    return buildPrototypeBscModel();
  }
}
