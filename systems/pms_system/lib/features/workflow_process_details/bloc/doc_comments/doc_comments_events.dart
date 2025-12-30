/// Events for DocCommentsBloc
abstract class DocCommentsEvent {
  const DocCommentsEvent();
}

/// Load document comments
class LoadDocComments extends DocCommentsEvent {
  final int documentId;

  const LoadDocComments({required this.documentId});
}

/// Delete a document comment
class DeleteDocComment extends DocCommentsEvent {
  final int documentId;
  final int commentId;

  const DeleteDocComment({
    required this.documentId,
    required this.commentId,
  });
}

/// Edit a document comment
class EditDocComment extends DocCommentsEvent {
  final int documentId;
  final int documentDataId;
  final String comment;

  const EditDocComment({
    required this.documentId,
    required this.documentDataId,
    required this.comment,
  });
}

/// Toggle edit mode for a comment
class ToggleEditComment extends DocCommentsEvent {
  final int commentId;

  const ToggleEditComment({required this.commentId});
}



