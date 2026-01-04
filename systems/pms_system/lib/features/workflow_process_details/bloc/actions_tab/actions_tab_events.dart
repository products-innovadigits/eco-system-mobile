/// Events for ActionsTabBloc
abstract class ActionsTabEvent {
  const ActionsTabEvent();
}

/// Save/add comment action
class SaveComment extends ActionsTabEvent {
  final int projectId;
  final int projectStepId;
  final int processId;

  const SaveComment({
    required this.projectId,
    required this.projectStepId,
    required this.processId,
  });
}

/// Compliance/move to next step action
class MoveToNextStep extends ActionsTabEvent {
  final int projectId;
  final int processId;
  final int nextStepId;

  const MoveToNextStep({
    required this.projectId,
    required this.processId,
    required this.nextStepId,
  });
}

/// Pick file for attachment
class PickFile extends ActionsTabEvent {
  const PickFile();
}

/// Remove selected file
class RemoveFile extends ActionsTabEvent {
  const RemoveFile();
}

