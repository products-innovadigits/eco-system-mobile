import 'package:eco_system/core/app_state.dart';
import 'package:eco_system/core/app_strings/locale_keys.dart';
import 'package:eco_system/features/ats/profile/bloc/profile_bloc.dart';
import 'package:eco_system/features/ats/profile/view/sections/rating_section.dart';
import 'package:eco_system/features/ats/profile/view/sections/rating_tabs_section.dart';
import 'package:eco_system/helpers/styles.dart';
import 'package:eco_system/helpers/text_styles.dart';
import 'package:eco_system/helpers/translation/all_translation.dart';
import 'package:eco_system/utility/extensions.dart';
import 'package:eco_system/widgets/bottom_sheet_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RatingsBottomSheet extends StatelessWidget {
  const RatingsBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileBloc, AppState>(
      builder: (context, state) {
        final profileBloc = context.read<ProfileBloc>();
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            BottomSheetHeader(title: LocaleKeys.rating),
            24.sh,
            RatingTabsSection(),
            24.sh,
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Styles.BORDER)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                      '${allTranslations.text(LocaleKeys.enter_rating)} ${allTranslations.text(LocaleKeys.technical_skills)}:',
                      style: AppTextStyles.w400.copyWith(fontSize: 11)),
                  16.sh,
                  RatingSection(onRatingSelected: (rate) {
                    profileBloc.selectedTechSkillsRate = rate;
                  })
                ],
              ),
            )
          ],
        );
      },
    );
  }
}
