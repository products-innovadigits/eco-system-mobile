import 'package:pms_system/shared/pms_exports.dart';

class ProjectWorkflowTab extends StatelessWidget {
  final ProjectDetailsModel projectDetailsModel;

  const ProjectWorkflowTab({super.key, required this.projectDetailsModel});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: projectDetailsModel.projectLifeCycle?.projectStages?.length ?? 0,
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) => StageExpansionCardWidget(
        projectDetailsModel: projectDetailsModel,
        index: index,
      ),
      separatorBuilder: (context, index) => const SizedBox(height: 12),
    );
  }
}
