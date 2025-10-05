import 'package:pms_system/shared/pms_exports.dart';

class ProjectWorkflowTab extends StatelessWidget {
  final List<ProjectStagesModel> stagesList;

  const ProjectWorkflowTab({super.key, required this.stagesList});

  @override
  Widget build(BuildContext context) {
    return ListAnimator(
      separatorPadding: 12,
      data: List.generate(
        stagesList.length,
        (index) =>
            StageExpansionCardWidget(stagesList: stagesList, index: index),
      ),
    );
  }
}
