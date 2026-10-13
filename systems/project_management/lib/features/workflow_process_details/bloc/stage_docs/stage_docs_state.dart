/// Base state for StageDocsBloc
abstract class StageDocsState {
  const StageDocsState();
}

/// Initial state
class StageDocsInitial extends StageDocsState {
  const StageDocsInitial();
}

/// Loading current step documents
class StageDocsLoading extends StageDocsState {
  const StageDocsLoading();
}

/// Current step documents loaded successfully
class StageDocsLoaded extends StageDocsState {
  const StageDocsLoaded();
}

/// No documents found (empty result)
class StageDocsEmpty extends StageDocsState {
  const StageDocsEmpty();
}

/// Adding a comment to the document with [stepDocumentId]
class StageDocsAdding extends StageDocsState {
  final int stepDocumentId;

  const StageDocsAdding({required this.stepDocumentId});
}

/// Error loading/adding documents
class StageDocsFailure extends StageDocsState {
  const StageDocsFailure();
}
