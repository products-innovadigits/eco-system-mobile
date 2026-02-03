import 'package:project_management/core/utility/pms_exports.dart';
import 'package:project_management/shared/widgets/shimmer/custom_details_shimmer_loading.dart';

class ProcessDetailsBody extends StatelessWidget {
  final int projectId;
  final int processId;

  const ProcessDetailsBody({
    super.key,
    required this.projectId,
    required this.processId,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        BlocBuilder<ProcessDetailsBloc, ProcessDetailsState>(
          buildWhen: (previous, current) =>
              (previous is GroupStepsLoading) != (current is GroupStepsLoading),
          builder: (context, state) {
            return (state is GroupStepsLoading || state is ProcessStarting)
                ? SizedBox.shrink()
                : ProcessHeaderCard();
          },
        ),
        BlocBuilder<ProcessDetailsBloc, ProcessDetailsState>(
          buildWhen: (previous, current) =>
              previous.runtimeType != current.runtimeType ||
              (previous is GroupStepsLoaded &&
                  current is GroupStepsLoaded &&
                  previous.processDetails != current.processDetails),
          builder: (context, state) {
            final selectedTab = context.select(
              (ProcessDetailsBloc bloc) => bloc.selectedTab,
            );
            return switch (state) {
              // ── Loading ─────────────────────────
              GroupStepsLoading() ||
              ProcessStarting() => const CustomDetailsShimmerLoading(),

              // ── Loaded ────────────────────────────
              GroupStepsLoaded() || ProcessStarted() => _buildProcessBody(
                context: context,
                model: (state is GroupStepsLoaded)
                    ? state.processDetails
                    : context.read<ProcessDetailsBloc>().getGroupStepsModel ??
                          GroupStepsModel(),
                selectedTab: selectedTab,
                processId: processId,
                projectId: projectId,
              ),

              // ── Empty ───────────────────────────
              GroupStepsEmpty() => const EmptyContainer(),

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
  final List<GroupStepsData> processList;
  final int projectId;
  final ProcessTabsEnum selectedTab;
  final int processId;
  final int projectStepId;

  const _ProcessBody({
    required this.processList,
    required this.selectedTab,
    required this.projectId,
    required this.processId,
    required this.projectStepId,
  });

  @override
  Widget build(BuildContext context) {
    final workflowProcessDetailsBloc = context.read<ProcessDetailsBloc>();
    final stageDocsData = workflowProcessDetailsBloc.stageDocsData;
    return Expanded(
      child: Column(
        children: [
          SizedBox(height: 12.h),
          ProcessDetailsTabsSection(),
          SizedBox(height: 16.h),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: _getTabSection(
                selectedTab: selectedTab,
                projectId: projectId,
                processId: processId,
                projectStepId: projectStepId,
                processList: processList,
                pdfFilePath: stageDocsData?.pdfFilePath ?? '',
                stepDocumentId: (stageDocsData?.stepDocumentId ?? 0).toInt(),
                processName: stageDocsData?.processTitle ?? '',
                documents: stageDocsData?.currentStep?.stepDocuments ?? [],
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
  required GroupStepsModel model,
  required ProcessTabsEnum selectedTab,
  required int processId,
  required int projectId,
}) {
  final workflowProcessDetailsBloc = context.read<ProcessDetailsBloc>();
  final stageDocsData = workflowProcessDetailsBloc.stageDocsData;

  return _ProcessBody(
    processList: model.data ?? [],
    projectId: projectId,
    selectedTab: selectedTab,
    processId: processId,
    projectStepId: stageDocsData?.currentStep?.id ?? 0,
  );
}

Widget _getTabSection({
  required ProcessTabsEnum selectedTab,
  required List<GroupStepsData> processList,
  required int processId,
  required int projectId,
  required int projectStepId,
  required String pdfFilePath,
  required int stepDocumentId,
  required String processName,
  required List<StageDocument> documents,
}) {
  return switch (selectedTab) {
    ProcessTabsEnum.followProcess => FollowProcessTab(processList: processList),
    // ProcessTabsEnum.stageDocs => Container(),
    ProcessTabsEnum.stageDocs => StageDocsTab(
      projectId: projectId,
      processId: processId,
      pdfFilePath: pdfFilePath,
      processName: processName,
      documents: documents,
    ),
    // ProcessTabsEnum.fields => FieldsTab(),
    ProcessTabsEnum.history => TechnicalLogTab(
      processId: processId,
      projectId: projectId,
    ),
    _ => ActionsTab(processId: processId, projectId: projectId),
  };
}
