import 'package:pms_system/core/utility/pms_exports.dart';
import 'package:pms_system/features/workflow_process_details/bloc/workflow_process_details/workflow_process_details_bloc.dart';
import 'package:pms_system/features/workflow_process_details/bloc/workflow_process_details/workflow_process_details_state.dart';
import 'package:pms_system/features/workflow_process_details/model/stage_doc_model.dart';
import 'package:pms_system/features/workflow_process_details/model/workflow_process_details_model.dart';
import 'package:pms_system/features/workflow_process_details/widgets/process_header_card.dart';
import 'package:pms_system/features/workflow_process_details/widgets/tabs/actions_tab/actions_tab.dart';
import 'package:pms_system/features/workflow_process_details/widgets/tabs/follow_process_tab/follow_process_tab.dart';
import 'package:pms_system/features/workflow_process_details/widgets/tabs/process_details_tabs_section.dart';
import 'package:pms_system/features/workflow_process_details/widgets/tabs/stage_docs_tab/stage_docs_tab.dart';
import 'package:pms_system/features/workflow_process_details/widgets/tabs/technical_log_tab/technical_log_tab.dart';
import 'package:pms_system/shared/widgets/shimmer/custom_details_shimmer_loading.dart';

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
        BlocBuilder<WorkflowProcessDetailsBloc, WorkflowProcessDetailsState>(
          buildWhen: (previous, current) =>
              (previous is WorkflowProcessDetailsLoading) !=
              (current is WorkflowProcessDetailsLoading),
          builder: (context, state) {
            return state is WorkflowProcessDetailsLoading
                ? SizedBox.shrink()
                : ProcessHeaderCard();
          },
        ),
        BlocBuilder<WorkflowProcessDetailsBloc, WorkflowProcessDetailsState>(
          buildWhen: (previous, current) =>
              previous.runtimeType != current.runtimeType ||
              (previous is WorkflowProcessDetailsLoaded &&
                  current is WorkflowProcessDetailsLoaded &&
                  previous.processDetails != current.processDetails),
          builder: (context, state) {
            final selectedTab = context.select(
              (WorkflowProcessDetailsBloc bloc) => bloc.selectedTab,
            );
            return switch (state) {
              // ── Loading ─────────────────────────
              WorkflowProcessDetailsLoading() =>
                const CustomDetailsShimmerLoading(),

              // ── Loaded ────────────────────────────
              WorkflowProcessDetailsLoaded(:final processDetails) =>
                _buildProcessBody(
                  context: context,
                  model: processDetails,
                  selectedTab: selectedTab,
                  processId: processId,
                  projectId: projectId,
                ),

              // ── Empty ───────────────────────────
              WorkflowProcessDetailsEmpty() => const EmptyContainer(),

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
    final workflowProcessDetailsBloc = context
        .read<WorkflowProcessDetailsBloc>();
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
  required WorkflowProcessDetailsModel model,
  required ProcessTabsEnum selectedTab,
  required int processId,
  required int projectId,
}) {
  final workflowProcessDetailsBloc = context.read<WorkflowProcessDetailsBloc>();
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
  required List<WorkflowProcessGroupModel> processList,
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
