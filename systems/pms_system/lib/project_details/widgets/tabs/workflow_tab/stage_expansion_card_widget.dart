import '../../../../shared/pms_exports.dart';

class StageExpansionCardWidget extends StatelessWidget {
  final ProjectDetailsModel projectDetailsModel;
  final int index;

  const StageExpansionCardWidget({
    super.key,
    required this.index,
    required this.projectDetailsModel,
  });

  @override
  Widget build(BuildContext context) {
    final stagesList =
        projectDetailsModel.projectLifeCycle?.projectStages ?? [];
    final stage = stagesList[index];
    return CustomExpansionCard(
      title: stage.title ?? '',
      initialExpanded: index == 0,
      leadingWidget: _StageCountWidget(
        count: stage.projectProcesses?.length ?? 0,
      ),
      withMargin: false,
      child: Column(
        children: List.generate(
          stage.projectProcesses?.length ?? 0,
          (idx) => _StageProcessCardWidget(
            title: stage.projectProcesses?[idx].title ?? '',
            processId: stage.projectProcesses?[idx].id ?? 0,
            projectId: projectDetailsModel.id ?? 0,
            workFlowStatus: stage.projectProcesses?[idx].workFlowStatus ?? '',
            projectName: projectDetailsModel.title ?? '',
            stageName: stage.title ?? '',
            projectManagerName: projectDetailsModel.managerName ?? '',
            projectBudget: (projectDetailsModel.budget ?? 0).toDouble(),
            projectStartDate: (projectDetailsModel.startDate ?? DateTime.now()),
            projectEndDate: (projectDetailsModel.endDate ?? DateTime.now()),
            color: getStatusColor(
              stage.projectProcesses?[idx].workFlowStatus ?? '',
            ),
          ),
        ),
      ),
    );
  }
}

class _StageCountWidget extends StatelessWidget {
  final int count;

  const _StageCountWidget({required this.count});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: context.color.primary,
      ),
      child: Text(
        '$count',
        style: context.textTheme.labelSmall?.copyWith(
          color: context.color.onPrimary,
        ),
      ),
    );
  }
}

class _StageProcessCardWidget extends StatelessWidget {
  final String title;
  final int processId;
  final int projectId;
  final String projectName;
  final String stageName;
  final String workFlowStatus;
  final String projectManagerName;
  final double projectBudget;
  final DateTime? projectStartDate;
  final DateTime? projectEndDate;
  final Color color;

  const _StageProcessCardWidget({
    required this.title,
    required this.color,
    required this.processId,
    required this.projectId,
    required this.projectName,
    required this.stageName,
    required this.projectStartDate,
    required this.projectEndDate,
    required this.projectManagerName,
    required this.projectBudget,
    required this.workFlowStatus,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        CustomNavigator.push(
          Routes.WORKFLOW_PROCESS_DETAILS,
          arguments: WorkflowProcessDetailsArgs(
            processId: processId,
            projectId: projectId,
            projectWorkFlowStatus: workFlowStatus,
            processName: title,
            projectName: projectName,
            stageName: stageName,
            projectManagerName: projectManagerName,
            projectBudget: projectBudget,
            projectStartDate: projectStartDate,
            projectEndDate: projectEndDate,
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: color.withValues(alpha: 0.3)),
        ),
        child: Row(
          children: [
            Icon(Icons.circle, color: color, size: 10),
            const SizedBox(width: 6),
            Expanded(child: Text(title, style: context.textTheme.bodySmall)),
            Icon(Icons.arrow_forward, color: color, size: 16),
            // InkWell(
            //   onTap: () {
            //     CustomNavigator.push(
            //       Routes.WORKFLOW_PROCESS_DETAILS,
            //       arguments: 21,
            //     );
            //   },
            //   child: Container(
            //     padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            //     decoration: BoxDecoration(
            //       color: color.withValues(alpha: 0.1),
            //       borderRadius: BorderRadius.circular(25),
            //     ),
            //     child: Row(
            //       children: [
            //         Text(
            //           status,
            //           style: context.textTheme.bodySmall?.copyWith(
            //             color: color,
            //             fontSize: FontSizes.f10,
            //           ),
            //         ),
            //         SizedBox(width: 6),
            //         Icon(Icons.arrow_forward, color: color, size: 12),
            //       ],
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}

Color getStatusColor(String workflowStatus) => switch (workflowStatus) {
  'start' => LightColor.placeHolderText,
  'inProgress' => LightColor.secondary,
  _ => LightColor.tertiary,
};
