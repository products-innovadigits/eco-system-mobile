import 'package:project_management/core/utility/pms_exports.dart';

class HistoryTabBloc extends Bloc<HistoryTabEvent, HistoryTabState> {
  final ProcessDetailsRepo repo;

  HistoryTabBloc({required this.repo}) : super(const HistoryTabInitial()) {
    on<LoadHistoryData>(_onLoadHistoryData);
  }

  Future<void> _onLoadHistoryData(
    LoadHistoryData event,
    Emitter<HistoryTabState> emit,
  ) async {
    emit(const HistoryTabLoading());
    try {
      HistoryResponseModel res = await repo.getHistoryData(
        processId: event.processId,
        projectId: event.projectId,
      );

      if (res.succeeded == true && res.data != null) {
        if ((res.data ?? []).isNotEmpty) {
          emit(HistoryTabLoaded(historyData: res));
        } else {
          emit(const HistoryTabEmpty());
        }
      } else {
        emit(const HistoryTabFailure(message: 'Failed to load history'));
      }
    } catch (e) {
      emit(HistoryTabFailure(message: e.toString()));
    }
  }
}
