import 'package:pms_system/shared/pms_exports.dart';
import 'package:pms_system/workflow_process_details/model/document_comments_model.dart';
import 'package:pms_system/workflow_process_details/repo/workflow_process_details_repo.dart';

class DocCommentsBloc extends Bloc<AppEvent, AppState> {
  DocCommentsBloc() : super(Start()) {
    on<Delete>(_onDeleteDocumentComment);
    on<Edit>(_onEditDocumentComment);
    on<Click>(_onClick);
    on<Toggle>(_onToggleEditDocumentComment);
  }

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController editCommentCtrl = TextEditingController();
  int? _editingCommentId; // Track which comment is being edited
  CommentsData? _commentsData;

  // Check if a specific comment is being edited
  bool isCommentBeingEdited(int commentId) => _editingCommentId == commentId;

  _onClick(AppEvent event, Emitter<AppState> emit) async {
    int documentId = event.arguments as int;
    emit(Loading());
    try {
      DocumentCommentsModel res =
          await WorkflowProcessDetailsRepo.getDocComments(
            documentId: documentId,
          );

      if (res.succeeded == true && res.data != null) {
        _commentsData = res.data;
        if ((res.data!.items ?? []).isNotEmpty) {
          _editingCommentId = null;
          editCommentCtrl.clear();
          emit(Done(data: _commentsData));
        } else {
          emit(Empty());
        }
      } else {
        emit(Empty());
      }
    } catch (e) {
      emit(Error());
    }
  }

  void _onDeleteDocumentComment(Delete event, Emitter<AppState> emit) async {
    emit(Deleting());
    try {
      // Add comment using the document ID
      Response response = await WorkflowProcessDetailsRepo.deleteDocComment(
        documentId: event.commentId,
      );

      if (response.statusCode == 200) {
        add(Click(arguments: event.documentId));
      } else {
        emit(Done(data: _commentsData));
      }
    } catch (e) {
      emit(Done(data: _commentsData));
    }
  }

  void _onEditDocumentComment(Edit event, Emitter<AppState> emit) async {
    if (!formKey.currentState!.validate()) return;
    emit(Editing());
    try {
      Response response = await WorkflowProcessDetailsRepo.editDocComment(
        documentId: event.documentId,
        documentDataId: event.documentDataId,
        text: event.comment,
      );

      if (response.statusCode == 200) {
        add(Click(arguments: event.documentDataId));
        editCommentCtrl.clear();
        _editingCommentId = null;
      } else {
        emit(Done(data: _commentsData));
      }
    } catch (e) {
      emit(Done(data: _commentsData));
    }
  }

  void _onToggleEditDocumentComment(
    Toggle event,
    Emitter<AppState> emit,
  ) async {
    int commentId = event.arguments as int;

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

    emit(Done(data: _commentsData));
  }
}
