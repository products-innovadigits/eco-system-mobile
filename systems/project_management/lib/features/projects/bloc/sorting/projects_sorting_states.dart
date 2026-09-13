import 'package:core_system/core/components/custom_drop_list.dart';

/// Base state for ProjectsSortingBloc
abstract class ProjectsSortingState {
  const ProjectsSortingState();
}

/// Initial state
class ProjectsSortingInitial extends ProjectsSortingState {
  const ProjectsSortingInitial();
}

/// Loading sorting options
class SortingLoading extends ProjectsSortingState {
  const SortingLoading();
}

/// Error loading or applying sorting
class SortingError extends ProjectsSortingState {
  const SortingError();
}

/// Base for every state that has sorting options to show.
///
/// The options, the ticked row and the applied row live on the state rather
/// than only on the bloc. An empty state that just signals "something changed"
/// is dropped by `Bloc.emit` when the same one is emitted twice in a row —
/// identical `const` instances are canonicalised into one object, so
/// `state == nextState` holds. That is what used to leave the first option
/// ticked after the user picked a second one.
abstract class ProjectsSortingDataState extends ProjectsSortingState {
  /// The options to list, in the order the API returned them.
  final List<DropListModel> options;

  /// The option currently ticked in the sheet, null when nothing is ticked.
  final DropListModel? selectedOption;

  /// The option the list is actually sorted by, null when sorting is off.
  final DropListModel? appliedOption;

  const ProjectsSortingDataState({
    this.options = const [],
    this.selectedOption,
    this.appliedOption,
  });
}

/// Sorting options loaded
class SortingOptionsLoaded extends ProjectsSortingDataState {
  const SortingOptionsLoaded({
    super.options,
    super.selectedOption,
    super.appliedOption,
  });
}

/// Sorting option selected
class SortingOptionSelected extends ProjectsSortingDataState {
  const SortingOptionSelected({
    super.options,
    super.selectedOption,
    super.appliedOption,
  });
}

/// Sorting applied
class SortingApplied extends ProjectsSortingDataState {
  const SortingApplied({
    super.options,
    super.selectedOption,
    super.appliedOption,
  });
}

/// Sorting reset
class SortingReset extends ProjectsSortingDataState {
  const SortingReset({super.options});
}
