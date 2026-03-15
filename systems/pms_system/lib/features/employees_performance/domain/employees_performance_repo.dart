import 'package:pms_system/features/employees_performance/model/employees_performance_model.dart';

abstract class EmployeesPerformanceRepo {
  Future<EmployeesPerformanceModel> getPerformanceData();
}
