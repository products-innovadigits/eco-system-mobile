import 'package:eco_system/core/app_state.dart';
import 'package:eco_system/core/app_strings/locale_keys.dart';
import 'package:eco_system/core/assets.gen.dart';
import 'package:eco_system/features/ats/profile/bloc/profile_bloc.dart';
import 'package:eco_system/features/ats/profile/view/sections/add_comment_section.dart';
import 'package:eco_system/features/ats/profile/view/sections/numbers_rating_section.dart';
import 'package:eco_system/helpers/styles.dart';
import 'package:eco_system/helpers/text_styles.dart';
import 'package:eco_system/helpers/translation/all_translation.dart';
import 'package:eco_system/utility/extensions.dart';
import 'package:eco_system/widgets/images.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CustomRatingSection extends StatelessWidget {
  final String title;
  final int selectedRating;
  final TextEditingController commentController;
  final Function(String) onCommentAdded;
  final Function(int rate)? onRatingSelected;

  const CustomRatingSection(
      {super.key,
      required this.title,
      this.onRatingSelected,
      required this.commentController,
      required this.onCommentAdded,
      required this.selectedRating});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Styles.BORDER)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('${allTranslations.text(LocaleKeys.enter_rating)} $title:',
              style: AppTextStyles.w400.copyWith(fontSize: 11)),
          16.sh,
          NumbersRatingSection(
              selectedRating: selectedRating,
              onRatingSelected: (rate) {
                onRatingSelected?.call(rate);
              }),
          if (selectedRating != -1) ...[
            16.sh,
            AddCommentSection(
                commentController: commentController,
                onCommentAdded: onCommentAdded)
          ]
        ],
      ),
    );
  }
}
