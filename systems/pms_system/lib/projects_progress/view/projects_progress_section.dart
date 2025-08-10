import 'package:core_system/core/utility/export.dart';
import 'package:core_system/core/widgets/main_card_widget.dart';
import 'package:pms_system/project_categories_progress/model/projects_progress_model.dart';
import 'package:pms_system/project_categories_progress/view/project_category_progress_section.dart';
import 'package:pms_system/projects_progress/widgets/half_circle_analatic_chart.dart';

import '../bloc/projects_progress_bloc.dart';

class ProjectsProgressSection extends StatelessWidget {
  final bool isPmsHome;

  const ProjectsProgressSection({super.key, this.isPmsHome = false});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProjectsProgressBloc()..add(Click()),
      child: BlocBuilder<ProjectsProgressBloc, AppState>(
        builder: (context, state) {
          if (state is Loading || state is Start) {
            return Padding(
              padding: EdgeInsets.symmetric(vertical: 12.h),
              child: CustomShimmerContainer(
                height: context.h * 0.2,
                width: context.w,
              ),
            );
          } else if (state is Done) {
            List<ProjectsOverviewData> projects = state.data ?? [];
            return Stack(
              children: [
                Column(
                  children: [
                    MainCardWidget(
                        height: 260.h,
                        title: allTranslations
                            .text(LocaleKeys.project_progress_rate),
                        onViewMoreTap: () => CustomNavigator.push(
                            isPmsHome ? Routes.PROJECTS : Routes.PMS_LAYOUT),
                        child: _chartDetails(context, projects)),
                    16.sh,
                    ProjectCategoryProgressSection(isPmsHome: isPmsHome),
                  ],
                ),
                _buildChart(context, projects),
              ],
            );
          } else if (state is Empty) {
            return EmptyContainer();
          } else {
            return EmptyContainer(
                txt: allTranslations.text(LocaleKeys.something_went_wrong),
                img: Assets.svgs.error.path);
          }
        },
      ),
    );
  }
}

Widget _chartDetails(
    BuildContext context, List<ProjectsOverviewData> projects) {
  return Wrap(
    alignment: WrapAlignment.start,
    direction: Axis.horizontal,
    runSpacing: 8.w,
    spacing: 24.h,
    children: List.generate(projects.length, (i) {
      final Color categoryColor = Color(int.parse(
          projects[i].hexColor?.replaceAll('#', '0xff') ?? '0xff000000'));
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.circle,
            color: categoryColor,
            size: 14,
          ),
          SizedBox(width: 4.w),
          Flexible(
            child: RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                text: projects[i].name,
                style: context.textTheme.bodyMedium,
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
          SizedBox(width: 4.w),
          Text(
            '(${projects[i].count.toString()})',
            style: context.textTheme.bodyMedium?.copyWith(
              color: context.color.outlineVariant,
            ),
          ),
        ],
      );
    }),
  );
}

Widget _buildChart(BuildContext context, List<ProjectsOverviewData> projects) {
  final int totalProjects =
      projects.fold(0, (sum, item) => sum + (item.count ?? 0).toInt());
  return Positioned(
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
                  allTranslations.text(LocaleKeys.total_projects),
                  style: context.textTheme.labelSmall,
                ),
                Text(
                  totalProjects.toString(),
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
  );
}
