import 'package:pms_system/core/utility/pms_exports.dart';
import 'package:pms_system/features/employee_of_month_history/model/employee_of_month_history_model.dart';
import 'package:pms_system/features/employees_learning/model/employees_filters_model.dart';

abstract class EmployeeOfMonthHistoryRepo {
  Future<EmployeeOfMonthHistoryModel> getHistory(SearchEngine data);

  Future<EmployeesFiltersModel> getFilterOptions();
}
