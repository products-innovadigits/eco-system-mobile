import 'package:pms_system/shared/pms_exports.dart';
import 'package:pms_system/workflow_process_details/model/workflow_process_details_model.dart';

class FollowProcessTab extends StatelessWidget {
  final List<WorkflowProcessGroupModel> processList;

  const FollowProcessTab({super.key, required this.processList});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: processList.length,
      itemBuilder: (context, index) =>
          ProcessExpansionCardWidget(processList: processList, index: index),
      separatorBuilder: (context, index) => const SizedBox(height: 12.0),
    );
  }
}
