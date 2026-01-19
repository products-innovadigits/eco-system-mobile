import 'package:pms_system/core/utility/pms_exports.dart';
import 'package:pms_system/features/workflow_process_details/bloc/workflow_process_details/workflow_process_details_events.dart';
import 'package:pms_system/features/workflow_process_details/bloc/workflow_process_details/workflow_process_details_state.dart';
import 'package:pms_system/features/workflow_process_details/model/stage_doc_model.dart';
import 'package:pms_system/features/workflow_process_details/model/workflow_process_details_model.dart';
import 'package:pms_system/features/workflow_process_details/repo/workflow_process_details_repo.dart';

class WorkflowProcessDetailsBloc
    extends Bloc<WorkflowProcessDetailsEvent, WorkflowProcessDetailsState> {
  WorkflowProcessDetailsBloc() : super(const WorkflowProcessDetailsInitial()) {
    on<LoadWorkflowProcessDetails>(_onLoadWorkflowProcessDetails);
    on<StartWorkflowProcess>(_onStartProcess);
    on<SelectWorkflowProcessTab>(_onSelectTab);
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

  Future<void> _onLoadWorkflowProcessDetails(
    LoadWorkflowProcessDetails event,
    Emitter<WorkflowProcessDetailsState> emit,
  ) async {
    emit(const WorkflowProcessDetailsLoading());
    try {
      WorkflowProcessDetailsModel res =
          await WorkflowProcessDetailsRepo.getWorkflowProcessDetails(
            processId: event.processId,
            projectId: event.projectId,
          );

      if (res.data != null && res.data!.isNotEmpty) {
        await getCurrentNextStep(
          projectId: event.projectId,
          processId: event.processId,
        );
        _cachedModel = res;
        emit(WorkflowProcessDetailsLoaded(processDetails: res));
      } else {
        emit(const WorkflowProcessDetailsEmpty());
      }
    } catch (e) {
      emit(
        const WorkflowProcessDetailsFailure(
          message: 'Failed to load workflow process details',
        ),
      );
    }
  }

  Future<void> _onStartProcess(
    StartWorkflowProcess event,
    Emitter<WorkflowProcessDetailsState> emit,
  ) async {
    try {
      emit(const WorkflowProcessStarting());

      final Response response = await WorkflowProcessDetailsRepo.startProcess(
        processId: event.processId,
        projectId: event.projectId,
      );

      if (response.statusCode == 200) {
        AppCore.successMessage(
          allTranslations.text(LocaleKeys.process_started_successfully),
        );
        add(
          LoadWorkflowProcessDetails(
            processId: event.processId,
            projectId: event.projectId,
          ),
        );
        emit(WorkflowProcessStarted());
      } else {
        emit(const WorkflowProcessStartFailure());
      }
    } catch (e) {
      emit(const WorkflowProcessStartFailure());
    }
  }

  Future<void> _onSelectTab(
    SelectWorkflowProcessTab event,
    Emitter<WorkflowProcessDetailsState> emit,
  ) async {
    final ProcessTabsEnum tab = event.tab;
    if (selectedTab != tab) {
      selectedTab = tab;
    }

    // Emit Loaded with the cached model
    if (_cachedModel != null) {
      emit(WorkflowProcessDetailsLoaded(processDetails: _cachedModel!));
    } else {
      // If no cached model, emit failure
      emit(
        const WorkflowProcessDetailsFailure(
          message: 'No cached process details',
        ),
      );
    }
  }
}
