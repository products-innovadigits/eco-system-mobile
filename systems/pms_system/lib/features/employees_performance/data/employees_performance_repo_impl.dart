import 'package:pms_system/core/pms_prototype_employees.dart';
import 'package:pms_system/core/utility/pms_exports.dart';
import 'package:pms_system/features/employees_performance/domain/employees_performance_repo.dart';
import 'package:pms_system/features/employees_performance/model/employees_performance_model.dart';

/// Prototype: simulated performance rankings — no API (see [buildPrototypeEmployeesPerformanceModel]).
class EmployeesPerformanceRepoImpl implements EmployeesPerformanceRepo {
  final Network network;

  EmployeesPerformanceRepoImpl({required this.network});

  @override
  Future<EmployeesPerformanceModel> getPerformanceData({String? type}) async {
    await Future.delayed(const Duration(milliseconds: 800));
    return buildPrototypeEmployeesPerformanceModel(type: type);
  }

  @override
  Future<void> setEmployeeOfTheMonth({
    required int userId,
    required int reviewCycleId,
    required double score,
  }) async {
    await Future.delayed(const Duration(milliseconds: 400));
  }
}
