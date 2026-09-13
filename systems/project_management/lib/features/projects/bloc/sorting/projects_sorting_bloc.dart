import 'package:project_management/core/utility/project_management_exports.dart';

class ProjectsSortingBloc
    extends Bloc<ProjectsSortingEvent, ProjectsSortingState> {
  final ProjectsRepo repo;

  ProjectsSortingBloc({required this.repo})
      : super(const ProjectsSortingInitial()) {
    on<LoadSortingOptions>(_onLoadSortingOptions);
    on<SelectSortingOption>(_onSelectSortingOption);
    on<ApplySortingOption>(_onApplySorting);
    on<ResetSortingOption>(_onResetSorting);
    on<ClearSortingSelection>(_onClearSortingSelection);
  }

  // Sorting data
  List<DropListModel> _sortingOptions = [];
  DropListModel? _selectedOption;
  DropListModel? _appliedOption;

  // Getters
  List<DropListModel> get sortingOptions => _sortingOptions;

  DropListModel? get selectedOption => _selectedOption;

  DropListModel? get appliedOption => _appliedOption;

  bool get hasAppliedSorting => _appliedOption != null;

  bool get hasSelectedOption => _selectedOption != null;

  /// The current selection, mirrored onto every data-carrying state so the
  /// sheet reads it from the state instead of from these fields.
  SortingOptionsLoaded get _snapshot => SortingOptionsLoaded(
    options: _sortingOptions,
    selectedOption: _selectedOption,
    appliedOption: _appliedOption,
  );

  Future<void> _onLoadSortingOptions(
    LoadSortingOptions event,
    Emitter<ProjectsSortingState> emit,
  ) async {
    // Return cached data if already loaded
    if (_sortingOptions.isNotEmpty) {
      emit(_snapshot);
      return;
    }

    try {
      emit(const SortingLoading());

      final model = await repo.getProjectSortingOptions();

      if (model.succeeded == true && model.data != null) {
        if (model.data!.isNotEmpty) {
          _sortingOptions = model.data!
              .map(
                (item) => DropListModel(
                  id: item.id,
                  name: item.nameAr,
                  key: item.id?.toString() ?? '',
                ),
              )
              .toList();

          emit(_snapshot);
        } else {
          emit(const SortingError());
        }
      } else {
        emit(const SortingError());
      }
    } catch (e) {
      emit(const SortingError());
    }
  }

  void _onSelectSortingOption(
    SelectSortingOption event,
    Emitter<ProjectsSortingState> emit,
  ) {
    _selectedOption = event.arguments as DropListModel?;

    emit(
      SortingOptionSelected(
        options: _sortingOptions,
        selectedOption: _selectedOption,
        appliedOption: _appliedOption,
      ),
    );
  }

  void _onApplySorting(
    ApplySortingOption event,
    Emitter<ProjectsSortingState> emit,
  ) {
    _appliedOption = _selectedOption;

    emit(
      SortingApplied(
        options: _sortingOptions,
        selectedOption: _selectedOption,
        appliedOption: _appliedOption,
      ),
    );
  }

  void _onResetSorting(
    ResetSortingOption event,
    Emitter<ProjectsSortingState> emit,
  ) {
    _appliedOption = null;
    _selectedOption = null;

    emit(SortingReset(options: _sortingOptions));
  }

  void _onClearSortingSelection(
    ClearSortingSelection event,
    Emitter<ProjectsSortingState> emit,
  ) {
    _selectedOption = null;

    emit(_snapshot);
  }

  // Helper method to get current sorting parameters for API calls
  Map<String, dynamic>? getSortingParams() {
    if (_appliedOption?.key != null) {
      return {"sortOptionId": _appliedOption!.key};
    }
    return null;
  }

  // Helper method to reset all sorting
  void resetAllSorting() {
    _appliedOption = null;
    _selectedOption = null;
  }
}
