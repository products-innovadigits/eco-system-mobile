import 'package:pms_system/features/employees_learning/bloc/filtration/employees_filtration_bloc.dart';

abstract class EmployeesFilterProvider {
  Map<String, dynamic> getFilterParams();
}

class EmployeesFiltrationBlocFilterProvider implements EmployeesFilterProvider {
  final EmployeesFiltrationBloc bloc;

  const EmployeesFiltrationBlocFilterProvider(this.bloc);

  @override
  Map<String, dynamic> getFilterParams() {
    final params = <String, dynamic>{};

    if (bloc.selectedTeam != null) {
      params['teamId'] = bloc.selectedTeam!.id;
    }
    if (bloc.selectedSeniority != null) {
      params['seniorityLevelId'] = bloc.selectedSeniority!.id;
    }

    return params;
  }
}
