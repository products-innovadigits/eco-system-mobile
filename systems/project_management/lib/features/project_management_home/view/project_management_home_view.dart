import 'package:project_management/core/utility/project_management_exports.dart';

class ProjectManagementHomeView extends StatelessWidget {
  const ProjectManagementHomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Stack(
            children: [MainHeader(), ProjectManagementHomeBody()]),
      ),
    );
  }
}
