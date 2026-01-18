import 'package:pms_system/core/utility/pms_exports.dart';

class ReportChartCategoriesSection extends StatelessWidget {
  final List<ActivityBarModel> activities;

  const ReportChartCategoriesSection({super.key, required this.activities});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 12,
      runSpacing: 8,
      children: List.generate(activities.length, (index) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(
                color: Color(
                  int.parse(
                    (activities[index].background ?? '#000000').replaceFirst(
                      '#',
                      '0xff',
                    ),
                  ),
                ),
                shape: BoxShape.circle,
              ),
            ),
            SizedBox(width: 6.w),
            Text(
              activities[index].label ?? '-',
              style: context.textTheme.bodySmall,
            ),
          ],
        );
      }),
    );
  }
}
