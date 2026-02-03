import 'package:project_management/core/utility/pms_exports.dart';

class LatestRequestFilterBottomSheet extends StatelessWidget {
  const LatestRequestFilterBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<
      LatestRequestFiltrationCubit,
      LatestRequestFiltrationState
    >(
      buildWhen: (previous, current) =>
          previous.runtimeType != current.runtimeType,
      builder: (context, state) {
        final filterCubit = context.read<LatestRequestFiltrationCubit>();
        final latestRequestCubit = context.read<LatestRequestCubit>();
        return Stack(
          children: [
            state is LatestRequestFiltrationLoading
                ? const ShimmerCardsList(
                    itemCount: 4,
                    cardHeight: 50,
                    listPadding: 0,
                  )
                : const LatestRequestFilterBottomSheetBody(),
            if (state is LatestRequestFiltrationLoaded)
              LatestRequestFilterButtonsSection(
                onApplyFilters: () => filterCubit.applyFilters(
                  latestRequestCubit: latestRequestCubit,
                ),
                onResetFilters: () => filterCubit.resetFilters(
                  latestRequestCubit: latestRequestCubit,
                ),
                isFiltered: state.isFilterApplied,
              ),
          ],
        );
      },
    );
  }
}
