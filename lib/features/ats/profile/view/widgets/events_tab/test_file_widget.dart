import 'package:eco_system/core/app_strings/locale_keys.dart';
import 'package:eco_system/core/assets.gen.dart';
import 'package:eco_system/helpers/styles.dart';
import 'package:eco_system/helpers/text_styles.dart';
import 'package:eco_system/helpers/translation/all_translation.dart';
import 'package:eco_system/utility/extensions.dart';
import 'package:eco_system/widgets/images.dart';
import 'package:flutter/material.dart';

class TestFileWidget extends StatelessWidget {
  const TestFileWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
          horizontal: 16.w, vertical: 10.h),
      decoration: BoxDecoration(
          color: Styles.WHITE_COLOR,
          border: Border.all(color: Styles.BORDER),
          borderRadius: BorderRadius.circular(10)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
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
    );
  }
}
