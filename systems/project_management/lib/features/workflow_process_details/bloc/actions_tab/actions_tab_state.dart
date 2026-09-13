/// Base state for ActionsTabBloc
abstract class ActionsTabState {
  const ActionsTabState();
}

/// Initial state
class ActionsTabInitial extends ActionsTabState {
  const ActionsTabInitial();
}

/// Loading saving comment
class SaveCommentLoading extends ActionsTabState {
  const SaveCommentLoading();
}

/// Saving comment completed successfully
class SaveCommentSuccess extends ActionsTabState {
  const SaveCommentSuccess();
}

/// Loading move to next step
class MoveToNextStepLoading extends ActionsTabState {
  const MoveToNextStepLoading();
}

/// Move to next step completed successfully
class MoveToNextStepSuccess extends ActionsTabState {
  const MoveToNextStepSuccess();
}

/// File selected
///
/// Carries the picked file's name and size. An empty state here would be
/// dropped by `Bloc.emit` when a second file is picked without removing the
/// first — identical `const` instances compare equal — leaving the previous
/// file's name on screen.
class ActionsTabFileSelected extends ActionsTabState {
  final String? fileName;
  final String? fileSize;

  const ActionsTabFileSelected({this.fileName, this.fileSize});
}

/// File removed
class ActionsTabFileRemoved extends ActionsTabState {
  const ActionsTabFileRemoved();
}

/// Error performing action
class ActionsTabFailure extends ActionsTabState {
  final String message;

  const ActionsTabFailure({required this.message});
}


