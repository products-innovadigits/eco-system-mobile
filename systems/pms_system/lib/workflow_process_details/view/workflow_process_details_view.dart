import 'package:pms_system/shared/pms_exports.dart';
import 'package:pms_system/workflow_process_details/widgets/process_details_body.dart';

class WorkflowProcessDetailsView extends StatelessWidget {
  const WorkflowProcessDetailsView({
    super.key,
    required this.processId,
    required this.projectId,
    required this.processName,
    required this.projectName,
    required this.stageName,
    required this.projectStartDate,
    required this.projectEndDate,
    required this.projectManagerName,
    required this.projectBudget,
  });

  final int processId;
  final int projectId;
  final String processName;
  final String projectName;
  final String stageName;
  final String projectManagerName;
  final double projectBudget;
  final DateTime? projectStartDate;
  final DateTime? projectEndDate;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => WorkflowProcessDetailsBloc()
        ..add(
          Click(arguments: {'processId': processId, 'projectId': projectId}),
        ),
      child: Scaffold(
        appBar: CustomAppBar(
          title: processName,
          withBottomBorder: false,
          action: BlocBuilder<WorkflowProcessDetailsBloc, AppState>(
            buildWhen: (previous, current) =>
                (previous is! Done && current is Done) ||
                (previous is Done && current is Loading) ||
                (previous is Loading && current is Done),
            builder: (context, state) {
              final bloc = context.read<WorkflowProcessDetailsBloc>();
              // Only show button if data is loaded
              if (state is Done && bloc.stageDocsData?.workFlowStatus != null) {
                final workflowStatus = bloc.stageDocsData?.workFlowStatus;
                final isStart = workflowStatus == 'NotStarted';

                return InkWell(
                  onTap: isStart && state is! Loading
                      ? () {
                          YesNoDialogHelper.showStartProcessConfirmationDialog(
                            context: context,
                            onStartPressed: () {
                              bloc.add(
                                Get(
                                  arguments: {
                                    'processId': processId,
                                    'projectId': projectId,
                                  },
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
          child: ProcessDetailsBody(
            projectDetailsModel: ProjectDetailsModel(
              id: projectId,
              title: projectName,
              managerName: projectManagerName,
              budget: projectBudget,
              startDate: projectStartDate,
              endDate: projectEndDate,
            ),
            processId: processId,
            stageName: stageName,
            processName: processName,
          ),
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
