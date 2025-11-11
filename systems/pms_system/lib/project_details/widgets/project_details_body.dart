import 'dart:developer';

import 'package:pms_system/project_details/model/timeline_project_model.dart';
import 'package:pms_system/project_details/widgets/tabs/timeline_tab/project_timeline_tab.dart';
import 'package:pms_system/project_details/widgets/tabs/timeline_tab/timeline_widget.dart';
import 'package:pms_system/project_details/widgets/tabs/project_details_tabs_section.dart';
import 'package:pms_system/project_details/widgets/tabs/project_main_info_tab.dart';
import 'package:pms_system/project_details/widgets/tabs/workflow_tab/project_workflow_tab.dart';
import 'package:pms_system/shared/pms_exports.dart';

class ProjectDetailsBody extends StatelessWidget {
  const ProjectDetailsBody({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProjectDetailsBloc, AppState>(
      buildWhen: (previous, current) =>
          current is! Getting &&
          current is! GettingDone &&
          current is! GettingError,
      builder: (context, state) {
        final selectedTab = context.select(
          (ProjectDetailsBloc bloc) => bloc.selectedTab,
        );
        return switch (state) {
          // ── Loading ─────────────────────────
          Loading() => _buildShimmerLoading(context),

          // ── Done ────────────────────────────
          Done(:final ProjectDetailsModel model) => _ProjectBody(
            model: model,
            selectedTab: selectedTab,
          ),

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

Widget _buildShimmerLoading(BuildContext context) => Padding(
  padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 16.w),
  child: Column(
    children: [
      CustomShimmerContainer(height: 120.h),
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Divider(color: context.color.outline, thickness: 1.0),
      ),
      CustomShimmerContainer(height: context.h * 0.3, width: context.w),
      SizedBox(height: 8),
      CustomShimmerContainer(height: context.h * 0.3, width: context.w),
    ],
  ),
);

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
