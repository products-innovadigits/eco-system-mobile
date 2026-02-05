import '../../../core/utility/pms_exports.dart';

class ProjectMonthlyProgressSection extends StatelessWidget {
  final GeneralProgressChartModel progressModel;
  final bool isMonthly;

  const ProjectMonthlyProgressSection({
    super.key,
    required this.progressModel,
    this.isMonthly = true,
  });

  @override
  Widget build(BuildContext context) {
    final List<ProgressItem> chartSeries = isMonthly
        ? progressModel.monthProgress ?? []
        : progressModel.yearProgress ?? [];
    return ProjectMonthlyProgress(
      progressItems: chartSeries,
      isMonthly: isMonthly,
    );
  }
}
