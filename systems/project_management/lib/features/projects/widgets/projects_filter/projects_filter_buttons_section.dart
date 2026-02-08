import '../../../../core/utility/project_management_exports.dart';

class ProjectsFilterButtonsSection extends StatelessWidget {
  final VoidCallback onApplyFilters;
  final VoidCallback onResetFilters;
  final bool isFiltered;

  const ProjectsFilterButtonsSection({
    super.key,
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
