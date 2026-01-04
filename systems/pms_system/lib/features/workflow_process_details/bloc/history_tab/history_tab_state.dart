import 'package:pms_system/features/workflow_process_details/model/history_model.dart';

/// Base state for HistoryTabBloc
abstract class HistoryTabState {
  const HistoryTabState();
}

/// Initial state
class HistoryTabInitial extends HistoryTabState {
  const HistoryTabInitial();
}

/// Loading history data
class HistoryTabLoading extends HistoryTabState {
  const HistoryTabLoading();
}

/// History data loaded successfully
class HistoryTabLoaded extends HistoryTabState {
  final HistoryResponseModel historyData;

  const HistoryTabLoaded({required this.historyData});
}

/// No history found (empty result)
class HistoryTabEmpty extends HistoryTabState {
  const HistoryTabEmpty();
}

/// Error loading history
class HistoryTabFailure extends HistoryTabState {
  final String message;

  const HistoryTabFailure({required this.message});
}
