import 'package:pms_system/features/employees_learning/model/employees_filters_model.dart';

abstract class EmployeeOfMonthHistoryFiltrationState {
  const EmployeeOfMonthHistoryFiltrationState();
}

class EmployeeOfMonthHistoryFiltrationInitial
    extends EmployeeOfMonthHistoryFiltrationState {
  const EmployeeOfMonthHistoryFiltrationInitial();
}

class EmployeeOfMonthHistoryFiltrationLoading
    extends EmployeeOfMonthHistoryFiltrationState {
  const EmployeeOfMonthHistoryFiltrationLoading();
}

class EmployeeOfMonthHistoryFiltrationLoaded
    extends EmployeeOfMonthHistoryFiltrationState {
  final EmployeesFiltersData filterOptions;
  final bool isFilterApplied;

  const EmployeeOfMonthHistoryFiltrationLoaded({
    required this.filterOptions,
    this.isFilterApplied = false,
  });
}

class EmployeeOfMonthHistoryFiltrationFailure
    extends EmployeeOfMonthHistoryFiltrationState {
  final String message;

  const EmployeeOfMonthHistoryFiltrationFailure({required this.message});
}
