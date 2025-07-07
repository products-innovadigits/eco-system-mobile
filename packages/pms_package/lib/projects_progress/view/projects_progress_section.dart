import 'package:core_package/core/utility/export.dart';

import '../bloc/projects_progress_bloc.dart';
import '../model/project_progress_model.dart';
import '../widgets/projects_progress_chart.dart';

class ProjectsProgressSection extends StatelessWidget {
  const ProjectsProgressSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProjectsProgressBloc()..add(Click()),
      child: BlocBuilder<ProjectsProgressBloc, AppState>(
        builder: (context, state) {
          if (state is Done) {
            List<ProjectProgressModel> projects =
                state.list as List<ProjectProgressModel>;
            return Container(
              width: context.w,
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
              decoration: BoxDecoration(
                  color: Styles.WHITE_COLOR,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: Styles.LIGHT_GREY_BORDER)),
              child: Column(
                children: [
                  SectionTitle(
                    title: allTranslations.text("project_progress_rate"),
                    withView: true,
                    onViewTap: () => CustomNavigator.push(Routes.PROJECTS),
                  ),
                  Divider(color: Styles.BORDER_COLOR),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          allTranslations.text("total_projects"),
                          style: context.textTheme.labelSmall,
                        ),
                      ),
                      Text(
                        "100",
                        style: AppTextStyles.w600.copyWith(
                          fontSize: 20,
                          color: Color(0xff2B6C9F),
                        ),
                      )
                    ],
                  ),
                  ProjectsProgressChart(projects: projects),
                  SizedBox(height: 12.h),
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
                                  size: 16,
                                ),
                                SizedBox(width: 4.w),
                                Flexible(
                                  child: RichText(
                                    textAlign: TextAlign.center,
                                    text: TextSpan(
                                      text: projects[i].categoryName,
                                      style: AppTextStyles.w400.copyWith(
                                          fontSize: 14, color: Styles.HEADER),
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
                  )
                ],
              ),
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
