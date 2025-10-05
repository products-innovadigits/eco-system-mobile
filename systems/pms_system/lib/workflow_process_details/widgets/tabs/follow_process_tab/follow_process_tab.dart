import 'package:pms_system/shared/pms_exports.dart';

class FollowProcessTab extends StatelessWidget {
  final List<ProjectProcessModel> processList;

  const FollowProcessTab({super.key, required this.processList});

  @override
  Widget build(BuildContext context) {
    return ListAnimator(
      separatorPadding: 12,
      data: List.generate(
        processList.length,
        (index) =>
            ProcessExpansionCardWidget(processList: processList, index: index),
      ),
    );
  }
}
