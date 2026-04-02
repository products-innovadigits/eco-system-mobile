import 'package:core_system/core/utility/export.dart';
import 'package:strategy_system/okr/model/okr_model.dart';
import 'package:strategy_system/shared/strategy_prototype_data.dart';

/// Prototype: simulated OKR tree — no API.
abstract class OkrRepo {
  static Future<OkrModel> getOkrData() async {
    await Future.delayed(const Duration(milliseconds: 250));
    return buildPrototypeOkrModel();
  }
}
