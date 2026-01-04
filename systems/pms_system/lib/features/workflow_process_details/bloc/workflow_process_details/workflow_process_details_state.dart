import 'package:pms_system/features/workflow_process_details/model/workflow_process_details_model.dart';

/// Base state for WorkflowProcessDetailsBloc
abstract class WorkflowProcessDetailsState {
  const WorkflowProcessDetailsState();
}

/// Initial state
class WorkflowProcessDetailsInitial extends WorkflowProcessDetailsState {
  const WorkflowProcessDetailsInitial();
}

/// Loading workflow process details
class WorkflowProcessDetailsLoading extends WorkflowProcessDetailsState {
  const WorkflowProcessDetailsLoading();
}

/// Workflow process details loaded successfully
class WorkflowProcessDetailsLoaded extends WorkflowProcessDetailsState {
  final WorkflowProcessDetailsModel processDetails;

  const WorkflowProcessDetailsLoaded({required this.processDetails});
}

/// No workflow process details found (empty result)
class WorkflowProcessDetailsEmpty extends WorkflowProcessDetailsState {
  const WorkflowProcessDetailsEmpty();
}

/// Error loading workflow process details
class WorkflowProcessDetailsFailure extends WorkflowProcessDetailsState {
  final String message;

  const WorkflowProcessDetailsFailure({required this.message});
}

