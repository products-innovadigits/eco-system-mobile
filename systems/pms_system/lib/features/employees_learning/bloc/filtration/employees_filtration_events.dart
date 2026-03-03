abstract class EmployeesFiltrationEvent {
  const EmployeesFiltrationEvent();
}

class LoadEmployeesFilterOptions extends EmployeesFiltrationEvent {
  const LoadEmployeesFilterOptions();
}

class ApplyEmployeesFilters extends EmployeesFiltrationEvent {
  const ApplyEmployeesFilters();
}

class ResetEmployeesFilters extends EmployeesFiltrationEvent {
  const ResetEmployeesFilters();
}

class ClearEmployeesFilters extends EmployeesFiltrationEvent {
  const ClearEmployeesFilters();
}
