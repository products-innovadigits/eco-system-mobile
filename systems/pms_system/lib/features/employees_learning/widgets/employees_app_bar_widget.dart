import 'package:pms_system/core/utility/pms_exports.dart';
import 'package:pms_system/features/employees_learning/bloc/employees_learning_bloc.dart';
import 'package:pms_system/features/employees_learning/bloc/employees_learning_events.dart';
import 'package:pms_system/features/employees_learning/bloc/filtration/employees_filtration_bloc.dart';
import 'package:pms_system/features/employees_learning/bloc/filtration/employees_filtration_state.dart';
import 'package:pms_system/features/employees_learning/widgets/employees_filter/employees_filter_bottom_sheet.dart';

class EmployeesAppBarWidget extends StatelessWidget
    implements PreferredSizeWidget {
  final EmployeesLearningBloc bloc;
  final TextEditingController searchController;
  final bool isPortrait;

  const EmployeesAppBarWidget({
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
    return BlocBuilder<EmployeesFiltrationBloc, EmployeesFiltrationState>(
      builder: (context, filtrationState) {
        final filtrationBloc = context.read<EmployeesFiltrationBloc>();
        final isFiltered = filtrationState is EmployeesFiltrationLoaded
            ? filtrationState.isFilterApplied
            : false;

        return CustomAppBar(
          title: allTranslations.text(LocaleKeys.employees_leaning),
          withSearch: true,
          withFilter: true,
          isFiltered: isFiltered,
          withCancelBtn: true,
          onSearching: (value) => bloc.add(EmployeesSearchChanged(value)),
          onCanceling: () => bloc.add(const EmployeesSearchChanged('')),
          searchController: searchController,
          searchHintText: allTranslations.text(LocaleKeys.search_hint),
          onFiltering: () {
            if (!isFiltered) {
              filtrationBloc.clearFilters();
            }
            filtrationBloc.loadFilterOptions();
            PopUpHelper.showBottomSheet(
              header: allTranslations.text(LocaleKeys.filtration),
              child: MultiBlocProvider(
                providers: [
                  BlocProvider<EmployeesLearningBloc>.value(value: bloc),
                  BlocProvider<EmployeesFiltrationBloc>.value(
                    value: filtrationBloc,
                  ),
                ],
                child: const EmployeesFilterBottomSheet(),
              ),
            );
          },
        );
      },
    );
  }
}
