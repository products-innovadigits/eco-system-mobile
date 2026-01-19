import 'package:pms_system/core/utility/pms_exports.dart';
import 'package:pms_system/features/workflow_process_details/bloc/process_details/process_details_bloc.dart';
import 'package:pms_system/features/workflow_process_details/bloc/process_details/process_details_events.dart';
import 'package:pms_system/features/workflow_process_details/bloc/stage_docs/stage_docs_bloc.dart';
import 'package:pms_system/features/workflow_process_details/bloc/stage_docs/stage_docs_events.dart';
import 'package:pms_system/features/workflow_process_details/widgets/process_details_body.dart';

import '../bloc/process_details/process_details_state.dart';

class WorkflowProcessDetailsView extends StatelessWidget {
  const WorkflowProcessDetailsView({
    super.key,
    required this.processId,
    required this.projectId,
    required this.processName,
  });

  final int processId;
  final int projectId;
  final String processName;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        return ProcessDetailsBloc()
          ..add(LoadProcessDetails(processId: processId, projectId: projectId));
      },
      child: Scaffold(
        appBar: CustomAppBar(
          title: processName,
          withBottomBorder: false,
          action: BlocConsumer<ProcessDetailsBloc, ProcessDetailsState>(
            listener: (context, state) {
              if (state is ProcessStarted) {
                final bloc = context.read<ProcessDetailsBloc>();
                // Reload process details after starting
                context.read<StageDocsBloc>().add(
                  CreateCurrentStepDocs(
                    processId: processId,
                    projectId: projectId,
                    projectStepId: bloc.stageDocsData?.currentStep?.id ?? 0,
                  ),
                );
              }
            },
            builder: (context, state) {
              final bloc = context.read<ProcessDetailsBloc>();
              // Only show button if data is loaded
              if (state is ProcessDetailsLoaded &&
                  bloc.stageDocsData?.workFlowStatus != null) {
                final workflowStatus = bloc.stageDocsData?.workFlowStatus;
                final isStart = workflowStatus == 'NotStarted';

                return InkWell(
                  onTap: isStart && state is! ProcessStarting
                      ? () {
                          YesNoDialogHelper.showStartProcessConfirmationDialog(
                            context: context,
                            onStartPressed: () {
                              bloc.add(
                                StartProcess(
                                  processId: processId,
                                  projectId: projectId,
                                ),
                              );
                            },
                          );
                        }
                      : null,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: getStatusColor(
                        workflowStatus!,
                      ).withValues(alpha: isStart ? null : 0.1),
                      borderRadius: BorderRadius.circular(isStart ? 8 : 25),
                      border: Border.all(
                        color: isStart
                            ? context.color.primary
                            : Colors.transparent,
                        width: 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        Text(
                          getStatusName(workflowStatus),
                          style: context.textTheme.bodySmall?.copyWith(
                            color: isStart
                                ? context.color.primary
                                : getStatusColor(workflowStatus),
                            fontSize: FontSizes.f10,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }

              // Return empty widget while loading
              return const SizedBox.shrink();
            },
          ),
        ),
        body: SafeArea(
          child: ProcessDetailsBody(projectId: projectId, processId: processId),
        ),
      ),
    );
  }
}

Color getStatusColor(String workflowStatus) => switch (workflowStatus) {
  'NotStarted' => Colors.transparent,
  'InProgress' => LightColor.secondary,
  _ => LightColor.tertiary,
};

String getStatusName(String workflowStatus) => switch (workflowStatus) {
  'NotStarted' => allTranslations.text(LocaleKeys.start_process),
  'InProgress' => allTranslations.text(LocaleKeys.in_progress),
  _ => allTranslations.text(LocaleKeys.done),
};

// buildWhen: (previous, current) =>
//     (previous is! WorkflowProcessDetailsLoaded &&
//         current is WorkflowProcessDetailsLoaded) ||
//     (previous is WorkflowProcessDetailsLoaded &&
//         current is WorkflowProcessDetailsLoading) ||
//     (previous is WorkflowProcessDetailsLoading &&
//         current is WorkflowProcessDetailsLoaded),
