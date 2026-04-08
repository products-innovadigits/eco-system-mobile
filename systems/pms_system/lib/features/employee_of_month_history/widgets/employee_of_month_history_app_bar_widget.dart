import 'package:pms_system/core/utility/pms_exports.dart';
import 'package:pms_system/features/employee_of_month_history/bloc/employee_of_month_history_bloc.dart';
import 'package:pms_system/features/employee_of_month_history/bloc/filtration/employee_of_month_history_filtration_bloc.dart';
import 'package:pms_system/features/employee_of_month_history/bloc/filtration/employee_of_month_history_filtration_state.dart';

class EmployeeOfMonthHistoryAppBarWidget extends StatelessWidget
    implements PreferredSizeWidget {
  final EmployeeOfMonthHistoryBloc bloc;
  final TextEditingController searchController;
  final bool isPortrait;

  const EmployeeOfMonthHistoryAppBarWidget({
    super.key,
    required this.bloc,
    required this.searchController,
    this.isPortrait = true,
  });

  @override
  Size get preferredSize => Size(
    CustomNavigator.navigatorState.currentContext!.w,
    isPortrait ? 122.h : 200.h,
  );

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<
      EmployeeOfMonthHistoryFiltrationBloc,
      EmployeeOfMonthHistoryFiltrationState
    >(
      builder: (context, filtrationState) {
        final isFiltered =
            filtrationState is EmployeeOfMonthHistoryFiltrationLoaded
            ? filtrationState.isFilterApplied
            : false;

        return CustomAppBar(
          title: allTranslations.text(LocaleKeys.employee_of_the_month_history),
          // withSearch: true,
          isFiltered: isFiltered,
          withCancelBtn: true,
          // onSearching: (value) =>
          //     bloc.add(EmployeeOfMonthHistorySearchChanged(value)),
          // onCanceling: () =>
          //     bloc.add(const EmployeeOfMonthHistorySearchChanged('')),
          // searchController: searchController,
          // searchHintText: allTranslations.text(LocaleKeys.search_hint),
          // onFiltering: () {
          //   if (!isFiltered) {
          //     filtrationBloc.clearFilters();
          //   }
          //   filtrationBloc.loadFilterOptions();
          //   PopUpHelper.showBottomSheet(
          //     header: allTranslations.text(LocaleKeys.filtration),
          //     child: MultiBlocProvider(
          //       providers: [
          //         BlocProvider<EmployeeOfMonthHistoryBloc>.value(value: bloc),
          //         BlocProvider<EmployeeOfMonthHistoryFiltrationBloc>.value(
          //           value: filtrationBloc,
          //         ),
          //       ],
          //       child: const EmployeeOfMonthHistoryFilterBottomSheet(),
          //     ),
          //   );
          // },
        );
      },
    );
  }
}
