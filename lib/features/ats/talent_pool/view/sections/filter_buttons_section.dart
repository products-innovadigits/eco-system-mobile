import 'package:eco_system/utility/export.dart';

class FilterButtonsSection extends StatelessWidget {
  final CandidateFilterModel filterModel;
  final VoidCallback onApplyFilters;
  final VoidCallback onResetFilters;
  final bool isFiltered;

  const FilterButtonsSection(
      {super.key,
      required this.filterModel,
      required this.onApplyFilters,
      required this.onResetFilters,
      required this.isFiltered});

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
              active: filterModel.hasActiveFilters,
              onPressed: onApplyFilters,
            ),
          ),
          if (isFiltered) ...[
            8.sw,
            Expanded(
              child: CustomBtn(
                text: allTranslations.text(LocaleKeys.reset),
                color: Styles.WHITE_COLOR,
                textColor: Styles.PRIMARY_COLOR,
                borderColor: Styles.PRIMARY_COLOR,
                onPressed: onResetFilters,
              ),
            ),
          ]
        ],
      ),
    );
  }
}
