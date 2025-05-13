import 'package:eco_system/core/app_strings/locale_keys.dart';
import 'package:eco_system/core/assets.gen.dart';
import 'package:eco_system/helpers/styles.dart';
import 'package:eco_system/helpers/text_styles.dart';
import 'package:eco_system/helpers/translation/all_translation.dart';
import 'package:eco_system/utility/extensions.dart';
import 'package:eco_system/widgets/images.dart';
import 'package:flutter/material.dart';

class EmptySearchSection extends StatelessWidget {
  const EmptySearchSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          (context.h * 0.2).sh,
          Images(image: Assets.svgs.searchPlaceholder.path),
          24.sh,
          Text(allTranslations.text(LocaleKeys.start_search_candidate),
              style: AppTextStyles.w700),
          12.sh,
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Text(allTranslations.text(LocaleKeys.enter_keywords),
                textAlign: TextAlign.center,
                style: AppTextStyles.w400
                    .copyWith(fontSize: 12, color: Styles.SUB_TEXT_DARK_COLOR)),
          ),
        ],
      ),
    );
  }
}
