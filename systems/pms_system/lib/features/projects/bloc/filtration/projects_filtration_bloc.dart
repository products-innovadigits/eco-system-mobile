import 'package:pms_system/core/utility/pms_exports.dart';
import 'package:pms_system/features/projects/bloc/filtration/projects_filtration_events.dart';
import 'package:pms_system/features/projects/bloc/filtration/projects_filtration_state.dart';
import 'package:pms_system/features/projects/bloc/projects/projects_bloc.dart';
import 'package:pms_system/features/projects/bloc/projects/projects_events.dart';
import 'package:pms_system/features/projects/bloc/sorting/projects_sorting_bloc.dart';
import 'package:pms_system/features/projects/model/projects_filters_model.dart';
import 'package:pms_system/features/projects/repo/projects_repo.dart';

class ProjectsFiltrationBloc
    extends Bloc<ProjectsFiltrationEvent, ProjectsFiltrationState> {
  ProjectsFiltrationBloc() : super(const ProjectsFiltrationInitial()) {
    on<LoadProjectsFilterOptions>(_onLoadFilterOptions);
    on<ApplyProjectsFilters>(_onApplyFilters);
    on<ResetProjectsFilters>(_onResetFilters);
    on<ClearProjectsFilters>(_onClearFilters);
  }

  static ProjectsFiltrationBloc get instance =>
      BlocProvider.of(CustomNavigator.navigatorState.currentContext!);

  List<DropListModel> statusList = [];
  List<DropListModel> categoriesList = [];
  List<DropListModel> riskList = [];
  List<DropListModel> priorityList = [];
  DropListModel? selectedStatus;
  DropListModel? selectedCategory;
  DropListModel? selectedRisk;
  DropListModel? selectedPriority;
  TextEditingController pickedStartCtrl = TextEditingController();
  TextEditingController pickedEndCtrl = TextEditingController();

  // Cache the loaded filter options
  ProjectsFiltersData? _cachedFilterOptions;

  Future<void> _onLoadFilterOptions(
    LoadProjectsFilterOptions event,
    Emitter<ProjectsFiltrationState> emit,
  ) async {
    try {
      emit(const ProjectsFiltrationLoading());

      ProjectsFiltersModel model = await ProjectsRepo.getProjectFilterOptions();

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
    if (statusList.isEmpty ||
        priorityList.isEmpty ||
        riskList.isEmpty ||
        categoriesList.isEmpty) {
      add(const LoadProjectsFilterOptions());
    }
  }

  void applyFilters({required ProjectsBloc projectsBloc}) {
    // Validate that at least one filter is selected
    if (_areAllFiltersEmpty()) {
      _showEmptyFiltersError();
      return;
    }

    // Get current sorting parameters to preserve them
    final sortingParams = _getCurrentSortingParams();

    /// Add the parameters to the project bloc
    projectsBloc.add(
      LoadProjects(
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

    // If end date is already picked, set it as the last selectable date
    // Start date must be before the end date
    if (pickedEndCtrl.text.isNotEmpty) {
      DateTime endDate = DateTime.parse(pickedEndCtrl.text);
      lastDate = endDate.subtract(
        Duration(days: 1),
      ); // Start date must be at least 1 day before end date
    }

    // Handle initial date to avoid conflicts with lastDate
    if (pickedStartCtrl.text.isNotEmpty) {
      DateTime currentStartDate = DateTime.parse(pickedStartCtrl.text);

      // If current start date is valid (before or equal to lastDate), use it
      if (lastDate == null || !currentStartDate.isAfter(lastDate)) {
        initialDate = currentStartDate;
      } else {
        // If current start date is invalid, use lastDate as initial
        initialDate = lastDate;
      }
    } else {
      // If no start date is set, use current date or lastDate (whichever is earlier)
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

    // If start date is already picked, set it as the first selectable date
    if (pickedStartCtrl.text.isNotEmpty) {
      firstDate = DateTime.parse(pickedStartCtrl.text).add(Duration(days: 1));
    }

    // Handle initial date to avoid conflicts with firstDate
    if (pickedEndCtrl.text.isNotEmpty) {
      DateTime currentEndDate = DateTime.parse(pickedEndCtrl.text);

      // If current end date is valid (after firstDate), use it
      if (firstDate == null || !currentEndDate.isBefore(firstDate)) {
        initialDate = currentEndDate;
      } else {
        // If current end date is invalid, use firstDate as initial
        initialDate = firstDate;
      }
    } else {
      // If no end date is set, use firstDate or current date
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

  void resetFilters({required ProjectsBloc projectsBloc}) {
    selectedStatus = null;
    selectedPriority = null;
    selectedCategory = null;
    selectedRisk = null;
    pickedStartCtrl.clear();
    pickedEndCtrl.clear();

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
    selectedStatus = null;
    selectedPriority = null;
    selectedCategory = null;
    selectedRisk = null;
    pickedStartCtrl.clear();
    pickedEndCtrl.clear();

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
      final sortingBloc = BlocProvider.of<ProjectsSortingBloc>(
        CustomNavigator.navigatorState.currentContext!,
      );
      return sortingBloc.getSortingParams() ?? {};
    } catch (e) {
      // If sorting bloc is not available, return empty params
      return {};
    }
  }
}
