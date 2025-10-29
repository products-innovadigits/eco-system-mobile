import 'package:pms_system/shared/pms_exports.dart';
import 'package:pms_system/workflow_process_details/repo/workflow_process_details_repo.dart';

class WorkflowProcessDetailsBloc extends Bloc<AppEvent, AppState> {
  WorkflowProcessDetailsBloc({StageDocsBloc? stageDocsBloc}) : super(Start()) {
    on<Click>(_onClick);
    on<Get>(_onStartProcess);
    on<Select>(_onSelectTab);
    _stageDocsBloc = stageDocsBloc;
  }

  ProcessTabsEnum selectedTab = ProcessTabsEnum.followProcess;
  WorkflowProcessDetailsModel? _cachedModel;
  StageDocsBloc? _stageDocsBloc;

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
        _stageDocsBloc?.add(
          Click(arguments: {'projectId': projectId, 'processId': processId}),
        );
        add(Click(arguments: {'projectId': projectId, 'processId': processId}));
      } else {
        AppCore.errorMessage(
          allTranslations.text(LocaleKeys.something_went_wrong),
        );
        emit(Error());
      }
    } catch (e) {
      AppCore.errorMessage(
        allTranslations.text(LocaleKeys.something_went_wrong),
      );
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
