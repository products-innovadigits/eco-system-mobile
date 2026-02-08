import 'package:project_management/core/utility/project_management_exports.dart';

class ProjectReportName extends StatelessWidget {
  final String name;
  final String status;

  const ProjectReportName({
    super.key,
    required this.name,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: context.color.surfaceContainer,
        border: Border.all(color: context.color.outline),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(8.w),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.w),
              border: Border.all(color: context.color.outline),
            ),
            child: Images(
              image: Assets.svgs.chartReport.path,
              width: 24.w,
              height: 24.w,
              color: context.color.secondary,
            ),
          ),
          SizedBox(width: 16.w),
          Expanded(child: Text(name, style: context.textTheme.labelMedium)),
          SizedBox(width: 16.w),
          if (status.isNotEmpty)
            CustomInfoContainerWidget(
              color: context.color.secondary,
              title: status,
              radius: 16,
            ),
        ],
      ),
    );
  }
}
