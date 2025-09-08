import '../../../shared/pms_exports.dart';

/// Weeks header row (4 week cells per month, with optional grid lines).
class TimelineWeeksHeader extends StatelessWidget {
  final double width, monthWidth, height, weekWidth;

  const TimelineWeeksHeader({
    super.key,
    required this.width,
    required this.monthWidth,
    required this.height,
    required this.weekWidth,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: LightColor.timelineBorder.withValues(alpha: 0.4), width: 1),
        ),
      ),
      child: Row(
        children: List.generate(12, (m) {
          return SizedBox(
            width: monthWidth,
            height: height,
            child: Row(
              children: List.generate(4, (w) {
                return SizedBox(
                  width: weekWidth,
                  height: height,
                  child: Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      border: Border.all(color: LightColor.timelineBorder.withValues(alpha: 0.4)),
                    ),
                    child: Text(
                      '${w + 1}',
                      style: context.textTheme.labelLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                );
              }),
            ),
          );
        }),
      ),
    );
  }
}
