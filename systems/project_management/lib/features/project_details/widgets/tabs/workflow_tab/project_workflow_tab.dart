import 'package:project_management/core/utility/project_management_exports.dart';

class ProjectWorkflowTab extends StatelessWidget {
  final ProjectDetailsModel projectDetailsModel;

  const ProjectWorkflowTab({super.key, required this.projectDetailsModel});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            _infoItem(
              allTranslations.text(LocaleKeys.start),
              context.color.outlineVariant,
              context,
            ),
            SizedBox(width: 16.w),
            _infoItem(
              allTranslations.text(LocaleKeys.in_progress),
              context.color.primary,
              context,
            ),
            SizedBox(width: 16.w),
            _infoItem(
              allTranslations.text(LocaleKeys.done),
              context.color.tertiary,
              context,
            ),
          ],
        ),
        SizedBox(height: 8.h),
        ListView.separated(
          itemCount:
              projectDetailsModel.projectLifeCycle?.projectStages?.length ?? 0,
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) => StageExpansionCardWidget(
            projectDetailsModel: projectDetailsModel,
            index: index,
          ),
          separatorBuilder: (context, index) => SizedBox(height: 12.h),
        ),
      ],
    );
  }
}

Widget _infoItem(String title, Color color, BuildContext context) {
  return Row(
    children: [
      Icon(Icons.circle, color: color, size: 10),
      SizedBox(width: 4.w),
      Text(title, style: context.textTheme.bodySmall),
    ],
  );
}
