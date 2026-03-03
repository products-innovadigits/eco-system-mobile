import 'package:pms_system/core/utility/pms_exports.dart';
import 'package:pms_system/features/cycles/model/cycles_model.dart';

abstract class CyclesRepo {
  Future<CyclesModel> getCycles(SearchEngine data);
}
