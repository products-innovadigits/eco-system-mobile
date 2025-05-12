import 'package:eco_system/components/custom_text_field.dart';
import 'package:eco_system/core/app_strings/locale_keys.dart';
import 'package:eco_system/helpers/text_styles.dart';
import 'package:eco_system/helpers/translation/all_translation.dart';
import 'package:eco_system/utility/extensions.dart';
import 'package:flutter/material.dart';

class CompatibilityRate extends StatelessWidget {
  const CompatibilityRate({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(allTranslations.text(LocaleKeys.compatibility_rate),
            style: AppTextStyles.w400.copyWith(fontSize: 12)),
        CustomTextField(
            hint: allTranslations
                .text(LocaleKeys.enter_compatibility_rate)),
      ],
    );;
  }
}
