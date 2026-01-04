/// Base state for ActionsTabBloc
abstract class ActionsTabState {
  const ActionsTabState();
}

/// Initial state
class ActionsTabInitial extends ActionsTabState {
  const ActionsTabInitial();
}

/// Loading action (save or compliance)
class ActionsTabLoading extends ActionsTabState {
  const ActionsTabLoading();
}

/// Action completed successfully
class ActionsTabSuccess extends ActionsTabState {
  const ActionsTabSuccess();
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

