import 'package:pms_system/core/utility/pms_exports.dart';
import 'package:pms_system/features/workflow_process_details/bloc/history_tab/history_tab_events.dart';
import 'package:pms_system/features/workflow_process_details/bloc/history_tab/history_tab_state.dart';
import 'package:pms_system/features/workflow_process_details/model/history_model.dart';
import 'package:pms_system/features/workflow_process_details/repo/workflow_process_details_repo.dart';

class HistoryTabBloc extends Bloc<HistoryTabEvent, HistoryTabState> {
  HistoryTabBloc() : super(const HistoryTabInitial()) {
    on<LoadHistoryData>(_onLoadHistoryData);
  }

  HistoryResponseModel? _cachedModel;

  _onLoadHistoryData(
    LoadHistoryData event,
    Emitter<HistoryTabState> emit,
  ) async {
    emit(const HistoryTabLoading());
    try {
      HistoryResponseModel res =
          await WorkflowProcessDetailsRepo.getHistoryData(
            processId: event.processId,
            projectId: event.projectId,
          );

      if (res.data != null && res.data!.isNotEmpty) {
        _cachedModel = res;
        emit(HistoryTabLoaded(historyData: res));
      } else {
        emit(const HistoryTabEmpty());
      }
    } catch (e) {
      emit(
        const HistoryTabFailure(
          message: 'Failed to load history data',
        ),
      );
    }
  }

  HistoryResponseModel? get cachedModel => _cachedModel;
}

