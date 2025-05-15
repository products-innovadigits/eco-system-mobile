import 'package:eco_system/core/assets.gen.dart';
import 'package:eco_system/helpers/styles.dart';
import 'package:eco_system/helpers/text_styles.dart';
import 'package:eco_system/utility/extensions.dart';
import 'package:flutter/material.dart';

class FollowUpManagerDetailsSection extends StatelessWidget {
  const FollowUpManagerDetailsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 32.w,
          height: 32.w,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: Styles.BORDER, width: 2),
            image: DecorationImage(
                image: AssetImage(Assets.images.avatar.path),
                fit: BoxFit.fill),
          ),
        ),
        8.sw,
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'اسلام محمد',
              style: AppTextStyles.w600
                  .copyWith(color: Styles.TEXT_COLOR, fontSize: 12),
            ),
            2.sh,
            Row(
              children: [
                Text(
                  '1 August 2023 . ',
                  style: AppTextStyles.w400.copyWith(
                      color: Styles.SUB_TEXT_DARK_COLOR, fontSize: 9),
                ),
                Text('12:00 Am',
                    style: AppTextStyles.w400.copyWith(
                        color: Styles.SUB_TEXT_DARK_COLOR, fontSize: 9))
              ],
            ),
          ],
        ),
      ],
    );
  }
}
