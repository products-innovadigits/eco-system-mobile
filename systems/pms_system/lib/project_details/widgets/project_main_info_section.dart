import 'package:pms_system/project_details/widgets/project_challenges.dart';
import 'package:pms_system/shared/pms_exports.dart';

class ProjectMainInfoSection extends StatelessWidget {
  final ProjectDetailsModel model;

  const ProjectMainInfoSection({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 16,
      children: [
        ///Project Description
        CustomExpansionCard(
          title: allTranslations.text(LocaleKeys.project_details),
          withMargin: false,
          child: ProjectDetailsDescription(model: model),
        ),

        ///General Progress
        GeneralProgressSection(),

        ///Project Outputs
        CustomExpansionCard(
          title: allTranslations.text(LocaleKeys.the_outputs),
          withMargin: false,
          // Replace with actual data from model
          child: ProjectOutputsChart(data: _generateSampleOutputsData()),
        ),

        ///Project Progress
        CustomExpansionCard(
          title: allTranslations.text(LocaleKeys.overall_progress),
          withMargin: false,
          child: ProjectProgressChart(
            data: _generateSampleProgressData(),
          ),
        ),

        ///Challenges
        CustomExpansionCard(
          title: allTranslations.text(LocaleKeys.challenges),
          subTitle: '(70 ${allTranslations.text(LocaleKeys.challenge)})',
          subTitleStyle: context.textTheme.labelMedium?.copyWith(
            fontWeight: FontWeight.w700,
            color: context.color.secondary,
          ),
          withMargin: false,
          child: ProjectChallenges(),
        ),

        ///Risks
        CustomExpansionCard(
          title: allTranslations.text(LocaleKeys.risks),
          withMargin: false,
          child: ProjectRisks(),
        ),

        16.sh,
      ],
    );
  }

  // TODO: Replace this with actual data from the ProjectDetailsModel
  List<ProjectOutputModel> _generateSampleOutputsData() {
    return [
      ProjectOutputModel(
        type: ProjectOutputType.notStarted,
        titleKey: LocaleKeys.not_started_outputs,
        count: 95,
      ),
      ProjectOutputModel(
        type: ProjectOutputType.inProgress,
        titleKey: LocaleKeys.in_progress_outputs,
        count: 75,
      ),
      ProjectOutputModel(
        type: ProjectOutputType.completed,
        titleKey: LocaleKeys.completed_outputs,
        count: 80,
      ),
      ProjectOutputModel(
        type: ProjectOutputType.total,
        titleKey: LocaleKeys.total,
        count: 120,
      ),
    ];
  }

  // TODO: Replace this with actual data from the ProjectDetailsModel
  List<ProjectProgressItemModel> _generateSampleProgressData() {
    return [
      ProjectProgressItemModel(
        type: ProjectProgressType.totalDelivery,
        titleKey: LocaleKeys.total_delivery,
        percentage: 100,
      ),
      ProjectProgressItemModel(
        type: ProjectProgressType.financing,
        titleKey: LocaleKeys.financing,
        percentage: 62,
      ),
      ProjectProgressItemModel(
        type: ProjectProgressType.activities,
        titleKey: LocaleKeys.activities,
        percentage: 25,
      ),
      ProjectProgressItemModel(
        type: ProjectProgressType.outputs,
        titleKey: LocaleKeys.outputs_progress,
        percentage: 45,
      ),
    ];
  }
}


// ///Progress at each stage of the project
// CustomExpansionCard(
// title: allTranslations.text(
// LocaleKeys.progress_at_each_stage_of_the_project,
// ),
// withMargin: false,
// child: ProjectStagesChart(
// barColor: context.color.primary,
// textColor: context.color.outlineVariant,
// withIntervals: false,
// data:
// model.projectLifeCycle?.projectStages
//     ?.map(
// (e) => ProjectCategoriesProgressModel(
// name: e.title ?? "",
// progress: e.progress ?? 0,
// ),
// )
//     .toList() ??
// [],
// // data: [
// //   ProjectCategoriesProgressModel(name: "Stage 1", progress: 20),
// //   ProjectCategoriesProgressModel(name: "Stage 2", progress: 40),
// //   ProjectCategoriesProgressModel(name: "Stage 3", progress: 60),
// //   ProjectCategoriesProgressModel(name: "Stage 4", progress: 80),
// // ],
// ),
// ),