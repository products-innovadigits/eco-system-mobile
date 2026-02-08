import '../../../../core/utility/project_management_exports.dart';

class MonthlyProgressXAxis extends StatelessWidget {
  final List<ProgressItem> data;
  final double perPointWidth;
  final bool isMonthly;

  const MonthlyProgressXAxis({
    super.key,
    required this.data,
    required this.perPointWidth,
    this.isMonthly = true,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: List.generate(data.length, (index) {
        final label = isMonthly
            ? data[index].month.toString()
            : data[index].year.toString();
        return SizedBox(
          width: perPointWidth,
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: context.textTheme.bodySmall?.copyWith(
              color: context.color.outlineVariant,
            ),
          ),
        );
      }),
    );
  }
}
