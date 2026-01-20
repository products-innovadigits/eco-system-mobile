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
class ActionsTabFileSelected extends ActionsTabState {
  const ActionsTabFileSelected();
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


