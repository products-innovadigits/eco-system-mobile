import 'package:pms_system/project_details/bloc/project_details/project_details_bloc.dart';
import 'package:pms_system/project_details/bloc/project_details/project_details_state.dart';
import 'package:pms_system/project_details/widgets/tabs/project_details_tabs_section.dart';
import 'package:pms_system/project_details/widgets/tabs/project_main_info_tab.dart';
import 'package:pms_system/project_details/widgets/tabs/timeline_tab/project_timeline_tab.dart';
import 'package:pms_system/project_details/widgets/tabs/workflow_tab/project_workflow_tab.dart';
import 'package:pms_system/shared/pms_exports.dart';
import 'package:pms_system/shared/widgets/shimmer/custom_details_shimmer_loading.dart';

class ProjectDetailsBody extends StatelessWidget {
  const ProjectDetailsBody({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProjectDetailsBloc, ProjectDetailsState>(
      buildWhen: (previous, current) =>
          current is! ProjectTimelineLoading &&
          current is! ProjectTimelineLoaded &&
          current is! ProjectTimelineFailure,
      builder: (context, state) {
        final selectedTab = context.select(
          (ProjectDetailsBloc bloc) => bloc.selectedTab,
        );
        return switch (state) {
          // ── Loading ─────────────────────────
          ProjectDetailsLoading() => const CustomDetailsShimmerLoading(),

          // ── Done ────────────────────────────
          ProjectDetailsLoaded(:final projectDetails) => _ProjectBody(
                model: projectDetails,
                selectedTab: selectedTab,
              ),

          // ── Error / fallback ────────────────
          _ => const ErrorContainer(),
        };
      },
    );
  }
}

class _ProjectBody extends StatelessWidget {
  final ProjectDetailsModel model;
  final ProjectDetailsEnum selectedTab;

  const _ProjectBody({required this.model, required this.selectedTab});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Fixed header content
        ProjectCardContent(project: model, isDetails: true),
        SizedBox(height: 12.h),
        ProjectDetailsTabsSection(projectId: model.id ?? 0),
        SizedBox(height: 16.h),
        Expanded(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: _getTabSection(selectedTab, model),
          ),
        ),
      ],
    );
  }
}

Widget _getTabSection(
  ProjectDetailsEnum selectedTab,
  ProjectDetailsModel model,
) {
  return switch (selectedTab) {
    ProjectDetailsEnum.mainInfo => ProjectMainInfoTab(
      projectDetailsModel: model,
    ),
    ProjectDetailsEnum.workflow => ProjectWorkflowTab(
      projectDetailsModel: model,
    ),
    _ => ProjectTimelineTab(
      projectStart: model.startDate ?? DateTime.now(),
      projectEnd:
          model.endDate ?? DateTime.now().add(const Duration(days: 365)),
    ),
  };
}
