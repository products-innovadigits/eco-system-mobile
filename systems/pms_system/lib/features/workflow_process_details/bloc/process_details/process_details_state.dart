import 'package:pms_system/features/workflow_process_details/model/process_details_model.dart';

/// Base state for WorkflowProcessDetailsBloc
abstract class ProcessDetailsState {
  const ProcessDetailsState();
}

/// Initial state
class ProcessDetailsInitial extends ProcessDetailsState {
  const ProcessDetailsInitial();
}

/// Loading workflow process details
class ProcessDetailsLoading extends ProcessDetailsState {
  const ProcessDetailsLoading();
}

/// Workflow process details loaded successfully
class ProcessDetailsLoaded extends ProcessDetailsState {
  final ProcessDetailsModel processDetails;

  const ProcessDetailsLoaded({required this.processDetails});
}

/// No workflow process details found (empty result)
class ProcessDetailsEmpty extends ProcessDetailsState {
  const ProcessDetailsEmpty();
}

/// Error loading workflow process details
class ProcessDetailsFailure extends ProcessDetailsState {
  final String message;

  const ProcessDetailsFailure({required this.message});
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
