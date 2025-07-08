
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
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: ProjectCardContent(project: model),
              ),
              SizedBox(height: 12.h),
              Divider(color: context.color.outline, thickness: 1.0),

              ///Project Description
              CustomExpansionCard(
                title: allTranslations.text("description"),
                child: ProjectDetailsDescription(
                  model: model,
                ),
              ),

              ///Progress at each stage of the project
              CustomExpansionCard(
                title: allTranslations
                    .text("progress_at_each_stage_of_the_project"),
                withExpanded: false,
                child: ProjectCategoryHBarChart(
                    barColor: Styles.PRIMARY_COLOR,
                    textColor: Styles.DETAILS,
                    withIntervals: false,
                    data: model.projectLifeCycle?.projectStages
                            ?.map((e) => ProjectCategoriesProgressModel(
                                name: e.title ?? "", progress: e.progress ?? 0))
                            .toList() ??
                        []),
              ),

              ///General Progress
              CustomExpansionCard(
                title: allTranslations.text("general_progress"),
                withExpanded: false,
                action: Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 24.w, vertical: 6.h),
                  margin: EdgeInsets.symmetric(horizontal: 6.w),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    color: Styles.WHITE_COLOR,
                    border: Border.all(color: context.color.outline),
                  ),
                  child: Center(
                    child: Text(
                      allTranslations.text("Month"),
                      style: AppTextStyles.w600.copyWith(
                        fontSize: 14,
                        height: 1.2,
                        color: Styles.HEADER,
                      ),
                    ),
                  ),
                ),
                child: ProjectMonthlyProgress(
                  data: [
                    ProjectCategoriesProgressModel(name: "xxx", progress: 20),
                    ProjectCategoriesProgressModel(name: "yyy", progress: 10),
                    ProjectCategoriesProgressModel(name: "yyy", progress: 40),
                    ProjectCategoriesProgressModel(name: "yyy", progress: 70),
                    ProjectCategoriesProgressModel(name: "zzz", progress: 80),
                  ],
                ),
              ),
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
