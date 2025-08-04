import '../../shared/pms_exports.dart';

class ProjectMonthlyProgressSection extends StatelessWidget {
  const ProjectMonthlyProgressSection({super.key});

  @override
  Widget build(BuildContext context) {
    return ProjectMonthlyProgress(
      data: [
        ProjectCategoriesProgressModel(name: "xxx", progress: 20),
        ProjectCategoriesProgressModel(name: "yyy", progress: 10),
        ProjectCategoriesProgressModel(name: "yyy", progress: 40),
        ProjectCategoriesProgressModel(name: "yyy", progress: 70),
        ProjectCategoriesProgressModel(name: "zzz", progress: 80),
      ],
    );
  }
}
