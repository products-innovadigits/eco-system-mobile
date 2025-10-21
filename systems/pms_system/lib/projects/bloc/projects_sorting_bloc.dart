import 'package:pms_system/projects/bloc/projects_sorting_events.dart';
import 'package:pms_system/projects/bloc/projects_sorting_states.dart';
import 'package:pms_system/shared/pms_exports.dart';

class ProjectsSortingBloc extends Bloc<AppEvent, AppState> {
  ProjectsSortingBloc() : super(SortingInitial()) {
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
    Emitter<AppState> emit,
  ) async {
    // Return cached data if already loaded
    if (_sortingOptions.isNotEmpty) {
      emit(SortingOptionsLoaded());
      return;
    }

    try {
      emit(SortingLoading());

      Response model = await ProjectsRepo.getProjectSortingOptions();

      if (model.statusCode == 200 && model.data != null) {
        if ((model.data['data'] as List).isNotEmpty) {
          _sortingOptions = (model.data['data'] as List)
              .map(
                (item) => DropListModel(
                  id: item['id'],
                  name: item['nameAr'],
                  key: item['key'] ?? item['id'].toString(),
                ),
              )
              .toList();

          emit(SortingOptionsLoaded());
        } else {
          emit(SortingError());
        }
      } else {
        emit(SortingError());
      }
    } catch (e) {
      emit(SortingError());
    }
  }

  void _onSelectSortingOption(
    SelectSortingOption event,
    Emitter<AppState> emit,
  ) {
    _selectedOption = event.arguments as DropListModel?;

    emit(SortingOptionSelected());
  }

  void _onApplySorting(ApplySortingOption event, Emitter<AppState> emit) {
    _appliedOption = _selectedOption;

    emit(SortingApplied());
  }

  void _onResetSorting(ResetSortingOption event, Emitter<AppState> emit) {
    _appliedOption = null;
    _selectedOption = null;

    emit(SortingReset());
  }

  void _onClearSortingSelection(
    ClearSortingSelection event,
    Emitter<AppState> emit,
  ) {
    _selectedOption = null;

    emit(SortingOptionsLoaded());
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
