import 'package:core_system/core/network/error/network_exception.dart';
import 'package:project_management/core/utility/project_management_exports.dart';

class ProcessDetailsBloc
    extends Bloc<ProcessDetailsEvent, ProcessDetailsState> {
  final ProcessDetailsRepo repo;

  ProcessDetailsBloc({required this.repo})
    : super(const ProcessDetailsInitial()) {
    on<LoadGroupSteps>(_onLoadGroupSteps);
    on<ReloadGroupSteps>(_onReloadGroupSteps);
    on<StartProcess>(_onStartProcess);
    on<SelectProcessTab>(_onSelectProcessTab);
  }

  GroupStepsModel? _groupStepsData;
  StageDocData? _stageDocsData;
  bool _groupStepsFailed = false;
  String? _groupStepsErrorMessage;
  bool _isGroupStepsReloading = false;
  ProcessTabsEnum _selectedTab = ProcessTabsEnum.followProcess;

  ProcessTabsEnum get selectedTab => _selectedTab;

  GroupStepsModel? get getGroupStepsModel => _groupStepsData;

  StageDocData? get stageDocsData => _stageDocsData;

  /// True when the group steps call failed while the rest of the screen is
  /// still usable, so the follow process tab shows the error on its own.
  bool get groupStepsFailed => _groupStepsFailed;

  /// The message the API returned along with the failure, shown as is.
  /// Null when the failure carried none, a generic message is shown then.
  String? get groupStepsErrorMessage => _groupStepsErrorMessage;

  /// True while a tab scoped reload is running, so the follow process tab can
  /// show its own shimmer instead of the full screen one.
  bool get isGroupStepsReloading => _isGroupStepsReloading;

  Future<void> _onLoadGroupSteps(
    LoadGroupSteps event,
    Emitter<ProcessDetailsState> emit,
  ) async {
    emit(const GroupStepsLoading());

    // Group Steps and Stage Docs are independent endpoints, so they run in
    // parallel and each failure stays local: a failing Group Steps only breaks
    // the follow process tab, it must not blank the whole screen.
    final Future<bool> groupStepsFuture = _loadGroupSteps(
      processId: event.processId,
      projectId: event.projectId,
    );
    final Future<bool> stageDocsFuture = _loadStageDocs(
      processId: event.processId,
      projectId: event.projectId,
    );

    _groupStepsFailed = await groupStepsFuture;
    final bool hasStageDocs = await stageDocsFuture;

    // Nothing at all could be loaded, the whole screen is an error.
    if (_groupStepsFailed && !hasStageDocs) {
      emit(GroupStepsFailure(message: _groupStepsErrorMessage));
      return;
    }

    if (!_groupStepsFailed && (_groupStepsData?.data?.isEmpty ?? true)) {
      emit(const GroupStepsEmpty());
      return;
    }

    emit(
      GroupStepsLoaded(processDetails: _groupStepsData ?? GroupStepsModel()),
    );
  }

  /// Reloads only the group steps. The shell is already rendered here, so no
  /// full screen loading or failure state is emitted: the follow process tab
  /// shows its own shimmer and, if it fails again, its own error.
  Future<void> _onReloadGroupSteps(
    ReloadGroupSteps event,
    Emitter<ProcessDetailsState> emit,
  ) async {
    _isGroupStepsReloading = true;
    emit(const GroupStepsReloading());

    _groupStepsFailed = await _loadGroupSteps(
      processId: event.processId,
      projectId: event.projectId,
    );
    _isGroupStepsReloading = false;

    if (!_groupStepsFailed && (_groupStepsData?.data?.isEmpty ?? true)) {
      emit(const GroupStepsEmpty());
      return;
    }

    emit(
      GroupStepsLoaded(processDetails: _groupStepsData ?? GroupStepsModel()),
    );
  }

  /// Loads the group steps, returns whether it failed. The API answers with
  /// `succeeded: false` and a localized message, kept in
  /// [groupStepsErrorMessage] so the follow process tab can show it.
  Future<bool> _loadGroupSteps({
    required int processId,
    required int projectId,
  }) async {
    _groupStepsErrorMessage = null;
    try {
      final GroupStepsModel groupRes = await repo.getGroupSteps(
        projectId: projectId,
        processId: processId,
      );
      if (groupRes.succeeded != true) {
        _groupStepsErrorMessage = _failureMessage(
          groupRes.validationErrors,
          groupRes.message,
        );
        return true;
      }
      _groupStepsData = groupRes;
      return false;
    } on NetworkException catch (e) {
      // The same body comes back on a 4xx, where Dio throws before the model
      // is parsed. The parsed body is carried on the exception.
      final dynamic body = e.responseData;
      if (body is Map) {
        final dynamic validationErrors = body['validationErrors'];
        final dynamic message = body['message'];
        _groupStepsErrorMessage = _failureMessage(
          validationErrors is List ? validationErrors : null,
          message is String ? message : null,
        );
      }
      return true;
    } catch (_) {
      return true;
    }
  }

  /// Picks the message to show out of a failed response. `errorMessage` holds
  /// a code, `errorMessageEn` holds the text the user should read.
  String? _failureMessage(List<dynamic>? validationErrors, String? message) {
    for (final dynamic error in validationErrors ?? const []) {
      if (error is Map) {
        final dynamic errorMessage = error['errorMessageEn'];
        if (errorMessage is String && errorMessage.trim().isNotEmpty) {
          return errorMessage.trim();
        }
      }
    }
    return (message != null && message.trim().isNotEmpty)
        ? message.trim()
        : null;
  }

  /// Loads the current/next steps, returns whether usable data is held.
  /// Previously loaded data is kept when a refresh fails.
  Future<bool> _loadStageDocs({
    required int processId,
    required int projectId,
  }) async {
    try {
      final StageDocResponseModel stageRes = await repo.getCurrentNextSteps(
        projectId: projectId,
        processId: processId,
      );
      if (stageRes.succeeded == true && stageRes.data != null) {
        _stageDocsData = stageRes.data;
      }
    } catch (_) {
      // Kept local: the header and the other tabs fall back to what is cached.
    }
    return _stageDocsData != null;
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
      // Create/Fetch docs for the new step before signaling success
      await repo.getCurrentStepDocs(
        projectId: event.projectId,
        processId: event.processId,
        projectStepId: _stageDocsData?.currentStep?.id ?? 0,
      );
      add(
        LoadGroupSteps(projectId: event.projectId, processId: event.processId),
      );
    } catch (e) {
      emit(const ProcessStartFailure());
    }
  }

  void _onSelectProcessTab(
    SelectProcessTab event,
    Emitter<ProcessDetailsState> emit,
  ) {
    _selectedTab = event.tab;
    // Emitted even without group steps data, otherwise a failed group steps
    // call would leave the user stuck on the follow process tab.
    emit(
      GroupStepsLoaded(processDetails: _groupStepsData ?? GroupStepsModel()),
    );
  }
}
