import 'package:eco_system/helpers/text_styles.dart';
import 'package:eco_system/helpers/translation/all_translation.dart';
import 'package:eco_system/utility/extensions.dart';
import 'package:flutter/material.dart';

import '../../../../helpers/styles.dart';

class WelcomeWidget extends StatelessWidget {
  const WelcomeWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      SizedBox(height: 30.h),
      Text(
        allTranslations.text("login_header"),
        style: AppTextStyles.w700.copyWith(
          color: Styles.HEADER,
          fontSize: 28,
        ),
      ),
      SizedBox(height: 12.h),
      Text(
        allTranslations.text("login_sub_header"),
        style: AppTextStyles.w400.copyWith(
          color: Styles.DETAILS,
          fontSize: 14,
        ),
      ),
    ]);
  }
}
