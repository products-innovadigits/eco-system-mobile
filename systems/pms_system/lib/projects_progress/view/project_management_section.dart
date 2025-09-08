import '../../shared/pms_exports.dart';

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
