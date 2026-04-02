import 'package:pms_system/core/pms_prototype_data.dart';
import 'package:pms_system/core/utility/pms_exports.dart';
import 'package:pms_system/features/cycles/domain/cycles_repo.dart';
import 'package:pms_system/features/cycles/model/cycles_model.dart';

/// Prototype: simulated appraisal cycles — no API.
class CyclesRepoImpl implements CyclesRepo {
  final Network network;

  CyclesRepoImpl({required this.network});

  @override
  Future<CyclesModel> getCycles(SearchEngine data) async {
    await Future.delayed(const Duration(milliseconds: 220));
    return buildPrototypeCyclesModel();
  }
}
