import 'package:eco_system/components/custom_btn.dart';
import 'package:eco_system/components/custom_text_field.dart';
import 'package:eco_system/core/app_strings/locale_keys.dart';
import 'package:eco_system/helpers/translation/all_translation.dart';
import 'package:eco_system/navigation/custom_navigation.dart';
import 'package:eco_system/utility/extensions.dart';
import 'package:eco_system/widgets/bottom_sheet_header.dart';
import 'package:flutter/material.dart';

class RatingReasonBottomSheet extends StatelessWidget {
  final TextEditingController commentController;
  final Function(String) onCommentAdded;
  const RatingReasonBottomSheet({super.key, required this.commentController, required this.onCommentAdded});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        BottomSheetHeader(title: LocaleKeys.add_comment),
        24.sh,
        CustomTextField(
            hint:
            '${allTranslations.text(LocaleKeys.add_reason)}...',
            label: allTranslations.text(LocaleKeys.reason),
            controller: commentController,
            maxLines: 5),
        16.sh,
        CustomBtn(
            text: allTranslations.text(LocaleKeys.save),
            onPressed: () {
              onCommentAdded.call(commentController.text);
              commentController.clear();
              CustomNavigator.pop();
            })
      ],
    );
  }
}
