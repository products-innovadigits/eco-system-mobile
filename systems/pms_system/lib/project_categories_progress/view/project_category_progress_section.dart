import 'package:pms_system/project_categories_progress/bloc/project_categories_progress_cubit.dart';
import 'package:pms_system/project_categories_progress/bloc/project_categories_progress_state.dart';
import 'package:pms_system/shared/pms_exports.dart';

class ProjectCategoryProgressSection extends StatelessWidget {
  final bool isPmsHome;

  const ProjectCategoryProgressSection({super.key, this.isPmsHome = false});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          ProjectCategoriesProgressCubit()..loadCategoriesProgress(),
      child: BlocBuilder<ProjectCategoriesProgressCubit,
          ProjectCategoriesProgressState>(
        builder: (context, state) {
          return switch (state) {
            // ── Loading ─────────────────────────
            ProjectCategoriesProgressLoading() => const CustomShimmerContainer(),

            // ── Loaded ────────────────────────────
            ProjectCategoriesProgressLoaded(:final categories) =>
              _CategoriesChart(
                data: categories,
                isPmsHome: isPmsHome,
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
  final bool isPmsHome;

  const _CategoriesChart({required this.data, required this.isPmsHome});

  @override
  Widget build(BuildContext context) {
    return MainCardWidget(
      title: allTranslations.text(
        LocaleKeys.project_progress_rate_in_each_category,
      ),
      moreBtnTxt: isPmsHome
          ? allTranslations.text(LocaleKeys.view_projects)
          : null,
      onViewMoreTap: () {
        if (!isPmsHome) {
          UserBloc.currentActiveSystem = ActiveSystemEnum.pms;
        }
        isPmsHome
            ? CustomNavigator.push(Routes.PROJECTS)
            : CustomNavigator.push(
                Routes.SYSTEM_SWITCHER,
                arguments: ActiveSystemEnum.pms,
              );
      },
      // child: SizedBox(
      //   height: isPmsHome ? data.length * 18.h : 250.h,
      //   child: SingleChildScrollView(
      //     child: SizedBox(
      //       height: isPmsHome ? data.length * 50.h : 250.h,
      //       child: ProjectCategoriesChart(data: data, isPmsHome: isPmsHome),
      //     ),
      //   ),
      // ),
      child: CustomBarChart(data: data, showAll: isPmsHome),
    );
  }
}
