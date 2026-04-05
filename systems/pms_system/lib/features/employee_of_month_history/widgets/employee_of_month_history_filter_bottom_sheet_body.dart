import 'package:core_system/core/components/custom_filters_drop_list.dart';
import 'package:pms_system/core/utility/pms_exports.dart';
import 'package:pms_system/features/employee_of_month_history/bloc/filtration/employee_of_month_history_filtration_bloc.dart';

class EmployeeOfMonthHistoryFilterBottomSheetBody extends StatelessWidget {
  const EmployeeOfMonthHistoryFilterBottomSheetBody({super.key});

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<EmployeeOfMonthHistoryFiltrationBloc>();
    return SizedBox(
      height: context.h * 0.4,
      child: ListAnimator(
        separatorPadding: 16.h,
        data: [
          SizedBox(height: 16.h),
          CustomFiltersDropList(
            labelText: LocaleKeys.team,
            hintText: LocaleKeys.select_team,
            options: bloc.teamsList,
            initial: bloc.selectedTeam,
            onSelect: (s) {
              bloc.selectedTeam = s;
            },
          ),
          CustomFiltersDropList(
            labelText: LocaleKeys.seniority_level,
            hintText: LocaleKeys.select_seniority_level,
            options: bloc.seniorityList,
            initial: bloc.selectedSeniority,
            onSelect: (s) {
              bloc.selectedSeniority = s;
            },
          ),
        ],
      ),
    );
  }
}
