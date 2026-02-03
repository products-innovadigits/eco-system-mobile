import 'package:project_management/core/utility/pms_exports.dart';

class ProjectManagementSection extends StatelessWidget {
  final bool isPmsHome;

  const ProjectManagementSection({super.key, this.isPmsHome = false});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ProjectProgressSection(isPmsHome: isPmsHome),
        SizedBox(height: 16.h),
        ProjectCategoryProgressSection(isPmsHome: isPmsHome),
      ],
    );
  }
}
