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
  final EmployeesPerformanceDataModel data;

  const PerformanceLoaded({required this.data});
}

class PerformanceFailure extends EmployeesPerformanceState {
  final String message;

  const PerformanceFailure({required this.message});
}
