import 'package:core_package/core/helpers/font_sizes.dart';
import 'package:core_package/core/utility/export.dart';

class ProjectContentCard extends StatelessWidget {
  const ProjectContentCard(
      {super.key, required this.icon, required this.title, required this.desc});

  final String icon, title, desc;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(8.w),
          decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: context.color.secondary.withOpacity(0.1)),
          child: Images(
              image: icon,
              width: 16.w,
              height: 16.w,
              color: context.color.primary),
        ),
        SizedBox(width: 8.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title,
                  textAlign: TextAlign.start,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: context.textTheme.bodySmall?.copyWith(
                    color: context.color.outlineVariant,
                    fontSize: FontSizes.f10,
                  )),
              SizedBox(height: 4.h),
              Text(
                desc,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.start,
                style: context.textTheme.labelSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
