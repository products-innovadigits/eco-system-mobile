import 'package:eco_system/utility/export.dart';

class EducationCardWidget extends StatelessWidget {
  final EducationModel educationModel;

  const EducationCardWidget({super.key, required this.educationModel});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
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
                    educationModel.school ?? 'اينوفا ديجتس',
                    style: AppTextStyles.w400.copyWith(fontSize: 12),
                  ),
                  4.sh,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        educationModel.degree ?? 'قائد تصميم المنتجات .',
                        style: AppTextStyles.w400.copyWith(
                            color: Styles.PRIMARY_COLOR, fontSize: 10),
                      ),
                      4.sw,
                      Text(
                        '${educationModel.startDate} - ${educationModel.endDate}',
                        style: AppTextStyles.w400.copyWith(
                            color: Styles.SUB_TEXT_DARK_COLOR, fontSize: 10),
                      ),
                    ],
                  ),
                ],
              )
            ],
          ),
          if (educationModel.fieldStudy != null &&
              educationModel.fieldStudy!.isNotEmpty) ...[
            8.sh,
            ReadMoreText(
              educationModel.fieldStudy ?? '',
              trimMode: TrimMode.Line,
              trimLines: 2,
              colorClickableText: Styles.PRIMARY_COLOR,
              trimExpandedText: allTranslations.text(LocaleKeys.read_less),
              trimCollapsedText: allTranslations.text(LocaleKeys.read_more),
              moreStyle: AppTextStyles.w400
                  .copyWith(color: Styles.PRIMARY_COLOR, fontSize: 8),
              style: AppTextStyles.w400
                  .copyWith(color: Styles.SUB_TEXT_DARK_COLOR, fontSize: 8),
            )
          ],
        ],
      ),
    );
  }
}
