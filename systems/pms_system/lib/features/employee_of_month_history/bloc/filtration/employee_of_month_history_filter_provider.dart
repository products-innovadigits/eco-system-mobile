import 'package:pms_system/features/employee_of_month_history/bloc/filtration/employee_of_month_history_filtration_bloc.dart';

abstract class EmployeeOfMonthHistoryFilterProvider {
  Map<String, dynamic> getFilterParams();
}

class EmployeeOfMonthHistoryFiltrationBlocFilterProvider
    implements EmployeeOfMonthHistoryFilterProvider {
  final EmployeeOfMonthHistoryFiltrationBloc bloc;

  const EmployeeOfMonthHistoryFiltrationBlocFilterProvider(this.bloc);

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
