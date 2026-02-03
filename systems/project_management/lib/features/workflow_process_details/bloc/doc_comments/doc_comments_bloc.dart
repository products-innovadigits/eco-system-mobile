import 'package:project_management/core/utility/pms_exports.dart';
import 'package:project_management/shared/model/default_response_model.dart';

class DocCommentsBloc extends Bloc<DocCommentsEvent, DocCommentsState> {
  final ProcessDetailsRepo repo;
  final bool _ownsController;

  DocCommentsBloc({
    required this.repo,
    TextEditingController? commentController,
  })  : _ownsController = commentController == null,
        commentTEC = commentController ?? TextEditingController(),
        super(const DocCommentsInitial()) {
    on<DeleteDocComment>(_onDeleteDocumentComment);
    on<EditDocComment>(_onEditDocumentComment);
    on<LoadDocComments>(_onLoadDocComments);
    on<ToggleEditComment>(_onToggleEditDocumentComment);
  }

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController commentTEC;
  int? _editingCommentId; // Track which comment is being edited
  CommentsData? _commentsData;

  // Check if a specific comment is being edited
  bool isCommentBeingEdited(int commentId) => _editingCommentId == commentId;

  Future<void> _onLoadDocComments(
    LoadDocComments event,
    Emitter<DocCommentsState> emit,
  ) async {
    emit(const DocCommentsLoading());
    try {
      DocumentCommentsModel res = await repo.getDocComments(
        documentId: event.documentId,
      );

      if (res.succeeded == true && res.data != null) {
        _commentsData = res.data;
        if ((res.data!.items ?? []).isNotEmpty) {
          _editingCommentId = null;
          commentTEC.clear();
          emit(DocCommentsLoaded(commentsData: res.data!));
        } else {
          emit(const DocCommentsEmpty());
        }
      } else {
        emit(const DocCommentsEmpty());
      }
    } catch (e) {
      emit(const DocCommentsFailure());
    }
  }

  void _onDeleteDocumentComment(
    DeleteDocComment event,
    Emitter<DocCommentsState> emit,
  ) async {
    emit(const DocCommentsDeleting());
    try {
      // Delete comment using the document ID
      DefaultResponseModel response = await repo.deleteDocComment(
        documentId: event.commentId,
      );

      if (response.succeeded == true) {
        AppCore.successToastMessage(
          response.data?.message ?? 'Comment deleted successfully',
        );
        add(LoadDocComments(documentId: event.documentId));
      } else {
        AppCore.errorToastMessage(
          response.data?.message ?? 'Failed to delete comment',
        );
        if (_commentsData != null) {
          emit(DocCommentsLoaded(commentsData: _commentsData!));
        } else {
          emit(const DocCommentsFailure());
        }
      }
    } catch (e) {
      if (_commentsData != null) {
        emit(DocCommentsLoaded(commentsData: _commentsData!));
      } else {
        emit(const DocCommentsFailure());
      }
    }
  }

  void _onEditDocumentComment(
    EditDocComment event,
    Emitter<DocCommentsState> emit,
  ) async {
    if (!formKey.currentState!.validate()) return;
    emit(const DocCommentsEditing());
    try {
      DefaultResponseModel response = await repo.editDocComment(
        documentId: event.documentId,
        documentDataId: event.documentDataId,
        text: event.comment,
      );

      if (response.succeeded == true) {
        add(LoadDocComments(documentId: event.documentDataId));
        commentTEC.clear();
        _editingCommentId = null;
        AppCore.successToastMessage(
          response.data?.message ?? 'Comment edited successfully',
        );
      } else {
        AppCore.errorToastMessage(
          response.data?.message ?? 'Failed to edit comment',
        );
        if (_commentsData != null) {
          emit(DocCommentsLoaded(commentsData: _commentsData!));
        } else {
          emit(const DocCommentsFailure());
        }
      }
    } catch (e) {
      if (_commentsData != null) {
        emit(DocCommentsLoaded(commentsData: _commentsData!));
      } else {
        emit(const DocCommentsFailure());
      }
    }
  }

  void _onToggleEditDocumentComment(
    ToggleEditComment event,
    Emitter<DocCommentsState> emit,
  ) async {
    int commentId = event.commentId;

    if (_editingCommentId == commentId) {
      // If this comment is already being edited, stop editing
      _editingCommentId = null;
      commentTEC.clear();
    } else {
      // If a different comment is being edited, switch to this one
      _editingCommentId = commentId;
      // Set the current text in the controller
      final comment = _commentsData?.items?.firstWhere(
        (c) => c.id == commentId,
        orElse: () => DocumentComment(),
      );
      commentTEC.text = comment?.text ?? '';
    }

    if (_commentsData != null) {
      emit(DocCommentsLoaded(commentsData: _commentsData!));
    } else {
      emit(const DocCommentsInitial());
    }
  }

  @override
  Future<void> close() {
    if (_ownsController) {
      commentTEC.dispose();
    }
    return super.close();
  }
}
