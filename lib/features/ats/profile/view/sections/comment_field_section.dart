import 'package:eco_system/components/custom_text_field.dart';
import 'package:eco_system/core/app_state.dart';
import 'package:eco_system/core/app_strings/locale_keys.dart';
import 'package:eco_system/core/assets.gen.dart';
import 'package:eco_system/features/ats/profile/bloc/profile_bloc.dart';
import 'package:eco_system/helpers/styles.dart';
import 'package:eco_system/helpers/text_styles.dart';
import 'package:eco_system/helpers/translation/all_translation.dart';
import 'package:eco_system/utility/extensions.dart';
import 'package:eco_system/widgets/images.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CommentFieldSection extends StatelessWidget {
  final bool isVisible;
  final TextEditingController controller;
  final String comment;
  final Function(String) onSend;
  final VoidCallback onToggle;

  const CommentFieldSection({
    super.key,
    required this.isVisible,
    required this.controller,
    required this.comment,
    required this.onSend,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    if (!isVisible) {
      if (comment.isNotEmpty) {
        return Row(
          children: [
            Text('${allTranslations.text(LocaleKeys.comment)}:',
                style: AppTextStyles.w600
                    .copyWith(fontSize: 10, color: Styles.PRIMARY_COLOR)),
            4.sw,
            Text(comment,
                style: AppTextStyles.w400
                    .copyWith(fontSize: 10, color: Styles.SUB_TEXT_DARK_COLOR)),
            4.sw,
            InkWell(
                onTap: () {
                  controller.text = comment;
                  onToggle();
                },
                child: Images(image: Assets.svgs.editOutline.path)),
          ],
        );
      }
      return InkWell(
        onTap: onToggle,
        child: Row(
          children: [
            Images(image: Assets.svgs.addCircle.path),
            8.sw,
            Text(allTranslations.text(LocaleKeys.add_comment),
                style: AppTextStyles.w400
                    .copyWith(fontSize: 12, color: Styles.PRIMARY_COLOR)),
          ],
        ),
      );
    }

    return CustomTextField(
      hint: allTranslations.text(LocaleKeys.add_comment),
      maxLines: 3,
      controller: controller,
      maxSuffixIconHeight: 70.h,
      suffixWidget: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          InkWell(
            onTap: () => onSend(controller.text),
            child: Padding(
              padding: EdgeInsetsDirectional.symmetric(horizontal: 8.w),
              child: Align(
                alignment: AlignmentDirectional.bottomEnd,
                child: Images(
                    image: Assets.svgs.send.path, height: 20.h, width: 20.w),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
