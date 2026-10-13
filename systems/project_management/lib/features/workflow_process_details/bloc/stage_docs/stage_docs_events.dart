/// Events for StageDocsBloc
abstract class StageDocsEvent {
  const StageDocsEvent();
}

/// Add document comment
class AddDocumentComment extends StageDocsEvent {
  final int stepDocumentId;
  final String text;

  const AddDocumentComment({required this.stepDocumentId, required this.text});
}
