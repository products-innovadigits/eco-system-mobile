import 'package:project_management/core/utility/project_management_exports.dart';

class ProjectManagementSection extends StatelessWidget {
  final bool isProjectManagementHome;

  const ProjectManagementSection({
    super.key,
    this.isProjectManagementHome = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ProjectProgressSection(
          isProjectManagementHome: isProjectManagementHome,
        ),
        SizedBox(height: 16.h),
        ProjectCategoryProgressSection(
          isProjectManagementHome: isProjectManagementHome,
        ),
      ],
    );
  }
}
