

import 'package:pms_package/shared/pms_exports.dart';

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

  void applyFilters({required ProjectsBloc projectsBloc}) {
    projectsBloc.add(
      Click(
        arguments: SearchEngine(
          query: {
            'status': selectedStatus?.name ?? '',
            'category': selectedCategory?.name ?? '',
            'risk': selectedRisk?.name ?? '',
            'priority': selectedPriority?.name ?? '',
          },
        ),
      ),
    );
    isFilterApplied = true;
    CustomNavigator.pop();
  }

  void resetFilters({required ProjectsBloc projectsBloc}) {
    isFilterApplied = false;
    selectedStatus = null;
    selectedPriority = null;
    selectedCategory = null;
    selectedRisk = null;
    projectsBloc.add(Click(arguments: SearchEngine()));
    CustomNavigator.pop();
  }
}
