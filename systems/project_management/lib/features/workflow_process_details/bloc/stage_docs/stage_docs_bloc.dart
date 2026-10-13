import 'package:project_management/core/utility/project_management_exports.dart';

class StageDocsBloc extends Bloc<StageDocsEvent, StageDocsState> {
  final ProcessDetailsRepo repo;

  StageDocsBloc({required this.repo}) : super(const StageDocsInitial()) {
    on<AddDocumentComment>(_onAddDocumentComment);
  }

  final Map<int, TextEditingController> _controllers = {};

  TextEditingController getCommentController(int id) =>
      _controllers.putIfAbsent(id, TextEditingController.new);

  Future<void> _onAddDocumentComment(
    AddDocumentComment event,
    Emitter<StageDocsState> emit,
  ) async {
    emit(StageDocsAdding(stepDocumentId: event.stepDocumentId));
    try {
      final res = await repo.addDocComment(
        documentId: event.stepDocumentId,
        text: event.text,
      );

      if (res.succeeded == true) {
        AppCore.successToastMessage(res.data?.message ?? 'Comment added');
        _controllers[event.stepDocumentId]?.clear();
        emit(const StageDocsLoaded());
      } else {
        AppCore.errorToastMessage(res.data?.message ?? 'Failed to add comment');
        emit(const StageDocsFailure());
      }
    } catch (e) {
      emit(const StageDocsFailure());
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
