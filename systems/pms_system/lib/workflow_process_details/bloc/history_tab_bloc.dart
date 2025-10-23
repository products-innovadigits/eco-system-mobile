import 'package:pms_system/shared/pms_exports.dart';
import 'package:pms_system/workflow_process_details/model/history_model.dart';
import 'package:pms_system/workflow_process_details/repo/workflow_process_details_repo.dart';

class HistoryTabBloc extends Bloc<AppEvent, AppState> {
  HistoryTabBloc() : super(Start()) {
    on<Click>(_onClick);
  }

  HistoryResponseModel? _cachedModel;

  _onClick(AppEvent event, Emitter<AppState> emit) async {
    Map<String, dynamic> args = event.arguments as Map<String, dynamic>;
    int processId = args['processId'];
    int projectId = args['projectId'];

    emit(Loading());
    try {
      HistoryResponseModel res =
          await WorkflowProcessDetailsRepo.getHistoryData(
            processId: processId,
            projectId: projectId,
          );

      if (res.data != null && res.data!.isNotEmpty) {
        _cachedModel = res;
        emit(Done(model: _cachedModel));
      } else {
        emit(Empty());
      }
    } catch (e) {
      AppCore.errorMessage(allTranslations.text('something_went_wrong'));
      emit(Error());
    }
  }

  HistoryResponseModel? get cachedModel => _cachedModel;
}
