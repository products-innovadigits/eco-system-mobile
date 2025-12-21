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

  // Map to store FormKey for each document
  final Map<int, GlobalKey<FormState>> _formKeys = {};
  CurrentStepDocumentData? currentStepDocumentData;
  int addingDocumentId = 0;

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
      emit(Error());
    }
  }

  void _onAddDocumentComment(
    AddDocumentComment event,
    Emitter<AppState> emit,
  ) async {
    addingDocumentId = event.stepDocumentId;
    final comment = (event.text as String? ?? '').trim();
    final formKey = _formKeys[event.stepDocumentId];
    if (formKey == null || !formKey.currentState!.validate()) return;
    if (comment.isEmpty) {
      return;
    }
    emit(Adding());
    try {
      // Add comment using the document ID
      Response response = await WorkflowProcessDetailsRepo.addDocComment(
        documentId: event.stepDocumentId,
        text: comment,
        // projectId: event.projectId,
        // processId: event.processId,
        // stepId: event.stepId,
      );

      if (response.statusCode == 200) {
        // Clear the controller for this specific document
        _commentControllers[event.stepDocumentId]?.clear();
        addingDocumentId = 0;
        emit(Done(data: currentStepDocumentData));
      } else {
        addingDocumentId = 0;
        emit(Error());
      }
    } catch (e) {
      addingDocumentId = 0;
      emit(Error());
    }
  }

  /// Initialize TextEditingController and FormKey for each document
  void _initializeCommentControllers() {
    _disposeControllers();

    if (currentStepDocumentData?.items != null) {
      for (CurrentStepDocumentItem? document
          in currentStepDocumentData!.items!) {
        if (document?.id != null) {
          final documentId = document!.id!;
          _commentControllers[documentId] = TextEditingController();
          _formKeys[documentId] = GlobalKey<FormState>();
        }
      }
    }
  }

  /// Get TextEditingController for a specific document
  /// Creates one if it doesn't exist (lazy initialization)
  TextEditingController? getCommentController(int documentId) {
    if (documentId == 0) return null;
    return _commentControllers.putIfAbsent(
      documentId,
      () => TextEditingController(),
    );
  }

  /// Get FormKey for a specific document
  /// Creates one if it doesn't exist (lazy initialization)
  GlobalKey<FormState>? getFormKey(int documentId) {
    if (documentId == 0) return null;
    return _formKeys.putIfAbsent(documentId, () => GlobalKey<FormState>());
  }

  /// Dispose all controllers and form keys
  void _disposeControllers() {
    for (var controller in _commentControllers.values) {
      controller.dispose();
    }
    _commentControllers.clear();
    _formKeys.clear();
  }

  @override
  Future<void> close() {
    _disposeControllers();
    return super.close();
  }
}
