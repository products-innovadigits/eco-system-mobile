import 'dart:developer';

import 'package:pms_system/shared/pms_exports.dart';

class ProcessDetailsBody extends StatelessWidget {
  final ProjectDetailsModel projectDetailsModel;
  final int processId;
  final String stageName;

  const ProcessDetailsBody({
    super.key,
    required this.projectDetailsModel,
    required this.processId,
    required this.stageName,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Fixed header content
        BlocBuilder<StageDocsBloc, AppState>(
          builder: (context, state) {
            return state is Loading
                ? Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    child: CustomShimmerContainer(height: 130),
                  )
                : ProcessHeaderCard(
                    project: projectDetailsModel,
                    stageName: stageName,
                  );
          },
        ),
        BlocBuilder<WorkflowProcessDetailsBloc, AppState>(
          builder: (context, state) {
            final selectedTab = context.select(
              (WorkflowProcessDetailsBloc bloc) => bloc.selectedTab,
            );
            return switch (state) {
              // ── Loading ─────────────────────────
              Loading() => _buildShimmerLoading(context),

              // ── Done ────────────────────────────
              Done(:final WorkflowProcessDetailsModel model) => _ProcessBody(
                processList: model.data ?? [],
                projectDetailsModel: projectDetailsModel,
                selectedTab: selectedTab,
                processId: processId,
                stageName: stageName,
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
        ),
      ],
    );
  }
}

class _ProcessBody extends StatelessWidget {
  final List<WorkflowProcessGroupModel> processList;
  final ProjectDetailsModel projectDetailsModel;
  final ProcessTabsEnum selectedTab;
  final int processId;
  final String stageName;

  const _ProcessBody({
    required this.processList,
    required this.selectedTab,
    required this.projectDetailsModel,
    required this.processId,
    required this.stageName,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          SizedBox(height: 12),
          ProcessDetailsTabsSection(),
          SizedBox(height: 16.h),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: _getTabSection(
                selectedTab,
                processList,
                projectDetailsModel.id!,
                processId,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

Widget _buildShimmerLoading(BuildContext context) => Padding(
  padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 16.w),
  child: Column(
    children: [
      // CustomShimmerContainer(height: 120.h),
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
  ProcessTabsEnum selectedTab,
  List<WorkflowProcessGroupModel> processList,
  int processId,
  int projectId,
) {
  return switch (selectedTab) {
    ProcessTabsEnum.followProcess => FollowProcessTab(processList: processList),
    // ProcessTabsEnum.stageDocs => Container(),
    ProcessTabsEnum.stageDocs => StageDocsTab(
      projectId: projectId,
      processId: processId,
    ),
    ProcessTabsEnum.fields => FieldsTab(),
    ProcessTabsEnum.history => HistoryTab(),
    _ => ActionsTab(),
  };
}
