import 'package:pms_system/core/utility/pms_exports.dart';
import 'package:pms_system/features/latest_request/bloc/sorting/latest_request_sorting_state.dart';
import 'package:pms_system/features/projects/repo/projects_repo.dart';

class LatestRequestSortingCubit extends Cubit<LatestRequestSortingState> {
  LatestRequestSortingCubit() : super(const LatestRequestSortingInitial());

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

  Future<void> loadSortingOptions() async {
    // Return cached data if already loaded
    if (_sortingOptions.isNotEmpty) {
      emit(const LatestRequestSortingOptionsLoaded());
      return;
    }

    try {
      emit(const LatestRequestSortingLoading());

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

          emit(const LatestRequestSortingOptionsLoaded());
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
    emit(const LatestRequestSortingOptionSelected());
  }

  void applySorting() {
    _appliedOption = _selectedOption;
    emit(const LatestRequestSortingApplied());
  }

  void resetSorting() {
    _appliedOption = null;
    _selectedOption = null;
    emit(const LatestRequestSortingReset());
  }

  void clearSortingSelection() {
    _selectedOption = null;
    emit(const LatestRequestSortingOptionsLoaded());
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
