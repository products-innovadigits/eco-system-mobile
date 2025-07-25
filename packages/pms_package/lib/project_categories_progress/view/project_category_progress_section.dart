
import 'package:pms_package/shared/pms_exports.dart';

class ProjectCategoryProgressSection extends StatelessWidget {
  const ProjectCategoryProgressSection({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => ProjectCategoriesProgressBloc()..add(Click()),
        ),
      ],
      child: BlocBuilder<ProjectCategoriesProgressBloc, AppState>(
        builder: (context, state) {
          if (state is Done) {
            List<ProjectCategoriesProgressModel> projectCategoriesProgress =
                state.list as List<ProjectCategoriesProgressModel>;
            return Container(
              width: context.w,
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
              decoration: BoxDecoration(
                  color: context.color.surfaceContainer,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: context.color.outline)),
              child: Column(
                children: [
                  SectionTitle(
                    title: allTranslations
                        .text("project_progress_rate_in_each_category"),
                    withView: false,
                    onViewTap: () => CustomNavigator.push(Routes.PROJECTS),
                  ),
                  Divider(color: context.color.outline),
                  ProjectCategoryHBarChart(data: projectCategoriesProgress),
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
