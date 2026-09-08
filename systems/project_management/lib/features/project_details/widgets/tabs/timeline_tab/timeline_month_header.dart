import 'package:project_management/core/utility/project_management_exports.dart';

/// Months header row (dynamically sized based on project months).
class TimelineMonthsHeader extends StatelessWidget {
  final double width, monthWidth, height;
  final List<ProjectMonth> months;

  const TimelineMonthsHeader({
    super.key,
    required this.width,
    required this.monthWidth,
    required this.height,
    required this.months,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: Row(
        children: List.generate(months.length, (m) {
          return Container(
            width: monthWidth,
            height: height,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: LightColor.timelineHeader.withValues(alpha: 0.5),
              border: Border.all(color: LightColor.timelineGridLine),
            ),
            child: Text(
              months[m].displayName,
              style: context.textTheme.labelLarge?.copyWith(
                fontWeight: FontWeight.w600,
                color: context.color.secondary,
              ),
              textAlign: TextAlign.center,
            ),
          );
        }),
      ),
    );
  }
}
