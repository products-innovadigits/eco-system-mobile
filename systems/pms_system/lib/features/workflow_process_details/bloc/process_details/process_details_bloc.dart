import 'package:pms_system/core/utility/pms_exports.dart';
import 'package:pms_system/features/workflow_process_details/bloc/process_details/process_details_events.dart';
import 'package:pms_system/features/workflow_process_details/bloc/process_details/process_details_state.dart';
import 'package:pms_system/features/workflow_process_details/model/process_details_model.dart';
import 'package:pms_system/features/workflow_process_details/model/stage_doc_model.dart';
import 'package:pms_system/features/workflow_process_details/repo/process_details_repo.dart';

class ProcessDetailsBloc
    extends Bloc<ProcessDetailsEvent, ProcessDetailsState> {
  ProcessDetailsBloc() : super(const ProcessDetailsInitial()) {
    on<LoadProcessDetails>(_onLoadWorkflowProcessDetails);
    on<StartProcess>(_onStartProcess);
    on<SelectProcessTab>(_onSelectTab);
  }

  ProcessTabsEnum selectedTab = ProcessTabsEnum.followProcess;
  ProcessDetailsModel? _cachedModel;
  StageDocData? stageDocsData;

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

  Future<void> _onLoadWorkflowProcessDetails(
    LoadProcessDetails event,
    Emitter<ProcessDetailsState> emit,
  ) async {
    emit(const ProcessDetailsLoading());
    try {
      ProcessDetailsModel res = await ProcessDetailsRepo.getProcessDetails(
        processId: event.processId,
        projectId: event.projectId,
      );

      if (res.data != null && res.data!.isNotEmpty) {
        await getCurrentNextStep(
          projectId: event.projectId,
          processId: event.processId,
        );
        _cachedModel = res;
        emit(ProcessDetailsLoaded(processDetails: res));
      } else {
        emit(const ProcessDetailsEmpty());
      }
    } catch (e) {
      emit(
        const ProcessDetailsFailure(
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
        AppCore.successMessage(
          allTranslations.text(LocaleKeys.process_started_successfully),
        );
        add(
          LoadProcessDetails(
            processId: event.processId,
            projectId: event.projectId,
          ),
        );
        emit(ProcessStarted());
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
      emit(ProcessDetailsLoaded(processDetails: _cachedModel!));
    } else {
      // If no cached model, emit failure
      emit(const ProcessDetailsFailure(message: 'No cached process details'));
    }
  }
}
