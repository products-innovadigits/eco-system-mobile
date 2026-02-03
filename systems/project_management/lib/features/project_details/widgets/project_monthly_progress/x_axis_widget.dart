import '../../../../core/utility/pms_exports.dart';

class MonthlyProgressXAxis extends StatelessWidget {
  final List<ProjectCategoriesProgressModel> data;
  final double perPointWidth;

  const MonthlyProgressXAxis({
    super.key,
    required this.data,
    required this.perPointWidth,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: List.generate(data.length, (index) {
        final label = data[index].name ?? '';
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
