import '../../shared/pms_exports.dart';

class ProjectReportActivitiesChart extends StatelessWidget {
  const ProjectReportActivitiesChart({super.key});

  @override
  Widget build(BuildContext context) {
    final List<ReportObjectivePercentageModel> objectives =
        _hardcodedObjectives();

    return CustomExpansionCard(
      title: allTranslations.text(LocaleKeys.activities_number),
      withExpanded: false,
      withMargin: false,
      action: CustomInfoContainerWidget(
        title:
            '${objectives.length} ${objectives.length > 10 ? allTranslations.text(LocaleKeys.activity) : allTranslations.text(LocaleKeys.the_activities)}',
        color: context.color.tertiary,
      ),
      child: Column(
        children: [
          ReportObjectivePercentageChartMobilePortrait(
            objectives: objectives,
            colors: _palette(context),
          ),
          const SizedBox(height: 12),
          ReportChartCategoriesSection(
            objectives: objectives,
            colors: _palette(context),
          ),
        ],
      ),
    );
  }

  List<ReportObjectivePercentageModel> _hardcodedObjectives() {
    return [
      ReportObjectivePercentageModel(
        categoryName: 'Objective A',
        value: 65,
        count: 0,
      ),
      ReportObjectivePercentageModel(
        categoryName: 'Objective B',
        value: 40,
        count: 0,
      ),
      ReportObjectivePercentageModel(
        categoryName: 'Objective C',
        value: 80,
        count: 0,
      ),
      ReportObjectivePercentageModel(
        categoryName: 'Objective D',
        value: 25,
        count: 0,
      ),
    ];
  }

  List<Color> _palette(BuildContext context) => const [
    Color(0xFF175CD3),
    Color(0xFFDC6803),
    Color(0xFF12B76A),
    Color(0xFF667085),
    Color(0xFF7A5AF8),
  ];
}
