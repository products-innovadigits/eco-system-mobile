import 'package:project_management/core/utility/pms_exports.dart';

class LatestRequestFiltrationCubit extends Cubit<LatestRequestFiltrationState> {
  final ProjectsRepo repo;
  final bool _ownsControllers;

  LatestRequestFiltrationCubit({
    required this.repo,
    TextEditingController? startController,
    TextEditingController? endController,
  })  : _ownsControllers = startController == null && endController == null,
        pickedStartCtrl = startController ?? TextEditingController(),
        pickedEndCtrl = endController ?? TextEditingController(),
        super(const LatestRequestFiltrationInitial());

  static LatestRequestFiltrationCubit get instance =>
      BlocProvider.of(CustomNavigator.navigatorState.currentContext!);

  List<DropListModel> statusList = [];
  List<DropListModel> categoriesList = [];
  List<DropListModel> riskList = [];
  List<DropListModel> priorityList = [];
  DropListModel? selectedStatus;
  DropListModel? selectedCategory;
  DropListModel? selectedRisk;
  DropListModel? selectedPriority;
  final TextEditingController pickedStartCtrl;
  final TextEditingController pickedEndCtrl;

  // Cache the loaded filter options
  ProjectsFiltersData? _cachedFilterOptions;

  Future<void> loadFilterOptions() async {
    if (statusList.isNotEmpty &&
        priorityList.isNotEmpty &&
        riskList.isNotEmpty &&
        categoriesList.isNotEmpty) {
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
        // Update categories list
        if (model.data!.categories != null) {
          categoriesList = model.data!.categories!
              .map(
                (category) =>
                    DropListModel(id: category.id, name: category.name ?? ''),
              )
              .toList();
        }

        // Update priorities list
        if (model.data!.priorities != null) {
          priorityList = model.data!.priorities!
              .map(
                (priority) =>
                    DropListModel(id: priority.id, name: priority.name ?? ''),
              )
              .toList();
        }

        // Update risks list
        if (model.data!.risks != null) {
          riskList = model.data!.risks!
              .map((risk) => DropListModel(id: risk.id, name: risk.name ?? ''))
              .toList();
        }

        // Update statuses list
        if (model.data!.statuses != null) {
          statusList = model.data!.statuses!
              .map(
                (status) =>
                    DropListModel(id: status.item3, name: status.item1 ?? ''),
              )
              .toList();
        }

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
    // Validate that at least one filter is selected
    if (_areAllFiltersEmpty()) {
      _showEmptyFiltersError();
      return;
    }

    // Get current sorting parameters to preserve them
    final sortingParams = _getCurrentSortingParams();

    /// Add the parameters to the cubit
    latestRequestCubit.getLatestRequest(
      searchEngine: SearchEngine(
        query: {
          'status': selectedStatus?.name ?? '',
          'projectCategoryId': selectedCategory?.id ?? '',
          'riskLevelId': selectedRisk?.id ?? '',
          'periortyLevelId': selectedPriority?.id ?? '',
          'startDate': pickedStartCtrl.text,
          'endDate': pickedEndCtrl.text,
          ...sortingParams, // Preserve sorting parameters
        },
      ),
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

  bool _areAllFiltersEmpty() {
    return selectedStatus == null &&
        selectedCategory == null &&
        selectedRisk == null &&
        selectedPriority == null &&
        pickedStartCtrl.text.isEmpty &&
        pickedEndCtrl.text.isEmpty;
  }

  void _showEmptyFiltersError() {
    AppCore.errorToastMessage(
      allTranslations.text(LocaleKeys.please_select_at_least_one_filter),
    );
  }

  void showStartDatePicker(BuildContext context) {
    DateTime? lastDate;
    DateTime? initialDate;

    if (pickedEndCtrl.text.isNotEmpty) {
      DateTime endDate = DateTime.parse(pickedEndCtrl.text);
      lastDate = endDate.subtract(const Duration(days: 1));
    }

    if (pickedStartCtrl.text.isNotEmpty) {
      DateTime currentStartDate = DateTime.parse(pickedStartCtrl.text);
      if (lastDate == null || !currentStartDate.isAfter(lastDate)) {
        initialDate = currentStartDate;
      } else {
        initialDate = lastDate;
      }
    } else {
      DateTime now = DateTime.now();
      initialDate = (lastDate != null && now.isAfter(lastDate))
          ? lastDate
          : now;
    }

    DatePickerHelper.showDatePickerDialog(
      context,
      (selectedDate) => pickedStartCtrl.text = selectedDate,
      initialDate: initialDate,
      lastDate: lastDate ?? DateTime(3000),
    );
  }

  void showEndDatePicker(BuildContext context) {
    DateTime? firstDate;
    DateTime? initialDate;

    if (pickedStartCtrl.text.isNotEmpty) {
      firstDate = DateTime.parse(
        pickedStartCtrl.text,
      ).add(const Duration(days: 1));
    }

    if (pickedEndCtrl.text.isNotEmpty) {
      DateTime currentEndDate = DateTime.parse(pickedEndCtrl.text);
      if (firstDate == null || !currentEndDate.isBefore(firstDate)) {
        initialDate = currentEndDate;
      } else {
        initialDate = firstDate;
      }
    } else {
      initialDate = firstDate ?? DateTime.now();
    }

    DatePickerHelper.showDatePickerDialog(
      context,
      (selectedDate) => pickedEndCtrl.text = selectedDate,
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: DateTime(3000),
    );
  }

  void resetFilters({required LatestRequestCubit latestRequestCubit}) {
    selectedStatus = null;
    selectedPriority = null;
    selectedCategory = null;
    selectedRisk = null;
    pickedStartCtrl.clear();
    pickedEndCtrl.clear();

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
    selectedStatus = null;
    selectedPriority = null;
    selectedCategory = null;
    selectedRisk = null;
    pickedStartCtrl.clear();
    pickedEndCtrl.clear();

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
