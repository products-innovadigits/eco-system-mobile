abstract class EmployeeOfMonthHistoryFiltrationEvent {
  const EmployeeOfMonthHistoryFiltrationEvent();
}

class LoadEmployeeOfMonthHistoryFilterOptions
    extends EmployeeOfMonthHistoryFiltrationEvent {
  const LoadEmployeeOfMonthHistoryFilterOptions();
}

class ApplyEmployeeOfMonthHistoryFilters
    extends EmployeeOfMonthHistoryFiltrationEvent {
  const ApplyEmployeeOfMonthHistoryFilters();
}

class ResetEmployeeOfMonthHistoryFilters
    extends EmployeeOfMonthHistoryFiltrationEvent {
  const ResetEmployeeOfMonthHistoryFilters();
}

class ClearEmployeeOfMonthHistoryFilters
    extends EmployeeOfMonthHistoryFiltrationEvent {
  const ClearEmployeeOfMonthHistoryFilters();
}
