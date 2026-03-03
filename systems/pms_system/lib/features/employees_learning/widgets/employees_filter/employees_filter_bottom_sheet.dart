import 'package:pms_system/core/utility/pms_exports.dart';
import 'package:pms_system/features/employees_learning/bloc/employees_learning_bloc.dart';
import 'package:pms_system/features/employees_learning/bloc/filtration/employees_filtration_bloc.dart';
import 'package:pms_system/features/employees_learning/bloc/filtration/employees_filtration_state.dart';
import 'package:pms_system/features/employees_learning/widgets/employees_filter/employees_filter_bottom_sheet_body.dart';

class EmployeesFilterBottomSheet extends StatelessWidget {
  const EmployeesFilterBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EmployeesFiltrationBloc, EmployeesFiltrationState>(
      buildWhen: (previous, current) =>
          previous.runtimeType != current.runtimeType ||
          (previous is EmployeesFiltrationLoaded &&
              current is EmployeesFiltrationLoaded &&
              previous.isFilterApplied != current.isFilterApplied),
      builder: (context, state) {
        final filterBloc = context.read<EmployeesFiltrationBloc>();
        final employeesBloc = context.read<EmployeesLearningBloc>();
        return Stack(
          children: [
            state is EmployeesFiltrationLoading
                ? const ShimmerCardsList(
                    itemCount: 2,
                    cardHeight: 50,
                    listPadding: 0,
                  )
                : const EmployeesFilterBottomSheetBody(),
            if (state is EmployeesFiltrationLoaded)
              _FilterButtonsSection(
                onApplyFilters: () =>
                    filterBloc.applyFilters(employeesBloc: employeesBloc),
                onResetFilters: () =>
                    filterBloc.resetFilters(employeesBloc: employeesBloc),
                isFiltered: state.isFilterApplied,
              ),
          ],
        );
      },
    );
  }
}

class _FilterButtonsSection extends StatelessWidget {
  final VoidCallback onApplyFilters;
  final VoidCallback onResetFilters;
  final bool isFiltered;

  const _FilterButtonsSection({
    required this.onApplyFilters,
    required this.onResetFilters,
    required this.isFiltered,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Row(
        children: [
          Expanded(
            child: CustomBtn(
              text: allTranslations.text(LocaleKeys.show_all_results),
              onPressed: onApplyFilters,
            ),
          ),
          if (isFiltered) ...[
            SizedBox(width: 8.w),
            Expanded(
              child: CustomBtn(
                text: allTranslations.text(LocaleKeys.reset),
                color: context.color.surfaceContainer,
                textColor: context.color.primary,
                borderColor: context.color.primary,
                onPressed: onResetFilters,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
