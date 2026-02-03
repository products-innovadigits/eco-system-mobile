import 'package:project_management/features/workflow_process_details/model/document_comments_model.dart';

/// Base state for DocCommentsBloc
abstract class DocCommentsState {
  const DocCommentsState();
}

/// Initial state
class DocCommentsInitial extends DocCommentsState {
  const DocCommentsInitial();
}

/// Loading document comments
class DocCommentsLoading extends DocCommentsState {
  const DocCommentsLoading();
}

/// Document comments loaded successfully
class DocCommentsLoaded extends DocCommentsState {
  final CommentsData commentsData;

  const DocCommentsLoaded({required this.commentsData});
}

/// No comments found (empty result)
class DocCommentsEmpty extends DocCommentsState {
  const DocCommentsEmpty();
}

/// Deleting a comment
class DocCommentsDeleting extends DocCommentsState {
  const DocCommentsDeleting();
}

/// Editing a comment
class DocCommentsEditing extends DocCommentsState {
  const DocCommentsEditing();
}

/// Error loading/editing/deleting comments
class DocCommentsFailure extends DocCommentsState {
  const DocCommentsFailure();
}

