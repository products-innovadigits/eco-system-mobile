import 'package:pms_system/core/utility/pms_exports.dart';
import 'package:pms_system/features/workflow_process_details/bloc/process_details/process_details_events.dart';
import 'package:pms_system/features/workflow_process_details/bloc/process_details/process_details_state.dart';
import 'package:pms_system/features/workflow_process_details/model/process_details_model.dart';
import 'package:pms_system/features/workflow_process_details/model/stage_doc_model.dart';
import 'package:pms_system/features/workflow_process_details/repo/process_details_repo.dart';

class ProcessDetailsBloc
    extends Bloc<ProcessDetailsEvent, ProcessDetailsState> {
  ProcessDetailsBloc() : super(const ProcessDetailsInitial()) {
    on<LoadGroupSteps>(_onLoadGroupSteps);
    on<StartProcess>(_onStartProcess);
    on<SelectProcessTab>(_onSelectTab);
  }

  ProcessTabsEnum selectedTab = ProcessTabsEnum.followProcess;
  GroupStepsModel? _cachedModel;
  StageDocData? stageDocsData;

  GroupStepsModel? get getGroupStepsModel => _cachedModel;

  Future<void> getCurrentNextStep({
    required int projectId,
    required int processId,
  }) async {
    try {
      StageDocResponseModel res = await ProcessDetailsRepo.getCurrentNextSteps(
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

  Future<void> _onLoadGroupSteps(
    LoadGroupSteps event,
    Emitter<ProcessDetailsState> emit,
  ) async {
    emit(const GroupStepsLoading());
    try {
      GroupStepsModel res = await ProcessDetailsRepo.getGroupSteps(
        processId: event.processId,
        projectId: event.projectId,
      );

      if (res.data != null && res.data!.isNotEmpty) {
        _cachedModel = res;

        // Refresh current/next step info when loading steps
        await getCurrentNextStep(
          processId: event.processId,
          projectId: event.projectId,
        );

        emit(GroupStepsLoaded(processDetails: res));
      } else {
        emit(const GroupStepsEmpty());
      }
    } catch (e) {
      emit(
        const GroupStepsFailure(
          message: 'Failed to load workflow process details',
        ),
      );
    }
  }

  Future<void> _onStartProcess(
    StartProcess event,
    Emitter<ProcessDetailsState> emit,
  ) async {
    try {
      emit(const ProcessStarting());

      final Response response = await ProcessDetailsRepo.startProcess(
        processId: event.processId,
        projectId: event.projectId,
      );

      if (response.statusCode == 200) {
        final int? currentStepId = stageDocsData?.currentStep?.id;
        AppCore.successMessage(
          allTranslations.text(LocaleKeys.process_started_successfully),
        );

        if (currentStepId != null) {
          await ProcessDetailsRepo.getCurrentStepDocs(
            projectId: event.projectId,
            processId: event.processId,
            projectStepId: currentStepId,
          );

          add(
            LoadGroupSteps(
              processId: event.processId,
              projectId: event.projectId,
            ),
          );
        }

        emit(ProcessStarted());

        // 6. Signal loaded state for builders
        if (_cachedModel != null && _cachedModel!.data != null) {
          emit(GroupStepsLoaded(processDetails: _cachedModel!));
        }
      } else {
        emit(const ProcessStartFailure());
      }
    } catch (e) {
      emit(const ProcessStartFailure());
    }
  }

  Future<void> _onSelectTab(
    SelectProcessTab event,
    Emitter<ProcessDetailsState> emit,
  ) async {
    final ProcessTabsEnum tab = event.tab;
    if (selectedTab != tab) {
      selectedTab = tab;
    }

    // Emit Loaded with the cached model
    if (_cachedModel != null) {
      emit(GroupStepsLoaded(processDetails: _cachedModel!));
    } else {
      // If no cached model, emit failure
      emit(const GroupStepsFailure(message: 'No cached process details'));
    }
  }
}
