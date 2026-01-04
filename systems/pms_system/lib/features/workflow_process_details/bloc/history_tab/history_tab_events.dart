/// Events for HistoryTabBloc
abstract class HistoryTabEvent {
  const HistoryTabEvent();
}

/// Load history data
class LoadHistoryData extends HistoryTabEvent {
  final int processId;
  final int projectId;

  const LoadHistoryData({required this.processId, required this.projectId});
}

