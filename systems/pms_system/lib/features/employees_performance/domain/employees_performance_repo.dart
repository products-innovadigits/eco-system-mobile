import 'package:pms_system/features/employees_performance/model/employees_performance_model.dart';

abstract class EmployeesPerformanceRepo {
  Future<EmployeesPerformanceModel> getPerformanceData({String? type});

  Future<void> setEmployeeOfTheMonth({
    required int userId,
    required int reviewCycleId,
    required double score,
  });
}
