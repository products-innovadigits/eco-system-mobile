import '../../../../core/utility/pms_exports.dart';

class MonthlyProgressYAxis extends StatelessWidget {
  const MonthlyProgressYAxis({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(
        6, // 0, 20, 40, 60, 80, 100
        (index) {
          final value =
              (5 - index) * 20.0; // Reverse to show from top to bottom
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 4.w),
            child: Text(
              '${value.toInt()}%',
              style: context.textTheme.bodySmall?.copyWith(
                color: context.color.outlineVariant,
              ),
            ),
          );
        },
      ),
    );
  }
}
