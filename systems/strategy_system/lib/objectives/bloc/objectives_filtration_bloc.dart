import 'package:strategy_system/shared/strategy_exports.dart';

class ObjectivesFiltrationBloc extends Bloc<AppEvent, AppState> {
  ObjectivesFiltrationBloc() : super(Start()) {}

  final List<DropListModel> statusList = [
    DropListModel(id: 1, name: 'مكتمل'),
    DropListModel(id: 2, name: 'متأخر'),
    DropListModel(id: 3, name: 'متقدم'),
  ];
  final List<DropListModel> objectiveTypesList = [
    DropListModel(id: 1, name: 'تشغيلي'),
    DropListModel(id: 2, name: 'تنفيدي '),
  ];
  final List<DropListModel> axisList = [
    DropListModel(id: 1, name: 'اجتماعي'),
    DropListModel(id: 2, name: 'استراتيجي'),
    DropListModel(id: 3, name: 'تقني'),
    DropListModel(id: 4, name: 'تجاري'),
    DropListModel(id: 5, name: 'اداري'),
  ];
  final List<DropListModel> perspectivesList = [
    DropListModel(id: 1, name: 'المنظور المالي'),
    DropListModel(id: 2, name: 'التعلم والنمو'),
  ];
  final List<DropListModel> organizationalObjectivesList = [
    DropListModel(id: 1, name: 'اجتماعي'),
    DropListModel(id: 2, name: 'استراتيجي'),
    DropListModel(id: 3, name: 'تقني'),
    DropListModel(id: 4, name: 'تجاري'),
  ];
  bool isFilterApplied = false;
  DropListModel? selectedStatus;
  DropListModel? selectedObjectiveType;
  DropListModel? selectedAxis;
  DropListModel? selectedPerspective;
  DropListModel? selectedOrganizationalObjective;

  void applyFilters({required ObjectivesBloc objectivesBloc}) {
    objectivesBloc.add(
      Click(
        arguments: SearchEngine(
          query: {
            'status': selectedStatus?.name ?? '',
            'objectiveType': selectedObjectiveType?.name ?? '',
            'axis': selectedAxis?.name ?? '',
            'perspective': selectedPerspective?.name ?? '',
            'organizationalObjective':
                selectedOrganizationalObjective?.name ?? '',
          },
        ),
      ),
    );
    isFilterApplied = true;
    CustomNavigator.pop();
  }

  void resetFilters({required ObjectivesBloc objectivesBloc}) {
    isFilterApplied = false;
    selectedStatus = null;
    selectedObjectiveType = null;
    selectedAxis = null;
    selectedPerspective = null;
    selectedOrganizationalObjective = null;
    objectivesBloc.add(Click(arguments: SearchEngine()));
    CustomNavigator.pop();
  }
}
