import 'package:project_management/core/utility/project_management_exports.dart';

class LatestRequestSortingBottomSheet extends StatelessWidget {
  const LatestRequestSortingBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LatestRequestSortingCubit, LatestRequestSortingState>(
      builder: (context, state) {
        final sortingCubit = context.read<LatestRequestSortingCubit>();
        // Options and the current tick come from the state, so a second tap
        // repaints the sheet instead of being swallowed as an equal state.
        final data = state is LatestRequestSortingDataState ? state : null;
        final options = data?.options ?? const <DropListModel>[];
        final selectedKey = data?.selectedOption?.key;
        return SortingSheetContent(
          isLoading: state is LatestRequestSortingLoading,
          showActions:
              state is LatestRequestSortingOptionsLoaded ||
              state is LatestRequestSortingOptionSelected ||
              state is LatestRequestSortingApplied,
          options: options,
          selectedKey: selectedKey,
          hasSelection: data?.selectedOption != null,
          isApplied: data?.appliedOption != null,
          onSelect: sortingCubit.selectSortingOption,
          onApply: sortingCubit.applySorting,
          onReset: sortingCubit.resetSorting,
        );
      },
    );
  }
}
