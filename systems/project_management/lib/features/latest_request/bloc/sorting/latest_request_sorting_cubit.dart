import 'package:project_management/core/utility/project_management_exports.dart';

class LatestRequestSortingCubit extends Cubit<LatestRequestSortingState> {
  final ProjectsRepo repo;

  LatestRequestSortingCubit({required this.repo})
      : super(const LatestRequestSortingInitial());

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
  LatestRequestSortingOptionsLoaded get _snapshot =>
      LatestRequestSortingOptionsLoaded(
        options: _sortingOptions,
        selectedOption: _selectedOption,
        appliedOption: _appliedOption,
      );

  Future<void> loadSortingOptions() async {
    // Return cached data if already loaded
    if (_sortingOptions.isNotEmpty) {
      emit(_snapshot);
      return;
    }

    try {
      emit(const LatestRequestSortingLoading());

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
          emit(const LatestRequestSortingError());
        }
      } else {
        emit(const LatestRequestSortingError());
      }
    } catch (e) {
      emit(const LatestRequestSortingError());
    }
  }

  void selectSortingOption(DropListModel? option) {
    _selectedOption = option;
    emit(
      LatestRequestSortingOptionSelected(
        options: _sortingOptions,
        selectedOption: _selectedOption,
        appliedOption: _appliedOption,
      ),
    );
  }

  void applySorting() {
    _appliedOption = _selectedOption;
    emit(
      LatestRequestSortingApplied(
        options: _sortingOptions,
        selectedOption: _selectedOption,
        appliedOption: _appliedOption,
      ),
    );
  }

  void resetSorting() {
    _appliedOption = null;
    _selectedOption = null;
    emit(LatestRequestSortingReset(options: _sortingOptions));
  }

  void clearSortingSelection() {
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
