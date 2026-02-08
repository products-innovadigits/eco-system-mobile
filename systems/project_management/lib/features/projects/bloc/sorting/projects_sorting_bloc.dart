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

  Future<void> _onLoadSortingOptions(
    LoadSortingOptions event,
    Emitter<ProjectsSortingState> emit,
  ) async {
    // Return cached data if already loaded
    if (_sortingOptions.isNotEmpty) {
      emit(const SortingOptionsLoaded());
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

          emit(const SortingOptionsLoaded());
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

    emit(const SortingOptionSelected());
  }

  void _onApplySorting(
    ApplySortingOption event,
    Emitter<ProjectsSortingState> emit,
  ) {
    _appliedOption = _selectedOption;

    emit(const SortingApplied());
  }

  void _onResetSorting(
    ResetSortingOption event,
    Emitter<ProjectsSortingState> emit,
  ) {
    _appliedOption = null;
    _selectedOption = null;

    emit(const SortingReset());
  }

  void _onClearSortingSelection(
    ClearSortingSelection event,
    Emitter<ProjectsSortingState> emit,
  ) {
    _selectedOption = null;

    emit(const SortingOptionsLoaded());
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
