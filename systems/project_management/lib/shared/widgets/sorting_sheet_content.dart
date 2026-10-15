import 'package:project_management/core/utility/project_management_exports.dart';

/// The body of a sorting sheet: the options to pick from, then apply and
/// reset buttons once the options are loaded. Each action closes the sheet.
class SortingSheetContent extends StatelessWidget {
  final bool isLoading;
  final bool showActions;
  final List<DropListModel> options;
  final String? selectedKey;
  final bool hasSelection;
  final bool isApplied;
  final ValueChanged<DropListModel> onSelect;
  final VoidCallback onApply;
  final VoidCallback onReset;

  const SortingSheetContent({
    super.key,
    required this.isLoading,
    required this.showActions,
    required this.options,
    required this.selectedKey,
    required this.hasSelection,
    required this.isApplied,
    required this.onSelect,
    required this.onApply,
    required this.onReset,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        if (isLoading)
          const ShimmerCardsList(itemCount: 4, cardHeight: 40, listPadding: 0)
        else
          ListAnimator(
            separatorPadding: 16.h,
            customPadding: EdgeInsets.only(bottom: context.h * 0.1),
            data: [
              for (final option in options)
                CustomSortTileWidget(
                  title: option.name ?? '',
                  isSelected: selectedKey == option.key,
                  onSelect: () => onSelect(option),
                ),
            ],
          ),
        SizedBox(height: 80.h),
        if (showActions)
          FilterButtonsSection(
            canApply: hasSelection,
            isFiltered: isApplied,
            onApplyFilters: () {
              onApply();
              CustomNavigator.pop();
            },
            onResetFilters: () {
              onReset();
              CustomNavigator.pop();
            },
          ),
      ],
    );
  }
}
