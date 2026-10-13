import 'dart:developer';

import 'package:core_system/core/network/error/network_exception.dart';
import 'package:project_management/core/utility/project_management_exports.dart';
import 'package:project_management/shared/model/default_response_model.dart';

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
    await _loadScreen(
      emit,
      processId: event.processId,
      projectId: event.projectId,
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
    _emitGroupSteps(emit);
  }

  /// Loads everything the screen shows and emits the outcome.
  ///
  /// Group Steps and Current & Next are independent endpoints, so they run in
  /// parallel and each failure stays local: a failing Group Steps only breaks
  /// the follow process tab, it must not blank the whole screen.
  Future<void> _loadScreen(
    Emitter<ProcessDetailsState> emit, {
    required int processId,
    required int projectId,
  }) async {
    final Future<bool> groupStepsFuture = _loadGroupSteps(
      processId: processId,
      projectId: projectId,
    );
    final Future<bool> stageDocsFuture = _loadStageDocs(
      processId: processId,
      projectId: projectId,
    );

    _groupStepsFailed = await groupStepsFuture;
    final bool hasStageDocs = await stageDocsFuture;

    // Nothing at all could be loaded, the whole screen is an error.
    if (_groupStepsFailed && !hasStageDocs) {
      emit(GroupStepsFailure(message: _groupStepsErrorMessage));
      return;
    }
    _emitGroupSteps(emit);
  }

  void _emitGroupSteps(Emitter<ProcessDetailsState> emit) {
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
      _groupStepsErrorMessage = _networkFailureMessage(e);
      return true;
    } catch (_) {
      return true;
    }
  }

  /// The message out of a failed response's body. The same body comes back
  /// on a 4xx, where Dio throws before the model is parsed, so the parsed
  /// body is carried on the exception.
  String? _networkFailureMessage(NetworkException e) {
    final dynamic body = e.responseData;
    if (body is! Map) return null;
    final dynamic validationErrors = body['validationErrors'];
    final dynamic message = body['message'];
    return _failureMessage(
      validationErrors is List ? validationErrors : null,
      message is String ? message : null,
    );
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
  /// Previously loaded data is kept only when the call itself fails: an
  /// answered call is taken as is, otherwise a refresh that legitimately comes
  /// back without a current step would leave the screen on stale data.
  Future<bool> _loadStageDocs({
    required int processId,
    required int projectId,
  }) async {
    try {
      final StageDocResponseModel stageRes = await repo.getCurrentNextSteps(
        projectId: projectId,
        processId: processId,
      );
      if (stageRes.succeeded == true) {
        _stageDocsData = stageRes.data;
      }
    } catch (_) {
      // Kept local: the header and the other tabs fall back to what is cached.
    }
    return _stageDocsData != null;
  }

  /// Starts the process, creates the documents of the step it lands on and
  /// only then reloads the screen.
  ///
  /// Current & Next lists the documents of the current step, and those only
  /// exist once Current Step Documents has created them. Reading Current &
  /// Next before that shows the step without its documents.
  Future<void> _onStartProcess(
    StartProcess event,
    Emitter<ProcessDetailsState> emit,
  ) async {
    emit(const ProcessStarting());

    final String? startError = await _startProcess(
      processId: event.processId,
      projectId: event.projectId,
    );
    if (startError != null) {
      AppCore.errorMessage(startError);
      // Back to the screen as it was before the attempt.
      _emitGroupSteps(emit);
      return;
    }

    // The process has started, so nothing past this point reports a failure:
    // the screen reloads either way. The step cached before starting is the
    // pre-start one, so the step the process landed on is fetched first.
    final int? currentStepId = await _fetchCurrentStepId(
      processId: event.processId,
      projectId: event.projectId,
    );
    await _createStepDocs(
      processId: event.processId,
      projectId: event.projectId,
      stepId: currentStepId,
    );
    await _loadScreen(
      emit,
      processId: event.processId,
      projectId: event.projectId,
    );
  }

  /// Starts the process, returns the message to show when it did not start.
  Future<String?> _startProcess({
    required int processId,
    required int projectId,
  }) async {
    String? message;
    try {
      final DefaultResponseModel res = await repo.startProcess(
        projectId: projectId,
        processId: processId,
      );
      if (res.succeeded == true) return null;
      message = res.data?.message;
    } on NetworkException catch (e) {
      message = _networkFailureMessage(e);
    } catch (_) {}
    return (message != null && message.trim().isNotEmpty)
        ? message.trim()
        : allTranslations.text(LocaleKeys.something_went_wrong);
  }

  /// The id of the step the process is on now, null when it can't be read.
  Future<int?> _fetchCurrentStepId({
    required int processId,
    required int projectId,
  }) async {
    try {
      final StageDocResponseModel res = await repo.getCurrentNextSteps(
        projectId: projectId,
        processId: processId,
      );
      return res.succeeded == true ? res.data?.currentStep?.id : null;
    } catch (_) {
      return null;
    }
  }

  /// Creates the documents of [stepId]. A step without documents answers
  /// `succeeded: false` ("لا يوجد مستندات لهذه الخطوة"), which is not a
  /// failure of the start, so the outcome is only logged.
  Future<void> _createStepDocs({
    required int processId,
    required int projectId,
    required int? stepId,
  }) async {
    if (stepId == null || stepId == 0) return;
    try {
      await repo.getCurrentStepDocs(
        projectId: projectId,
        processId: processId,
        projectStepId: stepId,
      );
    } catch (e) {
      log('Failed to create the docs of step $stepId: $e');
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
