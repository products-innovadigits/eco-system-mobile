/// Base state for StageDocsBloc
abstract class StageDocsState {
  const StageDocsState();
}

/// Initial state
class StageDocsInitial extends StageDocsState {
  const StageDocsInitial();
}

/// Idle: no comment is being added
class StageDocsLoaded extends StageDocsState {
  const StageDocsLoaded();
}

/// Adding a comment to the document with [stepDocumentId]
class StageDocsAdding extends StageDocsState {
  final int stepDocumentId;

  const StageDocsAdding({required this.stepDocumentId});
}

/// Adding a comment failed
class StageDocsFailure extends StageDocsState {
  const StageDocsFailure();
}
