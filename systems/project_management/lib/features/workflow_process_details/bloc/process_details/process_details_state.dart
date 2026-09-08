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

/// Reloading the group steps from inside the follow process tab, the rest of
/// the screen keeps whatever it already has
class GroupStepsReloading extends ProcessDetailsState {
  const GroupStepsReloading();
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
  /// The message returned by the API, null when it carried none.
  final String? message;

  const GroupStepsFailure({this.message});
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
