import 'package:core_system/core/components/custom_screen_type_layout_widget.dart';
import 'package:project_management/core/di/project_management_locator.dart';
import 'package:project_management/features/projects_progress/widgets/project_progress_mobile_landscape.dart';
import 'package:project_management/features/projects_progress/widgets/project_progress_mobile_portrait.dart';

import '../../../core/utility/project_management_exports.dart';

class ProjectProgressSection extends StatelessWidget {
  final bool isProjectManagementHome;

  const ProjectProgressSection(
      {super.key, required this.isProjectManagementHome});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          ProjectsProgressCubit(repo: projectManagementSl())
            ..loadProjectsProgress(),
      child: BlocBuilder<ProjectsProgressCubit, ProjectsProgressState>(
        builder: (context, state) {
          return switch (state) {
            // ── Loading ─────────────────────────
            ProjectsProgressLoading() => const CustomShimmerContainer(),

            // ── Loaded ────────────────────────────
            ProjectsProgressLoaded(:final projects) => _ProjectProgressSection(
              isProjectManagementHome: isProjectManagementHome,
              data: projects,
            ),

            // ── Empty ───────────────────────────
            ProjectsProgressEmpty() => const EmptyContainer(),

            // ── Default (error/unknown) ─────────
            _ => MainCardWidget(
              title: allTranslations.text(LocaleKeys.project_progress_rate),
              moreBtnTxt: isProjectManagementHome
                  ? allTranslations.text(LocaleKeys.view_projects)
                  : null,
              child: TryAgainWidget(
                onTryAgain: () {
                  context.read<ProjectsProgressCubit>().loadProjectsProgress();
                },
              ),
            ),
          };
        },
      ),
    );
  }
}

class _ProjectProgressSection extends StatelessWidget {
  final bool isProjectManagementHome;
  final List<ProjectsOverviewData> data;

  const _ProjectProgressSection(
      {required this.isProjectManagementHome, required this.data});

  @override
  Widget build(BuildContext context) {
    return CustomScreenTypeLayoutWidget(
      mobilePortrait: (ctx) =>
          ProjectProgressMobilePortrait(
          isProjectManagementHome: isProjectManagementHome, data: data),
      mobileLandscape: (ctx) => ProjectProgressMobileLandscape(
          isProjectManagementHome: isProjectManagementHome, data: data),
    );
  }
}
