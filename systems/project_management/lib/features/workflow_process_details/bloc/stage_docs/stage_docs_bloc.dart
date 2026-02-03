import 'package:project_management/core/utility/pms_exports.dart';

class StageDocsBloc extends Bloc<StageDocsEvent, StageDocsState> {
  final ProcessDetailsRepo repo;

  StageDocsBloc({required this.repo}) : super(const StageDocsInitial()) {
    on<CreateCurrentStepDocs>(_onCreateCurrentStepDocs);
    on<AddDocumentComment>(_onAddDocumentComment);
  }

  final Map<int, GlobalKey<FormState>> _formKeys = {};
  final Map<int, TextEditingController> _controllers = {};
  int? _addingDocumentId;

  int? get addingDocumentId => _addingDocumentId;

  GlobalKey<FormState>? getFormKey(int id) {
    if (!_formKeys.containsKey(id)) {
      _formKeys[id] = GlobalKey<FormState>();
    }
    return _formKeys[id];
  }

  TextEditingController? getCommentController(int id) {
    if (!_controllers.containsKey(id)) {
      _controllers[id] = TextEditingController();
    }
    return _controllers[id];
  }

  Future<void> _onCreateCurrentStepDocs(
    CreateCurrentStepDocs event,
    Emitter<StageDocsState> emit,
  ) async {
    emit(const StageDocsLoading());
    try {
      final res = await repo.getCurrentStepDocs(
        projectId: event.projectId,
        processId: event.processId,
        projectStepId: event.projectStepId,
      );

      if (res.succeeded == true) {
        emit(const StageDocsLoaded());
      } else {
        emit(const StageDocsFailure());
      }
    } catch (e) {
      emit(const StageDocsFailure());
    }
  }

  Future<void> _onAddDocumentComment(
    AddDocumentComment event,
    Emitter<StageDocsState> emit,
  ) async {
    _addingDocumentId = event.stepDocumentId;
    emit(const StageDocsAdding());
    try {
      final res = await repo.addDocComment(
        documentId: event.stepDocumentId,
        text: event.text,
      );

      if (res.succeeded == true) {
        AppCore.successToastMessage(res.data?.message ?? 'Comment added');
        if (_controllers.containsKey(event.stepDocumentId)) {
          _controllers[event.stepDocumentId]?.clear();
        }
        emit(const StageDocsLoaded());
      } else {
        AppCore.errorToastMessage(res.data?.message ?? 'Failed to add comment');
        emit(const StageDocsFailure());
      }
    } catch (e) {
      emit(const StageDocsFailure());
    } finally {
      _addingDocumentId = null;
    }
  }

  @override
  Future<void> close() {
    for (final controller in _controllers.values) {
      controller.dispose();
    }
    return super.close();
  }
}
