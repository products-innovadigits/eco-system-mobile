import 'package:pms_system/features/employees_performance/model/employees_performance_model.dart';

abstract class EmployeesPerformanceEvent {
  const EmployeesPerformanceEvent();
}

class LoadPerformanceData extends EmployeesPerformanceEvent {
  final String? type;

  const LoadPerformanceData({this.type});
}

class SetEmployeeOfTheMonth extends EmployeesPerformanceEvent {
  final PerformanceEmployeeModel employee;

  const SetEmployeeOfTheMonth({required this.employee});
}
