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

/// Sorting options loaded
class LatestRequestSortingOptionsLoaded extends LatestRequestSortingState {
  const LatestRequestSortingOptionsLoaded();
}

/// Sorting option selected
class LatestRequestSortingOptionSelected extends LatestRequestSortingState {
  const LatestRequestSortingOptionSelected();
}

/// Sorting applied
class LatestRequestSortingApplied extends LatestRequestSortingState {
  const LatestRequestSortingApplied();
}

/// Sorting reset
class LatestRequestSortingReset extends LatestRequestSortingState {
  const LatestRequestSortingReset();
}

/// Error loading or applying sorting
class LatestRequestSortingError extends LatestRequestSortingState {
  const LatestRequestSortingError();
}
