import '../../../shared/pms_exports.dart';

/// Months header row (12 equally sized month cells).
class TimelineMonthsHeader extends StatelessWidget {
  final double width, monthWidth, height;

  const TimelineMonthsHeader({super.key,
    required this.width,
    required this.monthWidth,
    required this.height,
  });

  @override
  Widget build(BuildContext context) {
    const List<String> kArabicMonths = [
      'يناير',
      'فبراير',
      'مارس',
      'أبريل',
      'مايو',
      'يونيو',
      'يوليو',
      'أغسطس',
      'سبتمبر',
      'أكتوبر',
      'نوفمبر',
      'ديسمبر',
    ];
    return SizedBox(
      width: width,
      height: height,
      child: Row(
        children: List.generate(12, (m) {
          return Container(
            width: monthWidth,
            height: height,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: LightColor.timelineHeader.withValues(alpha: 0.5),
              border: Border.all(color: LightColor.timelineBorder),
            ),
            child: Text(
              kArabicMonths[m],
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