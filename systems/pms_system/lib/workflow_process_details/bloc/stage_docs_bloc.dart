import 'package:pms_system/shared/pms_exports.dart';
import 'package:pms_system/workflow_process_details/model/current_step_document_model.dart';
import 'package:pms_system/workflow_process_details/repo/workflow_process_details_repo.dart';

class StageDocsBloc extends Bloc<AppEvent, AppState> {
  StageDocsBloc() : super(Start()) {
    on<AddDocumentComment>(_onAddDocumentComment);
    on<Click>(_onClick);
  }

  // Map to store TextEditingController for each document
  final Map<int, TextEditingController> _commentControllers = {};
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  CurrentStepDocumentData? currentStepDocumentData;


  _onClick(AppEvent event, Emitter<AppState> emit) async {
    Map<String, dynamic> args = event.arguments as Map<String, dynamic>;
    emit(Loading());
    try {
      CurrentStepDocumentModel res =
      await WorkflowProcessDetailsRepo.getCurrentStepDocs(
        processId: args['processId'],
        projectId: args['projectId'],
        projectStepId: args['projectStepId'],
      );

      if (res.succeeded == true &&
          res.data != null &&
          res.data!.items != null &&
          res.data!.items!.isNotEmpty) {
        currentStepDocumentData = res.data;
        // Initialize controllers for each document
        _initializeCommentControllers();
        emit(Done(data: currentStepDocumentData));
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
    if (!formKey.currentState!.validate()) return;
    emit(Adding());
    try {
      // Add comment using the document ID
      Response response = await WorkflowProcessDetailsRepo.addDocComment(
        documentId: event.stepDocumentId,
        text: event.text,
        // projectId: event.projectId,
        // processId: event.processId,
        // stepId: event.stepId,
      );

      if (response.statusCode == 200) {
        // Clear the controller for this specific document
        _commentControllers[event.stepDocumentId]?.clear();
        AppCore.successMessage(
          allTranslations.text(LocaleKeys.comment_added_successfully),
        );
        emit(Done(data: currentStepDocumentData));
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
    _disposeControllers();

    if (currentStepDocumentData?.items != null) {
      for (CurrentStepDocumentItem? document
          in currentStepDocumentData!.items!) {
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
