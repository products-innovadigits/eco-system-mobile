abstract class CycleReportsEvent {
  const CycleReportsEvent();
}

class LoadCycleReports extends CycleReportsEvent {
  final int cycleId;

  const LoadCycleReports({required this.cycleId});
}
