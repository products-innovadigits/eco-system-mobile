import 'package:pms_system/core/utility/pms_exports.dart';
import 'package:pms_system/features/workflow_process_details/model/workflow_process_details_model.dart';
import 'package:pms_system/features/workflow_process_details/widgets/tabs/follow_process_tab/process_expansion_card_widget.dart';

class FollowProcessTab extends StatelessWidget {
  final List<WorkflowProcessGroupModel> processList;

  const FollowProcessTab({super.key, required this.processList});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: processList.length,
      itemBuilder: (context, index) =>
          ProcessExpansionCardWidget(processList: processList, index: index),
      separatorBuilder: (context, index) => SizedBox(height: 12.0.h),
    );
  }
}
