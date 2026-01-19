import 'package:pms_system/core/utility/pms_exports.dart';
import 'package:pms_system/features/workflow_process_details/bloc/stage_docs/stage_docs_events.dart';
import 'package:pms_system/features/workflow_process_details/bloc/stage_docs/stage_docs_state.dart';
import 'package:pms_system/features/workflow_process_details/model/current_step_document_model.dart';
import 'package:pms_system/features/workflow_process_details/repo/process_details_repo.dart';
import 'package:pms_system/shared/model/default_response_model.dart';

class StageDocsBloc extends Bloc<StageDocsEvent, StageDocsState> {
  StageDocsBloc() : super(const StageDocsInitial()) {
    on<AddDocumentComment>(_onAddDocumentComment);
    on<CreateCurrentStepDocs>(_onCreateCurrentStepDocs);
  }

  // Map to store TextEditingController for each document
  final Map<int, TextEditingController> _commentControllers = {};

  // Map to store FormKey for each document
  final Map<int, GlobalKey<FormState>> _formKeys = {};

  // CurrentStepDocumentData? currentStepDocumentData;
  int addingDocumentId = 0;

  Future<void> _onCreateCurrentStepDocs(
    CreateCurrentStepDocs event,
    Emitter<StageDocsState> emit,
  ) async {
    emit(const StageDocsLoading());
    try {
      CurrentStepDocumentModel res =
          await ProcessDetailsRepo.getCurrentStepDocs(
            processId: event.processId,
            projectId: event.projectId,
            projectStepId: event.projectStepId,
          );

      if (res.succeeded == true &&
          res.data != null &&
          res.data!.items != null &&
          res.data!.items!.isNotEmpty) {
        // currentStepDocumentData = res.data;
        // Initialize controllers for each document
        // _initializeCommentControllers();
        emit(StageDocsLoaded());
      } else {
        emit(const StageDocsEmpty());
      }
    } catch (e) {
      emit(const StageDocsFailure());
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
      DefaultResponseModel response = await ProcessDetailsRepo.addDocComment(
        documentId: event.stepDocumentId,
        text: comment,
      );

      if (response.succeeded == true) {
        // Clear the controller for this specific document
        _commentControllers[event.stepDocumentId]?.clear();
        addingDocumentId = 0;
        AppCore.successToastMessage(
          response.data?.message ?? 'Comment added successfully',
        );
        emit(StageDocsLoaded());
      } else {
        AppCore.errorToastMessage(
          response.data?.message ?? 'Failed to add comment',
        );
        addingDocumentId = 0;
        emit(const StageDocsFailure());
      }
    } catch (e) {
      addingDocumentId = 0;
      emit(const StageDocsFailure());
    }
  }

  // /// Initialize TextEditingController and FormKey for each document
  // void initializeCommentControllers({List<StageDocument>? documents}) {
  //   _disposeControllers();
  //
  //   if (documents != null) {
  //     for (StageDocument? document in documents) {
  //       if (document?.documentCopyId != null) {
  //         final documentId = document!.documentCopyId!;
  //         _commentControllers[documentId] = TextEditingController();
  //         _formKeys[documentId] = GlobalKey<FormState>();
  //       }
  //     }
  //   }
  // }

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
