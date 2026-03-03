import 'package:pms_system/features/employees_learning/model/employees_filters_model.dart';

abstract class EmployeesFiltrationState {
  const EmployeesFiltrationState();
}

class EmployeesFiltrationInitial extends EmployeesFiltrationState {
  const EmployeesFiltrationInitial();
}

class EmployeesFiltrationLoading extends EmployeesFiltrationState {
  const EmployeesFiltrationLoading();
}

class EmployeesFiltrationLoaded extends EmployeesFiltrationState {
  final EmployeesFiltersData filterOptions;
  final bool isFilterApplied;

  const EmployeesFiltrationLoaded({
    required this.filterOptions,
    this.isFilterApplied = false,
  });
}

class EmployeesFiltrationFailure extends EmployeesFiltrationState {
  final String message;

  const EmployeesFiltrationFailure({required this.message});
}
