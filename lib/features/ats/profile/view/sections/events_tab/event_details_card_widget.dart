import 'package:eco_system/core/app_strings/locale_keys.dart';
import 'package:eco_system/core/assets.gen.dart';
import 'package:eco_system/helpers/styles.dart';
import 'package:eco_system/helpers/text_styles.dart';
import 'package:eco_system/helpers/translation/all_translation.dart';
import 'package:eco_system/utility/extensions.dart';
import 'package:eco_system/widgets/images.dart';
import 'package:flutter/material.dart';

class EventDetailsCardWidget extends StatelessWidget {
  const EventDetailsCardWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 32.w,
              height: 32.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Styles.BORDER, width: 2),
                image: DecorationImage(
                    image: AssetImage(Assets.images.avatar.path),
                    fit: BoxFit.fill),
              ),
            ),
            8.sw,
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'اسلام محمد',
                  style: AppTextStyles.w600
                      .copyWith(color: Styles.TEXT_COLOR, fontSize: 12),
                ),
                2.sh,
                Row(
                  children: [
                    Text(
                      '1 August 2023 . ',
                      style: AppTextStyles.w400.copyWith(
                          color: Styles.SUB_TEXT_DARK_COLOR, fontSize: 9),
                    ),
                    Text('12:00 Am',
                        style: AppTextStyles.w400.copyWith(
                            color: Styles.SUB_TEXT_DARK_COLOR, fontSize: 9))
                  ],
                ),
              ],
            ),
          ],
        ),
        8.sh,
        Container(
          width: context.w,
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
          decoration: BoxDecoration(
              color: Styles.WHITE_COLOR,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Styles.BORDER)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RichText(
                  text: TextSpan(children: [
                    TextSpan(
                        text: 'هشام منصور الان في ',
                        style: AppTextStyles.w400
                            .copyWith(color: Color(0xff666666), fontSize: 10)),
                    TextSpan(
                        text: 'مرحلة المقابلة الشخصية ',
                        style: AppTextStyles.w400
                            .copyWith(color: Color(0xff94B849), fontSize: 10)),
                    TextSpan(
                        text: 'ينتظر تحديد موعد الاختبار',
                        style: AppTextStyles.w400
                            .copyWith(color: Color(0xff666666), fontSize: 10)),
                  ])),
              16.sh,
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
                        image: Assets.svgs.file.path,
                        color: Styles.PRIMARY_COLOR),
                    8.sw,
                    Text(
                      allTranslations.text(LocaleKeys.test_file),
                      style: AppTextStyles.w500.copyWith(
                          color: Styles.PRIMARY_COLOR,
                          fontSize: 10),
                    )
                  ],
                ),
              )
            ],
          ),
        )
      ],
    );
  }
}
