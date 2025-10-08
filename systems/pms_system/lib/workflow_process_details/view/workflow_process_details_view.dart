import 'package:pms_system/shared/pms_exports.dart';
import 'package:pms_system/workflow_process_details/widgets/process_details_body.dart';

class WorkflowProcessDetailsView extends StatelessWidget {
  const WorkflowProcessDetailsView({
    super.key,
    required this.processId,
    required this.projectId,
    required this.processName,
    required this.projectName,
    required this.projectStartDate,
    required this.projectEndDate,
    required this.projectManagerName,
    required this.projectBudget,
    required this.workflowStatus,
  });

  final int processId;
  final int projectId;
  final String workflowStatus;
  final String processName;
  final String projectName;
  final String projectManagerName;
  final double projectBudget;
  final DateTime? projectStartDate;
  final DateTime? projectEndDate;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: processName,
        withBottomBorder: false,
        action: Container(
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: getStatusColor(workflowStatus).withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(25),
          ),
          child: Row(
            children: [
              Text(
                workflowStatus,
                style: context.textTheme.bodySmall?.copyWith(
                  color: getStatusColor(workflowStatus),
                  fontSize: FontSizes.f10,
                ),
              ),
            ],
          ),
        ),
      ),
      body: SafeArea(
        child: BlocProvider(
          create: (context) => WorkflowProcessDetailsBloc()
            ..add(
              Click(
                arguments: {'processId': processId, 'projectId': projectId},
              ),
            ),
          // create: (context) => WorkflowProcessDetailsBloc(),
          child: ProcessDetailsBody(
            projectDetailsModel: ProjectDetailsModel(
              id: projectId,
              title: projectName,
              managerName: projectManagerName,
              budget: projectBudget,
              startDate: projectStartDate,
              endDate: projectEndDate,
            ),
          ),
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
