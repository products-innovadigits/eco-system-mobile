import 'package:project_management/core/utility/project_management_exports.dart';

class ProjectsSortingBottomSheet extends StatelessWidget {
  const ProjectsSortingBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProjectsSortingBloc, ProjectsSortingState>(
      builder: (context, state) {
        final sortingBloc = context.read<ProjectsSortingBloc>();
        // Options and the current tick come from the state, so a second tap
        // repaints the sheet instead of being swallowed as an equal state.
        final data = state is ProjectsSortingDataState ? state : null;
        final options = data?.options ?? const <DropListModel>[];
        final selectedKey = data?.selectedOption?.key;
        return SortingSheetContent(
          isLoading: state is SortingLoading,
          showActions:
              state is SortingOptionsLoaded ||
              state is SortingOptionSelected ||
              state is SortingApplied,
          options: options,
          selectedKey: selectedKey,
          hasSelection: data?.selectedOption != null,
          isApplied: data?.appliedOption != null,
          onSelect: (option) =>
              sortingBloc.add(SelectSortingOption(arguments: option)),
          onApply: () => sortingBloc.add(ApplySortingOption()),
          onReset: () => sortingBloc.add(ResetSortingOption()),
        );
      },
    );
  }
}
