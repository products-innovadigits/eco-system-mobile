import 'package:project_management/core/utility/project_management_exports.dart';

/// The filter choices shared by the projects and latest request filter
/// sheets: the option lists from `Project/filter-options`, the selected values
/// and the date range.
mixin ProjectFiltersSelection {
  TextEditingController get pickedStartCtrl;
  TextEditingController get pickedEndCtrl;

  List<DropListModel> statusList = [];
  List<DropListModel> categoriesList = [];
  List<DropListModel> riskList = [];
  List<DropListModel> priorityList = [];
  DropListModel? selectedStatus;
  DropListModel? selectedCategory;
  DropListModel? selectedRisk;
  DropListModel? selectedPriority;

  /// Whether every option list has been loaded.
  bool get hasFilterOptions =>
      statusList.isNotEmpty &&
      categoriesList.isNotEmpty &&
      riskList.isNotEmpty &&
      priorityList.isNotEmpty;

  bool get hasNoFilterSelected =>
      selectedStatus == null &&
      selectedCategory == null &&
      selectedRisk == null &&
      selectedPriority == null &&
      pickedStartCtrl.text.isEmpty &&
      pickedEndCtrl.text.isEmpty;

  /// The query parameters of the selected filters.
  Map<String, dynamic> get filterQuery => {
    'status': selectedStatus?.key ?? '',
    'projectCategoryId': selectedCategory?.id ?? '',
    'riskLevelId': selectedRisk?.id ?? '',
    'periortyLevelId': selectedPriority?.id ?? '',
    'startDate': pickedStartCtrl.text,
    'endDate': pickedEndCtrl.text,
  };

  /// Fills the option lists; a list the response leaves out keeps its value.
  void setFilterOptions(ProjectsFiltersData options) {
    DropListModel option(int? id, String? name) =>
        DropListModel(id: id, name: name ?? '');

    if (options.categories case final categories?) {
      categoriesList = [for (final c in categories) option(c.id, c.name)];
    }
    if (options.priorities case final priorities?) {
      priorityList = [for (final p in priorities) option(p.id, p.name)];
    }
    if (options.risks case final risks?) {
      riskList = [for (final r in risks) option(r.id, r.name)];
    }
    if (options.statuses case final statuses?) {
      statusList = [for (final s in statuses) s.toDropListModel()];
    }
  }

  void clearSelection() {
    selectedStatus = null;
    selectedPriority = null;
    selectedCategory = null;
    selectedRisk = null;
    pickedStartCtrl.clear();
    pickedEndCtrl.clear();
  }

  void showEmptyFiltersError() {
    AppCore.errorToastMessage(
      allTranslations.text(LocaleKeys.please_select_at_least_one_filter),
    );
  }

  /// Picks the start date; it must be at least a day before the end date.
  void showStartDatePicker(BuildContext context) {
    final endDate = DateTime.tryParse(pickedEndCtrl.text);
    final lastDate = endDate?.subtract(const Duration(days: 1));
    final current = DateTime.tryParse(pickedStartCtrl.text);
    final now = DateTime.now();

    final DateTime initialDate;
    if (current != null) {
      initialDate = (lastDate == null || !current.isAfter(lastDate))
          ? current
          : lastDate;
    } else {
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

  /// Picks the end date; it must be at least a day after the start date.
  void showEndDatePicker(BuildContext context) {
    final startDate = DateTime.tryParse(pickedStartCtrl.text);
    final firstDate = startDate?.add(const Duration(days: 1));
    final current = DateTime.tryParse(pickedEndCtrl.text);

    final DateTime initialDate;
    if (current != null) {
      initialDate = (firstDate == null || !current.isBefore(firstDate))
          ? current
          : firstDate;
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
}
