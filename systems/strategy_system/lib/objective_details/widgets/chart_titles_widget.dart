import '../../shared/strategy_exports.dart';

class ChartTitlesWidget extends StatelessWidget {
  const ChartTitlesWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.start,
      direction: Axis.horizontal,
      runSpacing: 8.w,
      spacing: 24.h,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.circle, color: context.color.secondary, size: 14),
            SizedBox(width: 4.w),
            Flexible(
              child: Text(
                allTranslations.text(LocaleKeys.objectives),
                style: context.textTheme.bodySmall,
              ),
            ),
          ],
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.circle, color: context.color.primary, size: 14),
            SizedBox(width: 4.w),
            Flexible(
              child: Text(
                allTranslations.text(LocaleKeys.initiatives),
                style: context.textTheme.bodySmall,
              ),
            ),
          ],
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.circle, color: context.color.tertiary, size: 14),
            SizedBox(width: 4.w),
            Flexible(
              child: Text(
                allTranslations.text(LocaleKeys.kpis),
                style: context.textTheme.bodySmall,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
