import 'package:project_management/core/di/project_management_locator.dart';
import 'package:project_management/core/utility/pms_exports.dart';

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
        return ProcessDetailsBloc(repo: projectManagementSl())
          ..add(LoadGroupSteps(processId: processId, projectId: projectId));
      },
      child: Scaffold(
        appBar: CustomAppBar(
          title: processName,
          withBottomBorder: false,
          action: BlocBuilder<ProcessDetailsBloc, ProcessDetailsState>(
            builder: (context, state) {
              final bloc = context.read<ProcessDetailsBloc>();
              final workflowStatus = bloc.stageDocsData?.workFlowStatus;

              // Show button if data is loaded OR in start process flow
              if (workflowStatus != null &&
                  (state is GroupStepsLoaded ||
                      state is ProcessStarted ||
                      state is ProcessStarting)) {
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
                      color: getWorkflowStatusColor(
                        workflowStatus,
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
                          getWorkflowStatusName(workflowStatus),
                          style: context.textTheme.bodySmall?.copyWith(
                            color: isStart
                                ? context.color.primary
                                : getWorkflowStatusColor(workflowStatus),
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

Color getWorkflowStatusColor(String workflowStatus) => switch (workflowStatus) {
  'NotStarted' => Colors.transparent,
  'InProgress' => LightColor.secondary,
  _ => LightColor.tertiary,
};

String getWorkflowStatusName(String workflowStatus) => switch (workflowStatus) {
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
