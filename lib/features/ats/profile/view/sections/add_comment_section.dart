import 'package:eco_system/core/app_state.dart';
import 'package:eco_system/core/app_strings/locale_keys.dart';
import 'package:eco_system/core/assets.gen.dart';
import 'package:eco_system/features/ats/profile/bloc/profile_bloc.dart';
import 'package:eco_system/features/ats/profile/view/sections/rating_reason_bottom_sheet.dart';
import 'package:eco_system/helpers/popup_helper.dart';
import 'package:eco_system/helpers/styles.dart';
import 'package:eco_system/helpers/text_styles.dart';
import 'package:eco_system/helpers/translation/all_translation.dart';
import 'package:eco_system/utility/extensions.dart';
import 'package:eco_system/widgets/images.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddCommentSection extends StatelessWidget {
  final TextEditingController commentController;
  final Function(String) onCommentAdded;

  const AddCommentSection(
      {super.key,
      required this.commentController,
      required this.onCommentAdded});

  @override
  Widget build(BuildContext context) {
    return commentController.text.isNotEmpty
        ? Row(
            children: [
              Text('${allTranslations.text(LocaleKeys.comment)}:',
                  style: AppTextStyles.w600
                      .copyWith(fontSize: 10, color: Styles.PRIMARY_COLOR)),
              Text(commentController.text,
                  style: AppTextStyles.w400.copyWith(
                      fontSize: 10, color: Styles.SUB_TEXT_DARK_COLOR))
            ],
          )
        : BlocBuilder<ProfileBloc, AppState>(
            builder: (context, state) {
              return InkWell(
                onTap: () {
                  // PopUpHelper.showBottomSheet(
                  //     context: context,
                  //     child: RatingReasonBottomSheet(
                  //       commentController: commentController,
                  //       onCommentAdded: onCommentAdded,
                  //     ));
                },
                child: Row(
                  children: [
                    Images(image: Assets.svgs.addCircle.path),
                    8.sw,
                    Text(allTranslations.text(LocaleKeys.add_comment),
                        style: AppTextStyles.w400.copyWith(
                            fontSize: 12, color: Styles.PRIMARY_COLOR)),
                  ],
                ),
              );
            },
          );
  }
}
