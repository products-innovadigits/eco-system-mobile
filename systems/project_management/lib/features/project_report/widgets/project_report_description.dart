import 'package:project_management/core/utility/pms_exports.dart';

class ProjectReportDescription extends StatelessWidget {
  final String description;
  final String category;

  const ProjectReportDescription({
    super.key,
    required this.description,
    required this.category,
  });

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
      action: category.isNotEmpty
          ? CustomInfoContainerWidget(
              color: context.color.errorContainer,
              title: category,
              radius: 16,
            )
          : null,
      child: Align(
        alignment: description.isNotEmpty
            ? AlignmentDirectional.centerStart
            : AlignmentDirectional.center,
        child: description.isNotEmpty
            ? Text(
                description,
                style: context.textTheme.bodySmall?.copyWith(
                  color: context.color.outlineVariant,
                ),
              )
            : Center(
                child: Text(allTranslations.text(LocaleKeys.there_is_no_data)),
              ),
      ),
    );
  }
}
