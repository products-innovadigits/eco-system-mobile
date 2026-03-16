abstract class CyclesFiltrationEvent {
  const CyclesFiltrationEvent();
}

class LoadCyclesFilterOptions extends CyclesFiltrationEvent {
  const LoadCyclesFilterOptions();
}

class ApplyCyclesFilters extends CyclesFiltrationEvent {
  const ApplyCyclesFilters();
}

class ResetCyclesFilters extends CyclesFiltrationEvent {
  const ResetCyclesFilters();
}

class ClearCyclesFilters extends CyclesFiltrationEvent {
  const ClearCyclesFilters();
}
