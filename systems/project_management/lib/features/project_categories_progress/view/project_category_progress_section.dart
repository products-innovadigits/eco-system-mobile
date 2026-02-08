import 'package:project_management/core/di/project_management_locator.dart';
import 'package:project_management/core/utility/project_management_exports.dart';

class ProjectCategoryProgressSection extends StatelessWidget {
  final bool isProjectManagementHome;

  const ProjectCategoryProgressSection({
    super.key,
    this.isProjectManagementHome = false,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          ProjectCategoriesProgressCubit(repo: projectManagementSl())
            ..loadCategoriesProgress(),
      child:
          BlocBuilder<
            ProjectCategoriesProgressCubit,
            ProjectCategoriesProgressState
          >(
            builder: (context, state) {
              return switch (state) {
                // ── Loading ─────────────────────────
                ProjectCategoriesProgressLoading() =>
                  const CustomShimmerContainer(),

                // ── Loaded ────────────────────────────
                ProjectCategoriesProgressLoaded(:final categories) =>
                  _CategoriesChart(
                    data: categories,
                    isProjectManagementHome: isProjectManagementHome,
                  ),

                // ── Empty ───────────────────────────
                ProjectCategoriesProgressEmpty() => const EmptyContainer(),

                // ── Error / fallback ────────────────
                _ => MainCardWidget(
                  title: allTranslations.text(
                    LocaleKeys.project_progress_rate_in_each_category,
                  ),
                  moreBtnTxt: allTranslations.text(LocaleKeys.view_projects),
                  child: TryAgainWidget(
                    onTryAgain: () {
                      context
                          .read<ProjectCategoriesProgressCubit>()
                          .loadCategoriesProgress();
                    },
                  ),
                ),
              };
            },
          ),
    );
  }
}

class _CategoriesChart extends StatelessWidget {
  final List<ProjectCategoriesProgressModel> data;
  final bool isProjectManagementHome;

  const _CategoriesChart({
    required this.data,
    required this.isProjectManagementHome,
  });

  @override
  Widget build(BuildContext context) {
    return MainCardWidget(
      title: allTranslations.text(
        LocaleKeys.project_progress_rate_in_each_category,
      ),
      moreBtnTxt: isProjectManagementHome
          ? allTranslations.text(LocaleKeys.view_projects)
          : null,
      onViewMoreTap: () {
        if (!isProjectManagementHome) {
          UserBloc.currentActiveSystem = ActiveSystemEnum.projectManagement;
        }
        isProjectManagementHome
            ? CustomNavigator.push(Routes.PROJECTS)
            : CustomNavigator.push(
                Routes.SYSTEM_SWITCHER,
                arguments: ActiveSystemEnum.projectManagement,
              );
      },
      // child: SizedBox(
      //   height: isProjectManagementHome ? data.length * 18.h : 250.h,
      //   child: SingleChildScrollView(
      //     child: SizedBox(
      //       height: isProjectManagementHome ? data.length * 50.h : 250.h,
      //       child: ProjectCategoriesChart(data: data, isProjectManagementHome: isProjectManagementHome),
      //     ),
      //   ),
      // ),
      child: CustomBarChart(data: data, showAll: isProjectManagementHome),
    );
  }
}
