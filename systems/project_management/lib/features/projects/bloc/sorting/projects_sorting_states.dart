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

/// Sorting options loaded
class SortingOptionsLoaded extends ProjectsSortingState {
  const SortingOptionsLoaded();
}

/// Sorting option selected
class SortingOptionSelected extends ProjectsSortingState {
  const SortingOptionSelected();
}

/// Sorting applied
class SortingApplied extends ProjectsSortingState {
  const SortingApplied();
}

/// Sorting reset
class SortingReset extends ProjectsSortingState {
  const SortingReset();
}

/// Error loading or applying sorting
class SortingError extends ProjectsSortingState {
  const SortingError();
}
