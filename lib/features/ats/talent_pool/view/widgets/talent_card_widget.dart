import 'package:eco_system/core/assets.gen.dart';
import 'package:eco_system/helpers/styles.dart';
import 'package:eco_system/helpers/text_styles.dart';
import 'package:eco_system/navigation/custom_navigation.dart';
import 'package:eco_system/navigation/routes.dart';
import 'package:eco_system/utility/extensions.dart';
import 'package:eco_system/widgets/custom_check_box_widget.dart';
import 'package:eco_system/widgets/images.dart';
import 'package:flutter/material.dart';

class TalentCardWidget extends StatelessWidget {
  final bool isSelectionActive;
  final Function(bool) onSelectTalent;

  const TalentCardWidget(
      {super.key,
      required this.isSelectionActive,
      required this.onSelectTalent});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => CustomNavigator.push(Routes.PROFILE , arguments: true),
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
                  CustomCheckBoxWidget(onCheck: onSelectTalent),
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
                  style: AppTextStyles.w500
                      .copyWith(color: Styles.SUB_TEXT_DARK_COLOR, fontSize: 10),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.w),
                  child: Icon(Icons.circle,
                      color: Styles.SUB_TEXT_DARK_COLOR, size: 5),
                ),
                Text(
                  'خبرة ٥ سنين',
                  style: AppTextStyles.w500
                      .copyWith(color: Styles.SUB_TEXT_DARK_COLOR, fontSize: 10),
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
