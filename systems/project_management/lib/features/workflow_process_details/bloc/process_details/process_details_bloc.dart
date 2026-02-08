import 'package:project_management/core/utility/project_management_exports.dart';

class ProcessDetailsBloc
    extends Bloc<ProcessDetailsEvent, ProcessDetailsState> {
  final ProcessDetailsRepo repo;

  ProcessDetailsBloc({required this.repo})
      : super(const ProcessDetailsInitial()) {
    on<LoadGroupSteps>(_onLoadGroupSteps);
    on<StartProcess>(_onStartProcess);
    on<SelectProcessTab>(_onSelectProcessTab);
  }

  GroupStepsModel? _groupStepsData;
  StageDocData? _stageDocsData;
  ProcessTabsEnum _selectedTab = ProcessTabsEnum.followProcess;

  ProcessTabsEnum get selectedTab => _selectedTab;
  GroupStepsModel? get getGroupStepsModel => _groupStepsData;
  StageDocData? get stageDocsData => _stageDocsData;

  Future<void> _onLoadGroupSteps(
    LoadGroupSteps event,
    Emitter<ProcessDetailsState> emit,
  ) async {
    emit(const GroupStepsLoading());
    try {
      // Load Group Steps
      GroupStepsModel groupRes = await repo.getGroupSteps(
        projectId: event.projectId,
        processId: event.processId,
      );

      // Also load Stage Docs (Current/Next Steps)
      StageDocResponseModel stageRes = await repo.getCurrentNextSteps(
        projectId: event.projectId,
        processId: event.processId,
      );

      if (groupRes.succeeded == true) {
        _groupStepsData = groupRes;
        _stageDocsData = stageRes.data;
        if (groupRes.data?.isEmpty ?? true) {
          emit(const GroupStepsEmpty());
        } else {
          emit(GroupStepsLoaded(processDetails: groupRes));
        }
      } else {
        emit(const GroupStepsFailure(message: 'Failed to load group steps'));
      }
    } catch (e) {
      emit(GroupStepsFailure(message: e.toString()));
    }
  }

  Future<void> _onStartProcess(
    StartProcess event,
    Emitter<ProcessDetailsState> emit,
  ) async {
    emit(const ProcessStarting());
    try {
      await repo.startProcess(
        projectId: event.projectId,
        processId: event.processId,
      );
      emit(const ProcessStarted());
      add(LoadGroupSteps(projectId: event.projectId, processId: event.processId));
    } catch (e) {
      emit(const ProcessStartFailure());
    }
  }

  void _onSelectProcessTab(
    SelectProcessTab event,
    Emitter<ProcessDetailsState> emit,
  ) {
    _selectedTab = event.tab;
    if (_groupStepsData != null) {
      emit(GroupStepsLoaded(processDetails: _groupStepsData!));
    }
  }
}
