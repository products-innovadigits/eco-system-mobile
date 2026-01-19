/// Events for StageDocsBloc
abstract class StageDocsEvent {
  const StageDocsEvent();
}

/// Load current step documents
class CreateCurrentStepDocs extends StageDocsEvent {
  final int processId;
  final int projectId;
  final int projectStepId;

  const CreateCurrentStepDocs({
    required this.processId,
    required this.projectId,
    required this.projectStepId,
  });
}

/// Add document comment
class AddDocumentComment extends StageDocsEvent {
  final int stepDocumentId;
  final String text;

  const AddDocumentComment({required this.stepDocumentId, required this.text});
}
