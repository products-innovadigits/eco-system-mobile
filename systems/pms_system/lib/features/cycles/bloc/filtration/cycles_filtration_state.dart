abstract class CyclesFiltrationState {
  const CyclesFiltrationState();
}

class CyclesFiltrationInitial extends CyclesFiltrationState {
  const CyclesFiltrationInitial();
}

class CyclesFiltrationLoaded extends CyclesFiltrationState {
  final bool isFilterApplied;

  const CyclesFiltrationLoaded({this.isFilterApplied = false});
}
