import 'package:core_package/core/utility/export.dart';
import 'package:pms_package/project_categories_progress/model/projects_progress_model.dart';
import 'package:pms_package/project_categories_progress/view/project_category_progress_section.dart';
import 'package:pms_package/projects_progress/widgets/half_circle_analatic_chart.dart';

import '../bloc/projects_progress_bloc.dart';
import '../model/project_progress_model.dart';

class ProjectsProgressSection extends StatelessWidget {
  const ProjectsProgressSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProjectsProgressBloc()..add(Click()),
      child: BlocBuilder<ProjectsProgressBloc, AppState>(
        builder: (context, state) {
          if (state is Done) {
            ProjectsOverviewData overviewData =
                state.data as ProjectsOverviewData;
            List<ProjectProgressModel> projects = [
              ProjectProgressModel(
                  categoryName: 'مكتمل',
                  color: '#B54708',
                  count: overviewData.completedPercentage!.toInt(),
                  value: overviewData.completedPercentage!.toDouble()),
              ProjectProgressModel(
                  categoryName: 'متقدم',
                  color: '#020F4C',
                  count: overviewData.onTrackPercentage!.toInt(),
                  value: overviewData.onTrackPercentage!.toDouble()),
              ProjectProgressModel(
                  categoryName: 'متأخر',
                  color: '#0C9A84',
                  count: overviewData.delayedPercentage!.toInt(),
                  value: overviewData.delayedPercentage!.toDouble()),
            ];
            return Stack(
              children: [
                Column(
                  children: [
                    Container(
                      width: context.w,
                      height: 280.h,
                      padding: EdgeInsets.symmetric(
                          horizontal: 16.w, vertical: 16.h),
                      decoration: BoxDecoration(
                          color: context.color.surfaceContainer,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: context.color.outline)),
                      child: Column(
                        children: [
                          SectionTitle(
                            title:
                                allTranslations.text("project_progress_rate"),
                            withView: true,
                            onViewTap: () =>
                                CustomNavigator.push(Routes.PROJECTS),
                          ),
                          Divider(color: context.color.outline),
                          16.sh,
                          Wrap(
                            alignment: WrapAlignment.start,
                            direction: Axis.horizontal,
                            runSpacing: 8.w,
                            spacing: 24.h,
                            children: List.generate(
                                projects.length,
                                (i) => Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(
                                          Icons.circle,
                                          color: Styles.statusColors(
                                              projects[i].categoryName ?? ""),
                                          size: 14,
                                        ),
                                        SizedBox(width: 4.w),
                                        Flexible(
                                          child: RichText(
                                            textAlign: TextAlign.center,
                                            text: TextSpan(
                                              text: projects[i].categoryName,
                                              style:
                                                  context.textTheme.bodyMedium,
                                              children: [
                                                // TextSpan(
                                                //   text: " ${78}",
                                                //   style: AppTextStyles.w400.copyWith(
                                                //       fontSize: 12,
                                                //       color: Styles.DETAILS),
                                                // )
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    )),
                          ),
                          // 16.sh,
                          // ProjectsProgressChart(projects: projects),

                          // SizedBox(
                          //   height: 104,
                          //   child: HalfCircleAnalyticChart(projects),
                          // ),
                        ],
                      ),
                    ),
                    16.sh,
                    ProjectCategoryProgressSection(),
                  ],
                ),
                Positioned(
                  top: 120.h,
                  right: 20.w,
                  child: Stack(
                    children: [
                      HalfCircleAnalyticChart(projects),
                      Positioned(
                        top: 100.h,
                        left: 0,
                        right: 0,
                        child: Align(
                          alignment: Alignment.bottomCenter,
                          child: Column(
                            children: [
                              Text(
                                allTranslations.text("total_projects"),
                                style: context.textTheme.labelSmall,
                              ),
                              Text(
                                overviewData.totalProjects.toString(),
                                style: context.textTheme.labelLarge?.copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: context.color.secondary),
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          }
          if (state is Loading) {
            return Padding(
              padding: EdgeInsets.symmetric(vertical: 12.h),
              child: CustomShimmerContainer(
                height: context.h * 0.2,
                width: context.w,
              ),
            );
          } else {
            return SizedBox();
          }
        },
      ),
    );
  }
}
