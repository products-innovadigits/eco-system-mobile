import 'package:eco_system/utility/export.dart';

class ExperienceCardWidget extends StatelessWidget {
  final ExperienceModel experience;

  const ExperienceCardWidget({super.key, required this.experience});

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
                  experience.company ?? '-',
                  style: AppTextStyles.w400.copyWith(fontSize: 12),
                ),
                4.sh,
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      experience.title ?? '-',
                      style: AppTextStyles.w400.copyWith(
                          color: Styles.PRIMARY_COLOR, fontSize: 10),
                    ),
                    4.sw,
                    Text(
                      '${experience.startDate} - ${experience.endDate}',
                      style: AppTextStyles.w400.copyWith(
                          color: Styles.SUB_TEXT_DARK_COLOR, fontSize: 10),
                    ),
                  ],
                ),
              ],
            )
          ],
        ),
        // 8.sh,
        // ReadMoreText(
        //   'قمت بقيادة دورة حياة تطوير منتجات B2B و SaaS، مع ضمان التوافق مع الأهداف.قمت بقيادة دورة حياة تطوير قمت بقيادة دورة حياة تطوير منتجات B2B و SaaS، مع ضمان التوافق مع الأهداف.قمت بقيادة دورة حياة تطوير',
        //   trimMode: TrimMode.Line,
        //   trimLines: 2,
        //   colorClickableText: Styles.PRIMARY_COLOR,
        //   trimExpandedText: allTranslations.text(LocaleKeys.read_less),
        //   trimCollapsedText: allTranslations.text(LocaleKeys.read_more),
        //   moreStyle: AppTextStyles.w400
        //       .copyWith(color: Styles.PRIMARY_COLOR, fontSize: 8),
        //   style: AppTextStyles.w400
        //       .copyWith(color: Styles.SUB_TEXT_DARK_COLOR, fontSize: 8),
        // )
      ],
    );
  }
}
