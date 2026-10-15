import 'package:core_system/core/utility/export.dart';

/// The bottom row of a filter sheet: apply the filters, and reset them once
/// any are applied. Positioned at the bottom of the sheet's [Stack].
///
/// [canApply] disables the apply button, e.g. until a filter is chosen.
class FilterButtonsSection extends StatelessWidget {
  final VoidCallback onApplyFilters;
  final VoidCallback onResetFilters;
  final bool isFiltered;
  final bool canApply;

  const FilterButtonsSection({
    super.key,
    required this.onApplyFilters,
    required this.onResetFilters,
    required this.isFiltered,
    this.canApply = true,
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
              active: canApply,
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
