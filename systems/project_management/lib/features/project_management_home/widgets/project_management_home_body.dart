import 'package:project_management/core/utility/project_management_exports.dart';

class ProjectManagementHomeBody extends StatelessWidget {
  const ProjectManagementHomeBody({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: Column(
          spacing: 16.h,
          children: [
            SizedBox(height: 80.h),
            ProjectManagementSection(isProjectManagementHome: true),
            const LatestRequestsSection(),
            SizedBox(height: 16.h),
          ],
        ),
      ),
    );
  }
}
