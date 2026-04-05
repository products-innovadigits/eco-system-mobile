import 'package:pms_system/core/utility/pms_exports.dart';
import 'package:pms_system/features/employee_of_month_history/bloc/employee_of_month_history_bloc.dart';
import 'package:pms_system/features/employee_of_month_history/bloc/filtration/employee_of_month_history_filtration_bloc.dart';
import 'package:pms_system/features/employee_of_month_history/bloc/filtration/employee_of_month_history_filtration_state.dart';
import 'package:pms_system/features/employee_of_month_history/widgets/employee_of_month_history_filter_bottom_sheet_body.dart';

class EmployeeOfMonthHistoryFilterBottomSheet extends StatelessWidget {
  const EmployeeOfMonthHistoryFilterBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EmployeeOfMonthHistoryFiltrationBloc,
        EmployeeOfMonthHistoryFiltrationState>(
      buildWhen: (previous, current) =>
          previous.runtimeType != current.runtimeType ||
          (previous is EmployeeOfMonthHistoryFiltrationLoaded &&
              current is EmployeeOfMonthHistoryFiltrationLoaded &&
              previous.isFilterApplied != current.isFilterApplied),
      builder: (context, state) {
        final filterBloc =
            context.read<EmployeeOfMonthHistoryFiltrationBloc>();
        final historyBloc = context.read<EmployeeOfMonthHistoryBloc>();
        return Stack(
          children: [
            state is EmployeeOfMonthHistoryFiltrationLoading
                ? const ShimmerCardsList(
                    itemCount: 2,
                    cardHeight: 50,
                    listPadding: 0,
                  )
                : const EmployeeOfMonthHistoryFilterBottomSheetBody(),
            if (state is EmployeeOfMonthHistoryFiltrationLoaded)
              _FilterButtonsSection(
                onApplyFilters: () => filterBloc.applyFilters(
                  historyBloc: historyBloc,
                ),
                onResetFilters: () => filterBloc.resetFilters(
                  historyBloc: historyBloc,
                ),
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
