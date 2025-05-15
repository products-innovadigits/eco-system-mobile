import 'package:eco_system/core/assets.gen.dart';
import 'package:eco_system/helpers/styles.dart';
import 'package:eco_system/helpers/text_styles.dart';
import 'package:eco_system/navigation/custom_navigation.dart';
import 'package:eco_system/navigation/routes.dart';
import 'package:eco_system/utility/extensions.dart';
import 'package:eco_system/widgets/images.dart';
import 'package:eco_system/widgets/percentage_avatar.dart';
import 'package:flutter/material.dart';

class CandidateCardWidget extends StatelessWidget {
  const CandidateCardWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => CustomNavigator.push(Routes.PROFILE),
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                PercentageAvatar(
                  avatarPath: Assets.images.avatar.path,
                  percentage: '80',
                  avatarSize: 32.w,
                  percentageMargin: 4.w,
                  percentageRadius: 2.w,
                  percentageTextStyle: AppTextStyles.w600.copyWith(
                      color: Styles.TEXT_BLUE_DARK_COLOR, fontSize: 6),
                ),
                8.sw,
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'هشام منصور',
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
                Images(image: Assets.svgs.arrowLeft.path),
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
                  'قدم طلب منذ 3 اشهر',
                  style: AppTextStyles.w500.copyWith(
                      color: Styles.SUB_TEXT_DARK_COLOR, fontSize: 10),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
