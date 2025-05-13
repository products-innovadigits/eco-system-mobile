import 'package:eco_system/core/app_strings/locale_keys.dart';
import 'package:eco_system/core/assets.gen.dart';
import 'package:eco_system/features/ats/profile/view/widgets/compatibility_percentage_widget.dart';
import 'package:eco_system/helpers/text_styles.dart';
import 'package:eco_system/helpers/translation/all_translation.dart';
import 'package:eco_system/utility/extensions.dart';
import 'package:eco_system/widgets/bottom_sheet_header.dart';
import 'package:eco_system/widgets/images.dart';
import 'package:flutter/material.dart';

class CompatibilityBottomSheetWidget extends StatelessWidget {
  const CompatibilityBottomSheetWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        BottomSheetHeader(
          title: LocaleKeys.compatibility,
        ),
        24.sh,
        ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) => Row(
                  children: [
                    Images(image: Assets.svgs.tickCircle.path),
                    8.sw,
                    Text('البحث عن تجربة المستخدم',
                        style: AppTextStyles.w400.copyWith(fontSize: 12))
                  ],
                ),
            separatorBuilder: (context, index) => 16.sh,
            itemCount: 6),
        24.sh,
        CompatibilityPercentageWidget(
            title: allTranslations.text(LocaleKeys.keyword_matching),
            percentage: 80),
      ],
    );
  }
}
