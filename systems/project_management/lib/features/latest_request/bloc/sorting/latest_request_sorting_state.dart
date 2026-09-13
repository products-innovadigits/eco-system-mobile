import 'package:core_system/core/components/custom_drop_list.dart';

/// Base state for LatestRequestSortingCubit
abstract class LatestRequestSortingState {
  const LatestRequestSortingState();
}

/// Initial state
class LatestRequestSortingInitial extends LatestRequestSortingState {
  const LatestRequestSortingInitial();
}

/// Loading sorting options
class LatestRequestSortingLoading extends LatestRequestSortingState {
  const LatestRequestSortingLoading();
}

/// Error loading or applying sorting
class LatestRequestSortingError extends LatestRequestSortingState {
  const LatestRequestSortingError();
}

/// Base for every state that has sorting options to show.
///
/// The options, the ticked row and the applied row live on the state rather
/// than only on the cubit. An empty state that just signals "something changed"
/// is dropped by `Cubit.emit` when the same one is emitted twice in a row —
/// identical `const` instances are canonicalised into one object, so
/// `state == nextState` holds. That is what used to leave the first option
/// ticked after the user picked a second one.
abstract class LatestRequestSortingDataState extends LatestRequestSortingState {
  /// The options to list, in the order the API returned them.
  final List<DropListModel> options;

  /// The option currently ticked in the sheet, null when nothing is ticked.
  final DropListModel? selectedOption;

  /// The option the list is actually sorted by, null when sorting is off.
  final DropListModel? appliedOption;

  const LatestRequestSortingDataState({
    this.options = const [],
    this.selectedOption,
    this.appliedOption,
  });
}

/// Sorting options loaded
class LatestRequestSortingOptionsLoaded extends LatestRequestSortingDataState {
  const LatestRequestSortingOptionsLoaded({
    super.options,
    super.selectedOption,
    super.appliedOption,
  });
}

/// Sorting option selected
class LatestRequestSortingOptionSelected
    extends LatestRequestSortingDataState {
  const LatestRequestSortingOptionSelected({
    super.options,
    super.selectedOption,
    super.appliedOption,
  });
}

/// Sorting applied
class LatestRequestSortingApplied extends LatestRequestSortingDataState {
  const LatestRequestSortingApplied({
    super.options,
    super.selectedOption,
    super.appliedOption,
  });
}

/// Sorting reset
class LatestRequestSortingReset extends LatestRequestSortingDataState {
  const LatestRequestSortingReset({super.options});
}
