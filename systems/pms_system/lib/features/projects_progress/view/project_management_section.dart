import 'package:pms_system/core/utility/pms_exports.dart';
import 'package:pms_system/features/projects_progress/widgets/project_progress_section.dart';

class ProjectManagementSection extends StatelessWidget {
  final bool isPmsHome;

  const ProjectManagementSection({super.key, this.isPmsHome = false});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ProjectProgressSection(isPmsHome: isPmsHome),
        16.sh,
        ProjectCategoryProgressSection(isPmsHome: isPmsHome),
      ],
    );
  }
}
