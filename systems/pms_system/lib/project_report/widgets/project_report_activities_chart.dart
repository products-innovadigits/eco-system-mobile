import '../../shared/pms_exports.dart';

class ProjectReportActivitiesChart extends StatelessWidget {
  final List<ActivityBarModel> activities;
  final int totalActivities;

  const ProjectReportActivitiesChart({
    super.key,
    required this.activities,
    required this.totalActivities,
  });

  @override
  Widget build(BuildContext context) {
    return CustomExpansionCard(
      title: allTranslations.text(LocaleKeys.activities_number),
      withExpanded: false,
      withMargin: false,
      action: CustomInfoContainerWidget(
        title:
            '$totalActivities ${allTranslations.text(LocaleKeys.activity)}',
        color: context.color.tertiary,
      ),
      child: Column(
        children: [
          ReportObjectivePercentageChartMobilePortrait(activities: activities),
          const SizedBox(height: 12),
          ReportChartCategoriesSection(activities: activities),
        ],
      ),
    );
  }
}
