import 'package:core_system/core/core/enums.dart';

/// Events for WorkflowProcessDetailsBloc
abstract class ProcessDetailsEvent {
  const ProcessDetailsEvent();
}

/// Load workflow process details
class LoadProcessDetails extends ProcessDetailsEvent {
  final int processId;
  final int projectId;

  const LoadProcessDetails({required this.processId, required this.projectId});
}

/// Start workflow process
class StartProcess extends ProcessDetailsEvent {
  final int processId;
  final int projectId;

  const StartProcess({required this.processId, required this.projectId});
}

/// Select a tab in workflow process details
class SelectProcessTab extends ProcessDetailsEvent {
  final ProcessTabsEnum tab;

  const SelectProcessTab({required this.tab});
}
