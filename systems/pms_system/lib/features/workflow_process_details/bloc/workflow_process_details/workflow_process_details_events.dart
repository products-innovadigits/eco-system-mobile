import 'package:core_system/core/core/enums.dart';

/// Events for WorkflowProcessDetailsBloc
abstract class WorkflowProcessDetailsEvent {
  const WorkflowProcessDetailsEvent();
}

/// Load workflow process details
class LoadWorkflowProcessDetails extends WorkflowProcessDetailsEvent {
  final int processId;
  final int projectId;

  const LoadWorkflowProcessDetails({
    required this.processId,
    required this.projectId,
  });
}

/// Start workflow process
class StartWorkflowProcess extends WorkflowProcessDetailsEvent {
  final int processId;
  final int projectId;

  const StartWorkflowProcess({
    required this.processId,
    required this.projectId,
  });
}

/// Select a tab in workflow process details
class SelectWorkflowProcessTab extends WorkflowProcessDetailsEvent {
  final ProcessTabsEnum tab;

  const SelectWorkflowProcessTab({required this.tab});
}



