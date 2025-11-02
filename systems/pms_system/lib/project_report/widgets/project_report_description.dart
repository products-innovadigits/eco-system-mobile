import 'package:pms_system/shared/pms_exports.dart';

class ProjectReportDescription extends StatelessWidget {
  final String description;
  final String status;
  const ProjectReportDescription({super.key, required this.description, required this.status});

  @override
  Widget build(BuildContext context) {
    return CustomExpansionCard(
      title: allTranslations.text(LocaleKeys.project_description),
      withMargin: false,
      withExpanded: false,
      leadingWidget: Images(
        image: Assets.svgs.file.path,
        color: Colors.black,
        width: 24,
      ),
      action: Container(
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: context.color.secondary.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Text(
             status,
              style: context.textTheme.bodySmall?.copyWith(
                color: context.color.primary,
              ),
            ),
          ],
        ),
      ),
      child: Align(
        alignment: AlignmentDirectional.centerStart,
        child: Text(
          description,
          style: context.textTheme.bodySmall?.copyWith(
            color: context.color.outlineVariant,
          ),
        ),
      ),
    );
  }
}
