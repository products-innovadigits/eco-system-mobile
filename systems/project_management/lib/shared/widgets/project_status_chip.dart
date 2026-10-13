import 'package:project_management/core/utility/project_management_exports.dart';
import 'package:project_management/core/utility/project_management_utility.dart';

/// Project status badge. Every screen that shows a project's status uses this
/// chip so the same status always gets the same color and label.
class ProjectStatusChip extends StatelessWidget {
  /// Status enum key (`Delayed`) or English label (`In Progress`).
  final String? status;

  const ProjectStatusChip({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    final key = ProjectManagementUtility.projectStatusKey(status);
    if (key.isEmpty) return const SizedBox.shrink();

    return CustomInfoContainerWidget(
      color: LightColor.projectStatusColors(key),
      title: ProjectManagementUtility.projectStatusText(key),
      radius: 16,
    );
  }
}
