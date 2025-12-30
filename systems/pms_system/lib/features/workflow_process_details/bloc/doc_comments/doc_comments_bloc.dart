import 'package:pms_system/core/utility/pms_exports.dart';
import 'package:pms_system/features/workflow_process_details/bloc/doc_comments/doc_comments_events.dart';
import 'package:pms_system/features/workflow_process_details/bloc/doc_comments/doc_comments_state.dart';
import 'package:pms_system/features/workflow_process_details/model/document_comments_model.dart';
import 'package:pms_system/features/workflow_process_details/repo/workflow_process_details_repo.dart';

class DocCommentsBloc extends Bloc<DocCommentsEvent, DocCommentsState> {
  DocCommentsBloc() : super(const DocCommentsInitial()) {
    on<DeleteDocComment>(_onDeleteDocumentComment);
    on<EditDocComment>(_onEditDocumentComment);
    on<LoadDocComments>(_onLoadDocComments);
    on<ToggleEditComment>(_onToggleEditDocumentComment);
  }

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController editCommentCtrl = TextEditingController();
  int? _editingCommentId; // Track which comment is being edited
  CommentsData? _commentsData;

  // Check if a specific comment is being edited
  bool isCommentBeingEdited(int commentId) => _editingCommentId == commentId;

  _onLoadDocComments(
    LoadDocComments event,
    Emitter<DocCommentsState> emit,
  ) async {
    emit(const DocCommentsLoading());
    try {
      DocumentCommentsModel res =
          await WorkflowProcessDetailsRepo.getDocComments(
            documentId: event.documentId,
          );

      if (res.succeeded == true && res.data != null) {
        _commentsData = res.data;
        if ((res.data!.items ?? []).isNotEmpty) {
          _editingCommentId = null;
          editCommentCtrl.clear();
          emit(DocCommentsLoaded(commentsData: res.data!));
        } else {
          emit(const DocCommentsEmpty());
        }
      } else {
        emit(const DocCommentsEmpty());
      }
    } catch (e) {
      emit(
        const DocCommentsFailure(
          message: 'Failed to load document comments',
        ),
      );
    }
  }

  void _onDeleteDocumentComment(
    DeleteDocComment event,
    Emitter<DocCommentsState> emit,
  ) async {
    emit(const DocCommentsDeleting());
    try {
      // Delete comment using the document ID
      Response response = await WorkflowProcessDetailsRepo.deleteDocComment(
        documentId: event.commentId,
      );

      if (response.statusCode == 200) {
        add(LoadDocComments(documentId: event.documentId));
      } else {
        if (_commentsData != null) {
          emit(DocCommentsLoaded(commentsData: _commentsData!));
        } else {
          emit(
            const DocCommentsFailure(
              message: 'Failed to delete comment',
            ),
          );
        }
      }
    } catch (e) {
      if (_commentsData != null) {
        emit(DocCommentsLoaded(commentsData: _commentsData!));
      } else {
        emit(
          const DocCommentsFailure(
            message: 'Failed to delete comment',
          ),
        );
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
      Response response = await WorkflowProcessDetailsRepo.editDocComment(
        documentId: event.documentId,
        documentDataId: event.documentDataId,
        text: event.comment,
      );

      if (response.statusCode == 200) {
        add(LoadDocComments(documentId: event.documentDataId));
        editCommentCtrl.clear();
        _editingCommentId = null;
      } else {
        if (_commentsData != null) {
          emit(DocCommentsLoaded(commentsData: _commentsData!));
        } else {
          emit(
            const DocCommentsFailure(
              message: 'Failed to edit comment',
            ),
          );
        }
      }
    } catch (e) {
      if (_commentsData != null) {
        emit(DocCommentsLoaded(commentsData: _commentsData!));
      } else {
        emit(
          const DocCommentsFailure(
            message: 'Failed to edit comment',
          ),
        );
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
      editCommentCtrl.clear();
    } else {
      // If a different comment is being edited, switch to this one
      _editingCommentId = commentId;
      // Set the current text in the controller
      final comment = _commentsData?.items?.firstWhere(
        (c) => c.id == commentId,
        orElse: () => DocumentComment(),
      );
      editCommentCtrl.text = comment?.text ?? '';
    }

    if (_commentsData != null) {
      emit(DocCommentsLoaded(commentsData: _commentsData!));
    } else {
      emit(const DocCommentsInitial());
    }
  }
}

