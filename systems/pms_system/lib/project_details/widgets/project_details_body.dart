import 'package:pms_system/project_details/widgets/general_progress_section.dart';
import 'package:pms_system/project_details/widgets/project_stages_chart.dart';
import 'package:pms_system/shared/pms_exports.dart';

class ProjectDetailsBody extends StatelessWidget {
  const ProjectDetailsBody({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProjectDetailsBloc, AppState>(
      builder: (context, state) {
        return switch (state) {
          // ── Loading ─────────────────────────
          Loading() => _buildShimmerLoading(context),

          // ── Done ────────────────────────────
          Done(:final ProjectDetailsModel model) => _ProjectBody(model: model),

          // ── Empty ───────────────────────────
          Empty() => const EmptyContainer(),

          // ── Error / fallback ────────────────
          _ => EmptyContainer(
            txt: allTranslations.text(LocaleKeys.something_went_wrong),
            img: Assets.svgs.error.path,
          ),
        };
      },
    );
  }
}

class _ProjectBody extends StatelessWidget {
  final ProjectDetailsModel model;

  const _ProjectBody({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ProjectCardContent(project: model, isDetails: true),
        SizedBox(height: 12.h),

        ///Project Description
        CustomExpansionCard(
          title: allTranslations.text(LocaleKeys.main_data),
          child: ProjectDetailsDescription(model: model),
        ),

        CustomExpansionCard(
          title: allTranslations.text(LocaleKeys.challenges_risks),
          child: ProjectsChallengesRisks(),
        ),

        ///Progress at each stage of the project
        CustomExpansionCard(
          title: allTranslations.text("progress_at_each_stage_of_the_project"),
          child: ProjectStagesChart(
            barColor: context.color.primary,
            textColor: context.color.outlineVariant,
            withIntervals: false,
            data:
                model.projectLifeCycle?.projectStages
                    ?.map(
                      (e) => ProjectCategoriesProgressModel(
                        name: e.title ?? "",
                        progress: e.progress ?? 0,
                      ),
                    )
                    .toList() ??
                [],
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
}

Widget _buildShimmerLoading(BuildContext context) => Column(
  children: [
    CustomShimmerContainer(
      height: 130.h,
      padding: EdgeInsets.symmetric(horizontal: 16.h),
    ),
    SizedBox(height: 12.h),
    Divider(color: context.color.outline, thickness: 1.0),
    Padding(
      padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 16.w),
      child: CustomShimmerContainer(height: context.h * 0.3, width: context.w),
    ),
    Padding(
      padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 16.w),
      child: CustomShimmerContainer(height: context.h * 0.3, width: context.w),
    ),
  ],
);
