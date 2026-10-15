import 'package:project_management/core/utility/project_management_exports.dart';

class LatestRequestFiltrationCubit extends Cubit<LatestRequestFiltrationState>
    with ProjectFiltersSelection {
  final ProjectsRepo repo;
  final bool _ownsControllers;

  LatestRequestFiltrationCubit({
    required this.repo,
    TextEditingController? startController,
    TextEditingController? endController,
  }) : _ownsControllers = startController == null && endController == null,
       pickedStartCtrl = startController ?? TextEditingController(),
       pickedEndCtrl = endController ?? TextEditingController(),
       super(const LatestRequestFiltrationInitial());

  static LatestRequestFiltrationCubit get instance =>
      BlocProvider.of(CustomNavigator.navigatorState.currentContext!);

  @override
  final TextEditingController pickedStartCtrl;
  @override
  final TextEditingController pickedEndCtrl;

  // Cache the loaded filter options
  ProjectsFiltersData? _cachedFilterOptions;

  Future<void> loadFilterOptions() async {
    if (hasFilterOptions) {
      if (_cachedFilterOptions != null) {
        emit(
          LatestRequestFiltrationLoaded(
            filterOptions: _cachedFilterOptions!,
            isFilterApplied: state is LatestRequestFiltrationLoaded
                ? (state as LatestRequestFiltrationLoaded).isFilterApplied
                : false,
          ),
        );
      }
      return;
    }

    try {
      emit(const LatestRequestFiltrationLoading());

      ProjectsFiltersModel model = await repo.getProjectFilterOptions();

      if (model.succeeded == true && model.data != null) {
        setFilterOptions(model.data!);
        _cachedFilterOptions = model.data!;
        emit(
          LatestRequestFiltrationLoaded(
            filterOptions: model.data!,
            isFilterApplied: state is LatestRequestFiltrationLoaded
                ? (state as LatestRequestFiltrationLoaded).isFilterApplied
                : false,
          ),
        );
      } else {
        emit(
          const LatestRequestFiltrationFailure(
            message: 'Failed to load filter options',
          ),
        );
      }
    } catch (e) {
      emit(
        const LatestRequestFiltrationFailure(
          message: 'Failed to load filter options',
        ),
      );
    }
  }

  void applyFilters({required LatestRequestCubit latestRequestCubit}) {
    if (hasNoFilterSelected) {
      showEmptyFiltersError();
      return;
    }

    // Get current sorting parameters to preserve them
    final sortingParams = _getCurrentSortingParams();

    /// Add the parameters to the cubit
    latestRequestCubit.getLatestRequest(
      searchEngine: SearchEngine(query: {...filterQuery, ...sortingParams}),
    );

    if (_cachedFilterOptions != null) {
      emit(
        LatestRequestFiltrationLoaded(
          filterOptions: _cachedFilterOptions!,
          isFilterApplied: true,
        ),
      );
    }

    CustomNavigator.pop();
  }

  void resetFilters({required LatestRequestCubit latestRequestCubit}) {
    clearSelection();

    final currentState = state;
    if (currentState is LatestRequestFiltrationLoaded &&
        currentState.isFilterApplied) {
      if (_cachedFilterOptions != null) {
        emit(
          LatestRequestFiltrationLoaded(
            filterOptions: _cachedFilterOptions!,
            isFilterApplied: false,
          ),
        );
      }

      // Preserve sorting parameters when resetting filters
      final sortingParams = _getCurrentSortingParams();
      latestRequestCubit.getLatestRequest(
        searchEngine: SearchEngine(query: sortingParams),
      );
      CustomNavigator.pop();
    }
  }

  void clearFilters() {
    clearSelection();

    if (_cachedFilterOptions != null) {
      emit(
        LatestRequestFiltrationLoaded(
          filterOptions: _cachedFilterOptions!,
          isFilterApplied: false,
        ),
      );
    }
  }

  Map<String, dynamic> _getCurrentSortingParams() {
    try {
      final sortingCubit = BlocProvider.of<LatestRequestSortingCubit>(
        CustomNavigator.navigatorState.currentContext!,
      );
      return sortingCubit.getSortingParams() ?? {};
    } catch (e) {
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
