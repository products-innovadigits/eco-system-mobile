import 'package:pms_system/shared/pms_exports.dart';
import 'package:pms_system/workflow_process_details/repo/workflow_process_details_repo.dart';

class StageDocsBloc extends Bloc<AppEvent, AppState> {
  StageDocsBloc() : super(Start()) {
    on<AddDocumentComment>(_onAddDocumentComment);
    on<Click>(_onClick);
  }

  // Map to store TextEditingController for each document
  final Map<int, TextEditingController> _commentControllers = {};
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  StageDocData? stageDocsData;

  _onClick(AppEvent event, Emitter<AppState> emit) async {
    Map<String, dynamic> args = event.arguments as Map<String, dynamic>;
    emit(Loading());
    try {
      StageDocResponseModel res = await WorkflowProcessDetailsRepo.getStageDocs(
        processId: args['processId'],
        projectId: args['projectId'],
      );

      if (res.succeeded == true &&
          res.data != null &&
          res.data!.currentStep != null &&
          (res.data!.currentStep!.stepDocuments ?? []).any(
            (doc) => doc != null,
          )) {
        stageDocsData = res.data;
        // Initialize controllers for each document
        _initializeCommentControllers();
        emit(Done(data: stageDocsData));
      } else {
        emit(Empty());
      }
    } catch (e) {
      AppCore.errorMessage(allTranslations.text('something_went_wrong'));

      emit(Error());
    }
  }

  void _onAddDocumentComment(
    AddDocumentComment event,
    Emitter<AppState> emit,
  ) async {
    if(!formKey.currentState!.validate()) return;
    emit(Getting());
    try {
    // Add comment using the document ID
    Response response = await WorkflowProcessDetailsRepo.addDocComment(
      documentId: event.documentId,
      text: event.text,
      // projectId: event.projectId,
      // processId: event.processId,
      // stepId: event.stepId,
    );

    if (response.statusCode == 200) {
      // Clear the controller for this specific document
      _commentControllers[event.documentId]?.clear();
      AppCore.successMessage(allTranslations.text(LocaleKeys.comment_added_successfully));
      emit(Done(data: stageDocsData));
    } else {
      AppCore.errorMessage(allTranslations.text('something_went_wrong'));
      emit(Error());
    }
    } catch (e) {
      AppCore.errorMessage(allTranslations.text('something_went_wrong'));
      emit(Error());
    }
  }

  /// Initialize TextEditingController for each document
  void _initializeCommentControllers() {
    // Dispose existing controllers
    _disposeControllers();

    if (stageDocsData?.currentStep?.stepDocuments != null) {
      for (StageDocument? document
          in stageDocsData!.currentStep!.stepDocuments!) {
        if (document?.id != null) {
          _commentControllers[document!.id!] = TextEditingController();
        }
      }
    }
  }

  /// Get TextEditingController for a specific document
  TextEditingController? getCommentController(int documentId) {
    return _commentControllers[documentId];
  }

  /// Dispose all controllers
  void _disposeControllers() {
    for (var controller in _commentControllers.values) {
      controller.dispose();
    }
    _commentControllers.clear();
  }

  @override
  Future<void> close() {
    _disposeControllers();
    return super.close();
  }
}
