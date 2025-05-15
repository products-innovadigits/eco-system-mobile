import 'package:eco_system/utility/export.dart';

class TalentCardWidget extends StatelessWidget {
  final bool isSelectionActive;
  final VoidCallback onSelectTalent;
  final bool isTalentSelected;

  const TalentCardWidget(
      {super.key,
      required this.isSelectionActive,
      required this.onSelectTalent,
      required this.isTalentSelected});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => CustomNavigator.push(Routes.PROFILE, arguments: true),
      child: Container(
        width: context.w,
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        decoration: BoxDecoration(
            color: Styles.WHITE_COLOR,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Styles.BORDER)),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (isSelectionActive) ...[
                  CustomCheckBoxWidget(
                      onCheck: onSelectTalent, isChecked: isTalentSelected),
                ],
                Container(
                  width: 40.w,
                  height: 40.h,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                        image: AssetImage(Assets.images.avatar.path),
                        fit: BoxFit.contain),
                  ),
                ),
                8.sw,
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'محمد عزيز',
                      style: AppTextStyles.w500
                          .copyWith(color: Styles.TEXT_COLOR, fontSize: 12),
                    ),
                    2.sh,
                    Row(
                      children: [
                        Text(
                          'مدير المشروعات . ',
                          style: AppTextStyles.w400.copyWith(
                              color: Styles.SUB_TEXT_DARK_COLOR, fontSize: 10),
                        ),
                        Text('5 من الوظائف',
                            style: AppTextStyles.w400.copyWith(
                                color: Styles.PRIMARY_COLOR, fontSize: 10))
                      ],
                    ),
                  ],
                ),
                const Spacer(),
                Container(
                    width: 24.w,
                    height: 24.h,
                    alignment: AlignmentDirectional.centerEnd,
                    padding: EdgeInsets.all(6),
                    child: Images(image: Assets.svgs.arrowLeft.path)),
              ],
            ),
            Padding(
              padding: EdgeInsets.all(12.h),
              child: Divider(color: Styles.BORDER),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  'السعودية',
                  style: AppTextStyles.w500.copyWith(
                      color: Styles.SUB_TEXT_DARK_COLOR, fontSize: 10),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.w),
                  child: Icon(Icons.circle,
                      color: Styles.SUB_TEXT_DARK_COLOR, size: 5),
                ),
                Text(
                  'خبرة ٥ سنين',
                  style: AppTextStyles.w500.copyWith(
                      color: Styles.SUB_TEXT_DARK_COLOR, fontSize: 10),
                ),
                const Spacer(),
                Text('1000 ر.س . اسبوعين ',
                    style: AppTextStyles.w400
                        .copyWith(color: Styles.PRIMARY_COLOR, fontSize: 10))
              ],
            ),
          ],
        ),
      ),
    );
  }
}
