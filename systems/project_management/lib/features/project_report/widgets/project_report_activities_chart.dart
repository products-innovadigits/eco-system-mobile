import 'package:project_management/core/utility/pms_exports.dart';

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
    final bool isEmpty = activities.every(
      (activity) => (activity.value ?? 0) == 0,
    );
    return CustomExpansionCard(
      title: allTranslations.text(LocaleKeys.activities_number),
      withExpanded: false,
      withMargin: false,
      action: CustomInfoContainerWidget(
        title: '$totalActivities ${allTranslations.text(LocaleKeys.activity)}',
        color: context.color.tertiary,
      ),
      child: Column(
        children: [
          isEmpty
              ? Text(allTranslations.text(LocaleKeys.there_is_no_data))
              : ReportObjectivePercentageChartMobilePortrait(
                  activities: activities,
                ),
          SizedBox(height: 12.h),
          if (!isEmpty) ReportChartCategoriesSection(activities: activities),
        ],
      ),
    );
  }
}
