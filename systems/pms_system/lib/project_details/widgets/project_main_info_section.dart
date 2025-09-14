import 'package:pms_system/project_details/widgets/project_challenges.dart';
import 'package:pms_system/project_details/widgets/project_details_funding_chart.dart';
import 'package:pms_system/project_details/widgets/project_details_general_progress_chart.dart';
import 'package:pms_system/project_details/widgets/project_outputs_bottom_sheet.dart';
import 'package:pms_system/shared/pms_exports.dart';

class ProjectMainInfoSection extends StatelessWidget {
  final ProjectDetailsModel model;

  const ProjectMainInfoSection({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 16,
      children: [
        ///Description
        CustomExpansionCard(
          title: allTranslations.text(LocaleKeys.project_details),
          withMargin: false,
          child: ProjectDetailsDescription(model: model),
        ),

        ///General Progress
        GeneralProgressSection(),

        ///General Progress
        CustomExpansionCard(
          title: allTranslations.text(LocaleKeys.overall_progress),
          withMargin: false,
          withExpanded: false,
          action: _averageProgressWidget(context, progress: '50'),
          child: ProjectDetailsGeneralProgressChart(
            data: _generateSampleProgressData(),
          ),
        ),

        ///Outputs
        CustomExpansionCard(
          title: allTranslations.text(LocaleKeys.the_outputs),
          withMargin: false,
          withExpanded: false,
          action: _outputsBottomSheetBtn(context),
          child: ProjectOutputsChart(data: _generateSampleOutputsData()),
        ),

        ///Project Funding
        ProjectDetailsFundingChart(data: _generateSampleFundingData()),

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
  List<ProjectCategoriesProgressModel> _generateSampleProgressData() {
    return [
      ProjectCategoriesProgressModel(
        name: "الجدول الزمني",
        progress: 20.5,
        color: LightColor.tertiaryLight,
      ),
      ProjectCategoriesProgressModel(
        name: "الميزانية",
        progress: 55,
        color: LightColor.secondary,
      ),
      ProjectCategoriesProgressModel(
        name: "الأنشطة",
        progress: 72,
        color: LightColor.error,
      ),
      ProjectCategoriesProgressModel(
        name: "المخرجات",
        progress: 90,
        color: LightColor.warning,
      ),
    ];
  }

  // TODO: Replace this with actual data from the ProjectDetailsModel
  List<ProjectsOverviewData> _generateSampleFundingData() {
    return [
      ProjectsOverviewData(
        name: 'المتبقي',
        count: 100000,
        hexColor: '#175CD3',
        percentage: 10,
      ),
      ProjectsOverviewData(
        name: 'الغرامات',
        count: 600000,
        hexColor: '#020F4C',
        percentage: 60,
      ),
      ProjectsOverviewData(
        name: 'المنصرف',
        count: 400000,
        hexColor: '#DC6803',
        percentage: 40,
      ),
    ];
  }
}

Widget _averageProgressWidget(
  BuildContext context, {
  required String progress,
}) {
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 6.h),
    decoration: BoxDecoration(
      color: context.color.secondary.withValues(alpha: 0.1),
      borderRadius: BorderRadius.circular(20),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          '${allTranslations.text(LocaleKeys.average_progress_percentage)} ($progress%)',
          style: context.textTheme.labelSmall?.copyWith(
            color: context.color.secondary,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(width: 8.w),
        Icon(Icons.info_outline, color: context.color.secondary, size: 18),
      ],
    ),
  );
}

Widget _outputsBottomSheetBtn(BuildContext context) {
  return InkWell(
    onTap: () {
      PopUpHelper.showBottomSheet(child: ProjectOutputsBottomSheet());
    },
    child: Text(
      allTranslations.text(LocaleKeys.view_more),
      style: context.textTheme.labelSmall?.copyWith(
        color: context.color.secondary,
      ),
    ),
  );
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
