import 'package:pms_system/shared/pms_exports.dart';
import 'package:pms_system/workflow_process_details/bloc/stage_docs_bloc.dart';
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
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => StageDocsBloc()
            ..add(
              Click(
                // arguments: {'processId': 146, 'projectId': 51},
                arguments: {'processId': processId, 'projectId': projectId},
              ),
            ),
        ),
        BlocProvider(
          create: (context) =>
              WorkflowProcessDetailsBloc(
                stageDocsBloc: context.read<StageDocsBloc>(),
              )..add(
                Click(
                  arguments: {'processId': processId, 'projectId': projectId},
                ),
              ),
          // create: (context) => WorkflowProcessDetailsBloc(),
        ),
      ],
      child: Scaffold(
        appBar: CustomAppBar(
          title: processName,
          withBottomBorder: false,
          action: BlocBuilder<StageDocsBloc, AppState>(
            builder: (context, stageDocsState) {
              // Only show button if data is loaded
              if (stageDocsState is Done &&
                  stageDocsState.data is StageDocData) {
                final stageDocData = stageDocsState.data as StageDocData;
                final workflowStatus = stageDocData.workFlowStatus ?? '';
                final isStart = workflowStatus == 'start';

                return BlocBuilder<WorkflowProcessDetailsBloc, AppState>(
                  builder: (context, state) {
                    final bloc = context.read<WorkflowProcessDetailsBloc>();
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
                        padding: EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: getStatusColor(
                            workflowStatus,
                          ).withValues(alpha: isStart ? null : 0.1),
                          borderRadius: BorderRadius.circular(isStart ? 8 : 25),
                        ),
                        child: Row(
                          children: [
                            Text(
                              getStatusName(workflowStatus),
                              style: context.textTheme.bodySmall?.copyWith(
                                color: isStart
                                    ? context.color.onPrimary
                                    : getStatusColor(workflowStatus),
                                fontSize: FontSizes.f10,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              }

              // Return empty widget while loading
              return SizedBox.shrink();
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
          ),
        ),
      ),
    );
  }
}

Color getStatusColor(String workflowStatus) => switch (workflowStatus) {
  'start' => LightColor.primary,
  'InProgress' => LightColor.secondary,
  _ => LightColor.tertiary,
};

String getStatusName(String workflowStatus) => switch (workflowStatus) {
  'start' => allTranslations.text(LocaleKeys.start_process),
  'InProgress' => allTranslations.text(LocaleKeys.in_progress),
  _ => allTranslations.text(LocaleKeys.done),
};
