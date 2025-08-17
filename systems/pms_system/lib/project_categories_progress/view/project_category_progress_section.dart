import 'package:pms_system/shared/pms_exports.dart';

class ProjectCategoryProgressSection extends StatelessWidget {
  final bool isPmsHome;

  const ProjectCategoryProgressSection({super.key, this.isPmsHome = false});

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
          if (state is Loading || state is Start) {
            return _buildLoadingShimmer(context);
          } else if (state is Done) {
            List<ProjectCategoriesProgressModel> projectCategoriesProgress =
                state.list as List<ProjectCategoriesProgressModel>;
            return _buildCategoriesChart(
                context, projectCategoriesProgress, isPmsHome);
          } else if (state is Empty) {
            return const EmptyContainer();
          } else {
            return MainCardWidget(
                title: allTranslations
                    .text(LocaleKeys.project_progress_rate_in_each_category),
                child: TryAgainWidget(
                  onTryAgain: () {
                    context.read<ProjectCategoriesProgressBloc>().add(
                          Click(),
                        );
                  },
                ));
          }
        },
      ),
    );
  }
}

Widget _buildLoadingShimmer(BuildContext context) {
  return Padding(
    padding: EdgeInsets.symmetric(vertical: 12.h),
    child: CustomShimmerContainer(
      height: context.h * 0.2,
      width: context.w,
    ),
  );
}

Widget _buildCategoriesChart(
    BuildContext context,
    List<ProjectCategoriesProgressModel> projectCategoriesProgress,
    bool isPmsHome) {
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
              .text(LocaleKeys.project_progress_rate_in_each_category),
          withView: false,
        ),
        Divider(color: context.color.outline),
        SizedBox(
          height: isPmsHome ? projectCategoriesProgress.length * 30.h : 250.h,
          child: SingleChildScrollView(
            child: SizedBox(
              height:
                  isPmsHome ? projectCategoriesProgress.length * 60.h : 250.h,
              child: ProjectCategoriesChart(
                data: projectCategoriesProgress,
                isPmsHome: isPmsHome,
              ),
            ),
          ),
        ),
      ],
    ),
  );
}
