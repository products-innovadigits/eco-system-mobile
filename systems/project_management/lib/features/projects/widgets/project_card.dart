import 'package:project_management/core/utility/pms_exports.dart';

class ProjectCard extends StatelessWidget {
  const ProjectCard({super.key, required this.project});

  final ProjectDetailsModel project;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () =>
          CustomNavigator.push(Routes.PROJECT_DETAILS, arguments: project.id),
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      hoverColor: Colors.transparent,
      focusColor: Colors.transparent,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 8.h),
        decoration: BoxDecoration(
          color: context.color.surfaceContainer,
          border: Border.all(color: context.color.outline),
          borderRadius: BorderRadius.circular(12.w),
        ),
        child: Column(
          children: [
            // Header with output count
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 6.h),
              decoration: BoxDecoration(
                color: context.color.secondary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(12.w),
                  topRight: Radius.circular(12.w),
                ),
              ),
              child: Text(
                "${allTranslations.text(LocaleKeys.delivered)} ${project.deliveredOutputs ?? 0} ${allTranslations.text(LocaleKeys.outputs)} ${allTranslations.text(LocaleKeys.delivered_from)} ${project.outputCount ?? 10} ${allTranslations.text(LocaleKeys.outputs)}",
                style: context.textTheme.labelSmall?.copyWith(
                  color: context.color.secondary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
              child: ProjectCardContent(project: project),
            ),
          ],
        ),
      ),
    );
  }
}
