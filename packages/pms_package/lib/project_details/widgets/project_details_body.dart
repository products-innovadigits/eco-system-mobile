
import 'package:pms_package/project_details/widgets/general_progress_section.dart';
import 'package:pms_package/project_details/widgets/project_stages_chart.dart';
import 'package:pms_package/shared/pms_exports.dart';

class ProjectDetailsBody extends StatelessWidget {
  const ProjectDetailsBody({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProjectDetailsBloc, AppState>(
      builder: (context, state) {
        if (state is Done) {
          ProjectDetailsModel model = state.model as ProjectDetailsModel;
          return Column(
            children: [
              ProjectCardContent(project: model, isDetails: true),
              SizedBox(height: 12.h),

              ///Project Description
              CustomExpansionCard(
                title: allTranslations.text(LocaleKeys.main_data),
                child: ProjectDetailsDescription(
                  model: model,
                ),
              ),

              CustomExpansionCard(
                title: allTranslations.text(LocaleKeys.challenges_risks),
                child: ProjectsChallengesRisks(),
              ),

              ///Progress at each stage of the project
              CustomExpansionCard(
                title: allTranslations
                    .text("progress_at_each_stage_of_the_project"),
                child: ProjectStagesChart(
                    barColor: context.color.primary,
                    textColor: context.color.outlineVariant,
                    withIntervals: false,
                    data: model.projectLifeCycle?.projectStages
                            ?.map((e) => ProjectCategoriesProgressModel(
                                name: e.title ?? "", progress: e.progress ?? 0))
                            .toList() ??
                        []
                  // data: [
                  //   ProjectCategoriesProgressModel(name: "Stage 1", progress: 20),
                  //   ProjectCategoriesProgressModel(name: "Stage 2", progress: 40),
                  //   ProjectCategoriesProgressModel(name: "Stage 3", progress: 60),
                  //   ProjectCategoriesProgressModel(name: "Stage 4", progress: 80),
                  // ],
                ),
              ),

              ///General Progress
              GeneralProgressSection(),
            ],
          );
        }
        if (state is Loading) {
          return Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: CustomShimmerContainer(
                  height: 130.h,
                  width: context.w,
                ),
              ),
              SizedBox(height: 12.h),
              Divider(color: context.color.outline, thickness: 1.0),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 16.w),
                child: CustomShimmerContainer(
                  height: context.h * 0.3,
                  width: context.w,
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 16.w),
                child: CustomShimmerContainer(
                  height: context.h * 0.3,
                  width: context.w,
                ),
              ),
            ],
          );
        } else {
          return const SizedBox();
        }
      },
    );
  }
}
