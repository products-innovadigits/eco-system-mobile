import 'package:eco_system/core/app_strings/locale_keys.dart';
import 'package:eco_system/core/assets.gen.dart';
import 'package:eco_system/helpers/styles.dart';
import 'package:eco_system/helpers/text_styles.dart';
import 'package:eco_system/helpers/translation/all_translation.dart';
import 'package:eco_system/utility/extensions.dart';
import 'package:eco_system/widgets/images.dart';
import 'package:flutter/material.dart';

class ProfileUserDataWidget extends StatelessWidget {
  const ProfileUserDataWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Stack(
              children: [
                Container(
                  width: 64.w,
                  height: 64.h,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                        color: Styles.PRIMARY_COLOR, width: 2),
                    image: DecorationImage(
                        image:
                        AssetImage(Assets.images.avatar.path),
                        fit: BoxFit.fill),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 2.h),
                    margin: EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        color: Styles.WHITE_COLOR),
                    child: Center(
                      child: Text(
                        '10%',
                        style: AppTextStyles.w600.copyWith(
                            color: Styles.PRIMARY_COLOR,
                            fontSize: 10),
                      ),
                    ),
                  ),
                )
              ],
            ),
            Container(
              padding: EdgeInsets.symmetric(
                  horizontal: 10.w, vertical: 8.h),
              decoration: BoxDecoration(
                  color: Styles.WHITE_COLOR,
                  borderRadius: BorderRadius.circular(10)),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Images(
                      image: Assets.svgs.documentDownload.path,
                      color: Styles.PRIMARY_COLOR),
                  8.sw,
                  Text(
                    allTranslations.text(LocaleKeys.download_cv),
                    style: AppTextStyles.w500.copyWith(
                        color: Styles.PRIMARY_COLOR,
                        fontSize: 10),
                  )
                ],
              ),
            )
          ],
        ),
        10.sh,
        Text('هشام منصور',
            style: AppTextStyles.w600.copyWith(
                fontSize: 16, color: Styles.WHITE_COLOR)),
        6.sh,
        Text('مصمم أول لواجهة المستخدم',
            style: AppTextStyles.w400
                .copyWith(color: Styles.WHITE_COLOR)),
      ],
    );
  }
}
