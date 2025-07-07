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
              color: Styles.PRIMARY_COLOR.withOpacity(0.1)),
          child: Images(
              image: icon,
              width: 16.w,
              height: 16.w,
              color: Styles.PRIMARY_COLOR),
        ),
        SizedBox(width: 8.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                textAlign: TextAlign.start,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.w400
                    .copyWith(fontSize: 12, color: Styles.PRIMARY_COLOR),
              ),
              SizedBox(height: 4.h),
              Text(
                desc,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.start,
                style: AppTextStyles.w400
                    .copyWith(fontSize: 14, color: Styles.HEADER),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
