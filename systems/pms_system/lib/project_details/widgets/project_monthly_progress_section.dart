import 'package:pms_system/project_details/model/general_progress_chart_model.dart';

import '../../shared/pms_exports.dart';

class ProjectMonthlyProgressSection extends StatelessWidget {
  final List<ProgressSeriesItem> chartSeries;
  final bool isMonthly;

  const ProjectMonthlyProgressSection({
    super.key,
    required this.chartSeries,
    this.isMonthly = true,
  });

  @override
  Widget build(BuildContext context) {
    return ProjectMonthlyProgress(
      data: List.generate(
        chartSeries.length,
        (index) => ProjectCategoriesProgressModel(
          name: isMonthly
              ? chartSeries[index].period?.substring(5)
              : chartSeries[index].period ?? '',
          progress: chartSeries[index].percent?.toDouble(),
        ),
      ),
    );
  }
}
