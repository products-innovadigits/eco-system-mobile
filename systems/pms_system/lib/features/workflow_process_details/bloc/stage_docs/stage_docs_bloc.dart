import 'package:pms_system/core/utility/pms_exports.dart';
import 'package:pms_system/features/workflow_process_details/bloc/stage_docs/stage_docs_events.dart';
import 'package:pms_system/features/workflow_process_details/bloc/stage_docs/stage_docs_state.dart';
import 'package:pms_system/features/workflow_process_details/model/current_step_document_model.dart';
import 'package:pms_system/features/workflow_process_details/repo/workflow_process_details_repo.dart';

class StageDocsBloc extends Bloc<StageDocsEvent, StageDocsState> {
  StageDocsBloc() : super(const StageDocsInitial()) {
    on<AddDocumentComment>(_onAddDocumentComment);
    on<LoadCurrentStepDocs>(_onLoadCurrentStepDocs);
  }

  // Map to store TextEditingController for each document
  final Map<int, TextEditingController> _commentControllers = {};

  // Map to store FormKey for each document
  final Map<int, GlobalKey<FormState>> _formKeys = {};
  CurrentStepDocumentData? currentStepDocumentData;
  int addingDocumentId = 0;

  Future<void> _onLoadCurrentStepDocs(
    LoadCurrentStepDocs event,
    Emitter<StageDocsState> emit,
  ) async {
    emit(const StageDocsLoading());
    try {
      CurrentStepDocumentModel res =
          await WorkflowProcessDetailsRepo.getCurrentStepDocs(
            processId: event.processId,
            projectId: event.projectId,
            projectStepId: event.projectStepId,
          );

      if (res.succeeded == true &&
          res.data != null &&
          res.data!.items != null &&
          res.data!.items!.isNotEmpty) {
        currentStepDocumentData = res.data;
        // Initialize controllers for each document
        _initializeCommentControllers();
        emit(StageDocsLoaded(documentsData: res.data!));
      } else {
        emit(const StageDocsEmpty());
      }
    } catch (e) {
      emit(
        const StageDocsFailure(
          message: 'Failed to load current step documents',
        ),
      );
    }
  }

  void _onAddDocumentComment(
    AddDocumentComment event,
    Emitter<StageDocsState> emit,
  ) async {
    addingDocumentId = event.stepDocumentId;
    final comment = event.text.trim();
    final formKey = _formKeys[event.stepDocumentId];
    if (formKey == null || !formKey.currentState!.validate()) return;
    if (comment.isEmpty) {
      return;
    }
    emit(const StageDocsAdding());
    try {
      // Add comment using the document ID
      Response response = await WorkflowProcessDetailsRepo.addDocComment(
        documentId: event.stepDocumentId,
        text: comment,
      );

      if (response.statusCode == 200) {
        // Clear the controller for this specific document
        _commentControllers[event.stepDocumentId]?.clear();
        addingDocumentId = 0;
        if (currentStepDocumentData != null) {
          emit(StageDocsLoaded(documentsData: currentStepDocumentData!));
        } else {
          emit(const StageDocsInitial());
        }
      } else {
        addingDocumentId = 0;
        emit(const StageDocsFailure(message: 'Failed to add document comment'));
      }
    } catch (e) {
      addingDocumentId = 0;
      emit(const StageDocsFailure(message: 'Failed to add document comment'));
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
