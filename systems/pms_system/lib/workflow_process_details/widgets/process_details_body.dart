import 'package:pms_system/shared/pms_exports.dart';

class ProcessDetailsBody extends StatelessWidget {
  final ProjectDetailsModel projectDetailsModel;
  final int processId;
  final String stageName;
  final String processName;

  const ProcessDetailsBody({
    super.key,
    required this.projectDetailsModel,
    required this.processId,
    required this.stageName, required this.processName,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Fixed header content
        BlocBuilder<WorkflowProcessDetailsBloc, AppState>(
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
              Done(:final WorkflowProcessDetailsModel model) =>
                _buildProcessBody(
                  context: context,
                  model: model,
                  selectedTab: selectedTab,
                  processId: processId,
                  projectDetailsModel: projectDetailsModel,
                  stageName: stageName,
                  processName: processName,
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
  final int projectStepId;
  final String stageName;
  final String processName;


  const _ProcessBody({
    required this.processList,
    required this.selectedTab,
    required this.projectDetailsModel,
    required this.processId,
    required this.stageName,
    required this.projectStepId,
    required this.processName
  });

  @override
  Widget build(BuildContext context) {
    final workflowProcessDetailsBloc = context
        .read<WorkflowProcessDetailsBloc>();
    final stageDocsData = workflowProcessDetailsBloc.stageDocsData;
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
                selectedTab: selectedTab,
                projectId: projectDetailsModel.id!,
                processId: processId,
                projectStepId: projectStepId,
                processList: processList,
                pdfFilePath: stageDocsData?.pdfFilePath ?? '',
                stepDocumentId: (stageDocsData?.stepDocumentId ?? 0).toInt(),
                processName: processName,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

Widget _buildProcessBody({
  required BuildContext context,
  required WorkflowProcessDetailsModel model,
  required ProcessTabsEnum selectedTab,
  required int processId,
  required ProjectDetailsModel projectDetailsModel,
  required String stageName,
  required String processName
}) {
  final workflowProcessDetailsBloc = context.read<WorkflowProcessDetailsBloc>();
  final stageDocsData = workflowProcessDetailsBloc.stageDocsData;

  return _ProcessBody(
    processList: model.data ?? [],
    projectDetailsModel: projectDetailsModel,
    selectedTab: selectedTab,
    processId: processId,
    projectStepId: stageDocsData?.currentStep?.id ?? 0,
    stageName: stageName,
    processName: processName,
  );
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

Widget _getTabSection({
  required ProcessTabsEnum selectedTab,
  required List<WorkflowProcessGroupModel> processList,
  required int processId,
  required int projectId,
  required int projectStepId,
  required String pdfFilePath,
  required int stepDocumentId,
  required String processName
}) {
  return switch (selectedTab) {
    ProcessTabsEnum.followProcess => FollowProcessTab(processList: processList),
    // ProcessTabsEnum.stageDocs => Container(),
    ProcessTabsEnum.stageDocs => StageDocsTab(
      projectId: projectId,
      processId: processId,
      pdfFilePath: pdfFilePath,
      processName: processName,
    ),
    // ProcessTabsEnum.fields => FieldsTab(),
    ProcessTabsEnum.history => HistoryTab(
      processId: processId,
      projectId: projectId,
    ),
    _ => ActionsTab(
      processId: processId,
      projectId: projectId,
    ),
  };
}
