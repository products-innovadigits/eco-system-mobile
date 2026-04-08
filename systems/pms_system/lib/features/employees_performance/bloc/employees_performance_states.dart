import 'package:pms_system/features/employees_performance/model/employees_performance_model.dart';

abstract class EmployeesPerformanceState {
  const EmployeesPerformanceState();
}

class PerformanceInitial extends EmployeesPerformanceState {
  const PerformanceInitial();
}

class PerformanceLoading extends EmployeesPerformanceState {
  const PerformanceLoading();
}

class PerformanceLoaded extends EmployeesPerformanceState {
  final List<PerformanceEmployeeModel> top3;
  final List<PerformanceEmployeeModel> top10;

  const PerformanceLoaded({required this.top3, required this.top10});
}

class PerformanceFailure extends EmployeesPerformanceState {
  final String message;

  const PerformanceFailure({required this.message});
}
