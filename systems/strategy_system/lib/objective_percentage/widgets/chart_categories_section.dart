import '../../shared/strategy_exports.dart';

class ChartCategoriesSection extends StatelessWidget {
  final List<ObjectivePercentageModel> objectives;
  const ChartCategoriesSection({super.key, required this.objectives});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.start,
      direction: Axis.horizontal,
      runSpacing: 8.w,
      spacing: 24.h,
      children: List.generate(
        objectives.length,
            (i) => Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.circle,
              color: Styles.statusColors(objectives[i].categoryName ?? ""),
              size: 14,
            ),
            SizedBox(width: 4.w),
            Flexible(
              child: RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  text: objectives[i].categoryName,
                  style: context.textTheme.bodyMedium,
                  children: [
                    // TextSpan(
                    //   text: " ${78}",
                    //   style: AppTextStyles.w400.copyWith(
                    //       fontSize: 12,
                    //       color: Styles.DETAILS),
                    // )
                  ],
                ),
              ),
            ),
            SizedBox(width: 4.w),
            Text(
              '(${objectives[i].count})',
              style: context.textTheme.bodyMedium?.copyWith(
                color: context.color.outlineVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
