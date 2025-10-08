import 'package:pms_system/shared/pms_exports.dart';
import 'package:pms_system/workflow_process_details/model/workflow_process_details_model.dart';
import 'package:pms_system/workflow_process_details/repo/workflow_process_details_repo.dart';

class WorkflowProcessDetailsBloc extends Bloc<AppEvent, AppState> {
  WorkflowProcessDetailsBloc() : super(Start()) {
    on<Click>(_onClick);
    on<Select>(_onSelectTab);
  }

  ProcessTabsEnum selectedTab = ProcessTabsEnum.followProcess;
  WorkflowProcessDetailsModel? _cachedModel;

  _onClick(AppEvent event, Emitter<AppState> emit) async {
    Map<String, dynamic> args = event.arguments as Map<String, dynamic>;
    emit(Loading());
    try {
      WorkflowProcessDetailsModel res =
          await WorkflowProcessDetailsRepo.getWorkflowProcessDetails(
            processId: args['processId'],
            projectId: args['projectId'],
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

  Future<void> _onSelectTab(Select event, Emitter<AppState> emit) async {
    final ProcessTabsEnum tab = event.arguments as ProcessTabsEnum;
    if (selectedTab != tab) {
      selectedTab = tab;
    }

    // Emit Done with the cached model
    if (_cachedModel != null) {
      emit(Done(model: _cachedModel));
    } else {
      // If no cached model, emit error or handle appropriately
      emit(Error());
    }
  }
}
