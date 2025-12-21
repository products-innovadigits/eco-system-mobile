import 'package:core_system/core/utility/export.dart';
import 'package:pms_system/project_report/model/project_report_model.dart';

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
            const SizedBox(width: 6),
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
