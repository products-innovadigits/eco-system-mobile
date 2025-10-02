import 'package:pms_system/project_details/widgets/tabs/project_main_info_tab.dart';
import 'package:pms_system/project_details/widgets/tabs/project_workflow_tab.dart';
import 'package:pms_system/shared/pms_exports.dart';
import 'package:pms_system/workflow_process_details/bloc/workflow_process_details_bloc.dart';
import 'package:pms_system/workflow_process_details/widgets/process_header_card.dart';
import 'package:pms_system/workflow_process_details/widgets/tabs/process_details_tabs_section.dart';

class ProcessDetailsBody extends StatelessWidget {
  const ProcessDetailsBody({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WorkflowProcessDetailsBloc, AppState>(
      builder: (context, state) {
        final selectedTab = context.select(
          (WorkflowProcessDetailsBloc bloc) => bloc.selectedTab,
        );
        return switch (state) {
          // ── Loading ─────────────────────────
          Loading() => _buildShimmerLoading(context),

          // ── Done ────────────────────────────
          Done(:final ProjectDetailsModel model) => _ProcessBody(
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

class _ProcessBody extends StatelessWidget {
  final ProjectDetailsModel model;
  final ProcessTabsEnum selectedTab;

  const _ProcessBody({required this.model, required this.selectedTab});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Fixed header content
        ProcessHeaderCard(project: model, isDetails: true),
        SizedBox(height: 12.h),
        ProcessDetailsTabsSection(),
        SizedBox(height: 16.h),
        // Expanded(
        //   child: SingleChildScrollView(
        //     child: Column(
        //       mainAxisSize: MainAxisSize.min,
        //       children: [
        //         // Scrollable content
        //         Flexible(
        //           fit: FlexFit.loose,
        //           child: SingleChildScrollView(
        //             padding: EdgeInsets.symmetric(horizontal: 16.w),
        //             child: _getTabSection(selectedTab, model),
        //           ),
        //         ),
        //       ],
        //     ),
        //   ),
        // ),
      ],
    );
  }
}

Widget _buildShimmerLoading(BuildContext context) => Padding(
  padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 16.w),
  child: Column(
    children: [
      CustomShimmerContainer(height: 130.h),
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Divider(color: context.color.outline, thickness: 1.0),
      ),
      CustomShimmerContainer(height: context.h * 0.3, width: context.w),
      CustomShimmerContainer(height: context.h * 0.3, width: context.w),
    ],
  ),
);

Widget _getTabSection(
  ProcessTabsEnum selectedTab,
  ProjectDetailsModel model,
) {
  return switch (selectedTab) {
    ProcessTabsEnum.followProcess => ProjectMainInfoTab(model: model),
    ProcessTabsEnum.stageDocs => ProjectWorkflowTab(
      stagesList: model.projectLifeCycle?.projectStages ?? [],
    ),
    _ => Container(),
  };
}
