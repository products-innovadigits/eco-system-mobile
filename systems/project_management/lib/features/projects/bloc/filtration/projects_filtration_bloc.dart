import 'dart:developer';

import 'package:project_management/core/utility/project_management_exports.dart';

class ProjectsFiltrationBloc
    extends Bloc<ProjectsFiltrationEvent, ProjectsFiltrationState>
    with ProjectFiltersSelection {
  final ProjectsRepo repo;
  final bool _ownsControllers;

  ProjectsFiltrationBloc({
    required this.repo,
    TextEditingController? startController,
    TextEditingController? endController,
  }) : _ownsControllers = startController == null && endController == null,
       pickedStartCtrl = startController ?? TextEditingController(),
       pickedEndCtrl = endController ?? TextEditingController(),
       super(const ProjectsFiltrationInitial()) {
    on<LoadProjectsFilterOptions>(_onLoadFilterOptions);
    on<ApplyProjectsFilters>(_onApplyFilters);
    on<ResetProjectsFilters>(_onResetFilters);
    on<ClearProjectsFilters>(_onClearFilters);
  }

  static ProjectsFiltrationBloc get instance =>
      BlocProvider.of(CustomNavigator.navigatorState.currentContext!);

  @override
  final TextEditingController pickedStartCtrl;
  @override
  final TextEditingController pickedEndCtrl;

  // Cache the loaded filter options
  ProjectsFiltersData? _cachedFilterOptions;

  Future<void> _onLoadFilterOptions(
    LoadProjectsFilterOptions event,
    Emitter<ProjectsFiltrationState> emit,
  ) async {
    try {
      emit(const ProjectsFiltrationLoading());

      ProjectsFiltersModel model = await repo.getProjectFilterOptions();

      if (model.succeeded == true && model.data != null) {
        setFilterOptions(model.data!);
        _cachedFilterOptions = model.data!;
        emit(
          ProjectsFiltrationLoaded(
            filterOptions: model.data!,
            isFilterApplied: state is ProjectsFiltrationLoaded
                ? (state as ProjectsFiltrationLoaded).isFilterApplied
                : false,
          ),
        );
      } else {
        emit(
          const ProjectsFiltrationFailure(
            message: 'Failed to load filter options',
          ),
        );
      }
    } catch (e) {
      emit(
        const ProjectsFiltrationFailure(
          message: 'Failed to load filter options',
        ),
      );
    }
  }

  void loadFilterOptions() {
    if (!hasFilterOptions) add(const LoadProjectsFilterOptions());
  }

  void applyFilters({required ProjectsBloc projectsBloc}) {
    if (hasNoFilterSelected) {
      showEmptyFiltersError();
      return;
    }

    // Get current sorting parameters to preserve them
    final sortingParams = _getCurrentSortingParams();

    /// Add the parameters to the project bloc
    projectsBloc.add(
      LoadProjects(
        searchEngine: SearchEngine(query: {...filterQuery, ...sortingParams}),
      ),
    );

    // Trigger event to emit new state
    add(const ApplyProjectsFilters());

    CustomNavigator.pop();
  }

  void _onApplyFilters(
    ApplyProjectsFilters event,
    Emitter<ProjectsFiltrationState> emit,
  ) {
    if (_cachedFilterOptions != null) {
      emit(
        ProjectsFiltrationLoaded(
          filterOptions: _cachedFilterOptions!,
          isFilterApplied: true,
        ),
      );
    }
  }

  void resetFilters({required ProjectsBloc projectsBloc}) {
    clearSelection();

    final currentState = state;
    if (currentState is ProjectsFiltrationLoaded &&
        currentState.isFilterApplied) {
      // Trigger event to emit new state
      add(const ResetProjectsFilters());

      // Preserve sorting parameters when resetting filters
      final sortingParams = _getCurrentSortingParams();
      projectsBloc.add(
        LoadProjects(searchEngine: SearchEngine(query: sortingParams)),
      );
      CustomNavigator.pop();
    }
  }

  void _onResetFilters(
    ResetProjectsFilters event,
    Emitter<ProjectsFiltrationState> emit,
  ) {
    if (_cachedFilterOptions != null) {
      emit(
        ProjectsFiltrationLoaded(
          filterOptions: _cachedFilterOptions!,
          isFilterApplied: false,
        ),
      );
    }
  }

  void clearFilters() {
    clearSelection();

    // Trigger event to emit new state
    add(const ClearProjectsFilters());
  }

  void _onClearFilters(
    ClearProjectsFilters event,
    Emitter<ProjectsFiltrationState> emit,
  ) {
    if (_cachedFilterOptions != null) {
      emit(
        ProjectsFiltrationLoaded(
          filterOptions: _cachedFilterOptions!,
          isFilterApplied: false,
        ),
      );
    }
  }

  // Helper method to get current sorting parameters from sorting bloc
  Map<String, dynamic> _getCurrentSortingParams() {
    try {
      // Try to get the sorting bloc from the current context
      final context = CustomNavigator.navigatorState.currentContext;
      if (context == null) return {};

      final sortingBloc = BlocProvider.of<ProjectsSortingBloc>(context);
      return sortingBloc.getSortingParams() ?? {};
    } catch (e) {
      log('Error getting sorting params: $e');
      return {};
    }
  }

  @override
  Future<void> close() {
    if (_ownsControllers) {
      pickedStartCtrl.dispose();
      pickedEndCtrl.dispose();
    }
    return super.close();
  }
}
