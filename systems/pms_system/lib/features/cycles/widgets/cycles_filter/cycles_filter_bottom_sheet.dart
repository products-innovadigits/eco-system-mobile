import 'package:pms_system/core/utility/pms_exports.dart';
import 'package:pms_system/features/cycles/bloc/cycles_bloc.dart';
import 'package:pms_system/features/cycles/bloc/filtration/cycles_filtration_bloc.dart';
import 'package:pms_system/features/cycles/bloc/filtration/cycles_filtration_state.dart';
import 'package:pms_system/features/cycles/widgets/cycles_filter/cycles_filter_bottom_sheet_body.dart';

class CyclesFilterBottomSheet extends StatelessWidget {
  const CyclesFilterBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CyclesFiltrationBloc, CyclesFiltrationState>(
      buildWhen: (previous, current) =>
          previous.runtimeType != current.runtimeType ||
          (previous is CyclesFiltrationLoaded &&
              current is CyclesFiltrationLoaded &&
              previous.isFilterApplied != current.isFilterApplied),
      builder: (context, state) {
        final filterBloc = context.read<CyclesFiltrationBloc>();
        final cyclesBloc = context.read<CyclesBloc>();
        return Stack(
          children: [
            state is CyclesFiltrationLoaded
                ? const CyclesFilterBottomSheetBody()
                : const ShimmerCardsList(
                    itemCount: 1,
                    cardHeight: 50,
                    listPadding: 0,
                  ),
            if (state is CyclesFiltrationLoaded)
              _FilterButtonsSection(
                onApplyFilters: () =>
                    filterBloc.applyFilters(cyclesBloc: cyclesBloc),
                onResetFilters: () =>
                    filterBloc.resetFilters(cyclesBloc: cyclesBloc),
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
