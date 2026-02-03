import 'package:project_management/features/projects/model/projects_filters_model.dart';

/// Base state for LatestRequestFiltrationCubit
abstract class LatestRequestFiltrationState {
  const LatestRequestFiltrationState();
}

/// Initial state
class LatestRequestFiltrationInitial extends LatestRequestFiltrationState {
  const LatestRequestFiltrationInitial();
}

/// Loading filter options
class LatestRequestFiltrationLoading extends LatestRequestFiltrationState {
  const LatestRequestFiltrationLoading();
}

/// Filter options loaded successfully
class LatestRequestFiltrationLoaded extends LatestRequestFiltrationState {
  final ProjectsFiltersData filterOptions;
  final bool isFilterApplied;

  const LatestRequestFiltrationLoaded({
    required this.filterOptions,
    this.isFilterApplied = false,
  });

  LatestRequestFiltrationLoaded copyWith({
    ProjectsFiltersData? filterOptions,
    bool? isFilterApplied,
  }) {
    return LatestRequestFiltrationLoaded(
      filterOptions: filterOptions ?? this.filterOptions,
      isFilterApplied: isFilterApplied ?? this.isFilterApplied,
    );
  }
}

/// Error loading filter options
class LatestRequestFiltrationFailure extends LatestRequestFiltrationState {
  final String message;

  const LatestRequestFiltrationFailure({required this.message});
}
