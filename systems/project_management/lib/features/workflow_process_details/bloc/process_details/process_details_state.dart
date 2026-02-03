import 'package:project_management/features/workflow_process_details/model/process_details_model.dart';

/// Base state for WorkflowProcessDetailsBloc
abstract class ProcessDetailsState {
  const ProcessDetailsState();
}

/// Initial state
class ProcessDetailsInitial extends ProcessDetailsState {
  const ProcessDetailsInitial();
}

/// Loading workflow process details
class GroupStepsLoading extends ProcessDetailsState {
  const GroupStepsLoading();
}

/// Workflow process details loaded successfully
class GroupStepsLoaded extends ProcessDetailsState {
  final GroupStepsModel processDetails;

  const GroupStepsLoaded({required this.processDetails});
}

/// No workflow process details found (empty result)
class GroupStepsEmpty extends ProcessDetailsState {
  const GroupStepsEmpty();
}

/// Error loading workflow process details
class GroupStepsFailure extends ProcessDetailsState {
  final String message;

  const GroupStepsFailure({required this.message});
}

class ProcessStarting extends ProcessDetailsState {
  const ProcessStarting();
}

class ProcessStarted extends ProcessDetailsState {
  const ProcessStarted();
}

class ProcessStartFailure extends ProcessDetailsState {
  const ProcessStartFailure();
}
