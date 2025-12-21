import 'package:pms_system/shared/pms_exports.dart';
import 'package:pms_system/workflow_process_details/repo/workflow_process_details_repo.dart';

class WorkflowProcessDetailsBloc extends Bloc<AppEvent, AppState> {
  WorkflowProcessDetailsBloc() : super(Start()) {
    on<Click>(_onClick);
    on<Get>(_onStartProcess);
    on<Select>(_onSelectTab);
  }

  ProcessTabsEnum selectedTab = ProcessTabsEnum.followProcess;
  WorkflowProcessDetailsModel? _cachedModel;
  StageDocData? stageDocsData;

  Future<void> getCurrentNextStep({
    required int projectId,
    required int processId,
  }) async {
    try {
      StageDocResponseModel res =
          await WorkflowProcessDetailsRepo.getCurrentNextSteps(
            processId: processId,
            projectId: projectId,
          );

      if (res.succeeded == true && res.data != null) {
        stageDocsData = res.data;
      }
    } catch (e) {
      // Error handled silently
    }
  }

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
        await getCurrentNextStep(
          projectId: args['projectId'],
          processId: args['processId'],
        );
        _cachedModel = res;
        emit(Done(model: _cachedModel));
      } else {
        emit(Empty());
      }
    } catch (e) {
      emit(Error());
    }
  }

  Future<void> _onStartProcess(Get event, Emitter<AppState> emit) async {
    try {
      emit(Loading());

      final arguments = event.arguments as Map<String, dynamic>;
      final projectId = arguments['projectId'] as int;
      final processId = arguments['processId'] as int;

      final Response response = await WorkflowProcessDetailsRepo.startProcess(
        processId: processId,
        projectId: projectId,
      );

      if (response.statusCode == 200) {
        AppCore.successMessage(
          allTranslations.text(LocaleKeys.process_started_successfully),
        );
        add(Click(arguments: {'projectId': projectId, 'processId': processId}));
      } else {
        emit(Error());
      }
    } catch (e) {
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
