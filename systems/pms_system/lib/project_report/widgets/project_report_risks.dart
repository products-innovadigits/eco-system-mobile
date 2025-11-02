import '../../shared/pms_exports.dart';

class ProjectReportRisks extends StatelessWidget {
  final List<ProjectReportRiskModel> reportRisks;

  const ProjectReportRisks({super.key, required this.reportRisks});

  @override
  Widget build(BuildContext context) {
    return CustomExpansionCard(
      title: allTranslations.text(LocaleKeys.risks),
      withMargin: false,
      withExpanded: false,
      action: CustomInfoContainerWidget(
        color: context.color.error,
        title:
            '${reportRisks.length} ${allTranslations.text(LocaleKeys.risk)}',
      ),
      child: CustomBarChart(
        showPercentageAxis: false,
        data: [
          ProjectCategoriesProgressModel(
            name: 'High',
            progress: 20,
            color: context.color.error,
          ),
          ProjectCategoriesProgressModel(
            name: 'Medium',
            progress: 40,
            color: context.color.errorContainer,
          ),
          ProjectCategoriesProgressModel(
            name: 'Low',
            progress: 60,
            color: context.color.primary,
          ),
        ],
        // chartHeight: 180,
      ),
    );
  }
}
