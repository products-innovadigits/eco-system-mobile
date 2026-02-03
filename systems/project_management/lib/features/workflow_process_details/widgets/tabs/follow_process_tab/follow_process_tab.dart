import 'package:project_management/core/utility/pms_exports.dart';

class FollowProcessTab extends StatelessWidget {
  final List<GroupStepsData> processList;

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
