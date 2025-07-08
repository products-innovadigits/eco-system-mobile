import 'package:core_package/core/utility/export.dart';

class CareerDetailsCardWidget extends StatelessWidget {
  final String title;
  final String startDate;
  final String endDate;
  final String jobTitle;
  final String desc;

  const CareerDetailsCardWidget({
    super.key,
    required this.title,
    required this.startDate,
    required this.endDate,
    required this.jobTitle,
    required this.desc,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 32.w,
              height: 32.w,
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                  color: Styles.PRIMARY_COLOR.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8)),
              child: Images(
                  image: Assets.svgs.building.path,
                  color: Styles.PRIMARY_COLOR),
            ),
            8.sw,
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.w400.copyWith(fontSize: 12),
                ),
                4.sh,
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      jobTitle,
                      style: AppTextStyles.w400
                          .copyWith(color: Styles.PRIMARY_COLOR, fontSize: 10),
                    ),
                    4.sw,
                    Text(
                      '$startDate - $endDate',
                      style: AppTextStyles.w400.copyWith(
                          color: Styles.SUB_TEXT_DARK_COLOR, fontSize: 10),
                    ),
                  ],
                ),
              ],
            )
          ],
        ),
        if (desc.isNotEmpty) ...[
          8.sh,
          ReadMoreText(
            desc,
            trimMode: TrimMode.Line,
            trimLines: 2,
            colorClickableText: context.color.secondary,
            trimExpandedText: allTranslations.text(LocaleKeys.read_less),
            trimCollapsedText: allTranslations.text(LocaleKeys.read_more),
            moreStyle: context.textTheme.bodySmall
                ?.copyWith(color: context.color.secondary, fontSize: 8),
            style: context.textTheme.bodySmall
                ?.copyWith(color: context.color.outline, fontSize: 8),
          )
        ],
      ],
    );
  }
}
