import 'package:eco_system/core/app_strings/locale_keys.dart';
import 'package:eco_system/core/assets.gen.dart';
import 'package:eco_system/features/ats/profile/view/sections/manager_details_review_section.dart';
import 'package:eco_system/features/ats/profile/view/widgets/compatibility_percentage_widget.dart';
import 'package:eco_system/helpers/styles.dart';
import 'package:eco_system/helpers/text_styles.dart';
import 'package:eco_system/helpers/translation/all_translation.dart';
import 'package:eco_system/utility/extensions.dart';
import 'package:eco_system/widgets/images.dart';
import 'package:flutter/material.dart';

class RatingsSection extends StatelessWidget {
  const RatingsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ManagersReviewsListSection(),
        16.sh,
        CompatibilityPercentageWidget(
            title: allTranslations.text(LocaleKeys.final_evaluation),
            percentage: 80)
      ],
    );
  }
}
