import 'package:project_management/core/utility/project_management_exports.dart';
import 'package:project_management/shared/widgets/project_risks.dart';

class ProjectMainInfoTab extends StatelessWidget {
  final ProjectDetailsModel projectDetailsModel;

  const ProjectMainInfoTab({super.key, required this.projectDetailsModel});

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 16,
      children: [
        ///Description
        CustomExpansionCard(
          title: allTranslations.text(LocaleKeys.project_details),
          withMargin: false,
          withExpanded: false,
          action: CustomInfoContainerWidget(
            color: context.color.errorContainer,
            title: projectDetailsModel.projectCategoryName ?? '',
            radius: 16,
          ),
          child: ProjectDetailsDescription(model: projectDetailsModel),
        ),

        ///General Progress
        GeneralProgressSection(projectId: projectDetailsModel.id ?? 0),

        ///General Progress
        if (projectDetailsModel.mobileDetails?.progress != null)
          CustomExpansionCard(
            title: allTranslations.text(LocaleKeys.overall_progress),
            withMargin: false,
            withExpanded: false,
            action: _averageProgressWidget(
              context,
              progress:
                  (projectDetailsModel
                              .mobileDetails
                              ?.progress
                              ?.averageProgress ??
                          0)
                      .toString(),
            ),
            child: CustomBarChart(
              data: _generateGeneralProgressData(
                projectDetailsModel.mobileDetails!.progress!,
              ),
              // chartHeight: 180,
            ),
          ),

        ///Outputs
        CustomExpansionCard(
          title: allTranslations.text(LocaleKeys.the_outputs),
          withMargin: false,
          withExpanded: false,
          action: _outputsBottomSheetBtn(
            context,
            outputsSummary:
                projectDetailsModel.mobileDetails?.outputsSummary ?? [],
          ),
          child: ProjectOutputsChart(
            data: projectDetailsModel.mobileDetails?.outputsSummary ?? [],
          ),
        ),

        ///Project Funding
        // ProjectDetailsFundingChart(
        //   data: _generateSampleFundingData(
        //     projectDetailsModel.mobileDetails?.budget ?? [],
        //   ),
        //   projectBudget: (projectDetailsModel.budget ?? 0.0).toDouble(),
        // ),
        ProjectReportFundingChart(
          data: _generateSampleFundingData(
            projectDetailsModel.mobileDetails?.budget ?? [],
          ),
          projectBudget: (projectDetailsModel.budget ?? 0.0).toDouble(),
          rightChartPadding: 60,
        ),

        ///Challenges
        CustomExpansionCard(
          title: allTranslations.text(LocaleKeys.the_challenges),
          subTitle:
              '(${projectDetailsModel.mobileDetails?.challenges?.total} ${allTranslations.text(LocaleKeys.challenge)})',
          subTitleStyle: context.textTheme.labelMedium?.copyWith(
            fontWeight: FontWeight.w700,
            color: context.color.secondary,
          ),
          withMargin: false,
          child: ProjectChallenges(
            challenges:
                projectDetailsModel.mobileDetails?.challenges?.items ?? [],
          ),
        ),

        ///Risks
        CustomExpansionCard(
          title: allTranslations.text(LocaleKeys.risks),
          withMargin: false,
          child: ProjectRisks(
            risksList: projectDetailsModel.mobileDetails?.risks ?? [],
          ),
        ),

        SizedBox(height: 16.h),
      ],
    );
  }

  List<ProjectCategoriesProgressModel> _generateGeneralProgressData(
    MobileProgressModel progressModel,
  ) {
    return progressModel.bars
            ?.map(
              (bar) => ProjectCategoriesProgressModel(
                name: bar.label ?? "",
                progress: bar.value ?? 0,
                color: Color(
                  int.parse(bar.background!.replaceFirst('#', '0xff')),
                ),
              ),
            )
            .toList() ??
        [];
  }

  // TODO: Replace this with actual data from the ProjectDetailsModel
  List<ProjectsOverviewData> _generateSampleFundingData(
    List<MobileBudgetModel> budgeList,
  ) {
    return budgeList
        .map(
          (budget) => ProjectsOverviewData(
            name: budget.label ?? '',
            count: budget.amount ?? 0,
            hexColor: budget.background ?? '#000000',
            percentage: budget.percent ?? 0,
          ),
        )
        .toList();
    // return [
    //   ProjectsOverviewData(
    //     name: 'المتبقي',
    //     count: 100000,
    //     hexColor: '#175CD3',
    //     percentage: 10,
    //   ),
    //   ProjectsOverviewData(
    //     name: 'الغرامات',
    //     count: 600000,
    //     hexColor: '#020F4C',
    //     percentage: 60,
    //   ),
    //   ProjectsOverviewData(
    //     name: 'المنصرف',
    //     count: 400000,
    //     hexColor: '#DC6803',
    //     percentage: 40,
    //   ),
    // ];
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

Widget _outputsBottomSheetBtn(
  BuildContext context, {
  required List<MobileOutputsSummaryModel> outputsSummary,
}) {
  return InkWell(
    onTap: () {
      PopUpHelper.showBottomSheet(
        header: allTranslations.text(LocaleKeys.outputs),
        child: ProjectOutputsBottomSheet(outputsSummary: outputsSummary),
      );
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
