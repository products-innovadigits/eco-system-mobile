import 'package:pms_system/shared/pms_exports.dart';

class ProjectsFiltrationBloc extends Bloc<AppEvent, AppState> {
  ProjectsFiltrationBloc() : super(Start()) {}

  final List<DropListModel> statusList = [
    DropListModel(id: 1, name: 'مكتمل'),
    DropListModel(id: 2, name: 'متأخر'),
    DropListModel(id: 3, name: 'متقدم'),
  ];
  final List<DropListModel> categoriesList = [
    DropListModel(id: 1, name: 'اجتماعي'),
    DropListModel(id: 2, name: 'استراتيجي'),
    DropListModel(id: 3, name: 'تقني'),
    DropListModel(id: 4, name: 'تجاري'),
    DropListModel(id: 5, name: 'اداري'),
  ];
  final List<DropListModel> riskList = [
    DropListModel(id: 1, name: 'المنظور المالي'),
    DropListModel(id: 2, name: 'التعلم والنمو'),
  ];
  final List<DropListModel> priorityList = [
    DropListModel(id: 1, name: 'اجتماعي'),
    DropListModel(id: 2, name: 'استراتيجي'),
    DropListModel(id: 3, name: 'تقني'),
    DropListModel(id: 4, name: 'تجاري'),
  ];
  bool isFilterApplied = false;
  DropListModel? selectedStatus;
  DropListModel? selectedCategory;
  DropListModel? selectedRisk;
  DropListModel? selectedPriority;
  TextEditingController pickedStartCtrl = TextEditingController();
  TextEditingController pickedEndCtrl = TextEditingController();

  void applyFilters({required ProjectsBloc projectsBloc}) {
    // Validate that at least one filter is selected
    if (_areAllFiltersEmpty()) {
      _showEmptyFiltersError();
      return;
    }

    /// Add the parameters to the project bloc
    projectsBloc.add(
      Click(
        arguments: SearchEngine(
          query: {
            'status': selectedStatus?.name ?? '',
            'category': selectedCategory?.name ?? '',
            'risk': selectedRisk?.name ?? '',
            'priority': selectedPriority?.name ?? '',
            // if (pickedStartCtrl.text.isNotEmpty)
            'startDate': pickedStartCtrl.text,
            // if (pickedEndCtrl.text.isNotEmpty)
            'endDate': pickedEndCtrl.text,
          },
        ),
      ),
    );
    isFilterApplied = true;
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
    if (isFilterApplied) {
      isFilterApplied = false;
      projectsBloc.add(Click(arguments: SearchEngine()));
      CustomNavigator.pop();
    }
  }
}
