import 'package:eco_system/core/assets.gen.dart';
import 'package:eco_system/helpers/styles.dart';
import 'package:eco_system/helpers/text_styles.dart';
import 'package:eco_system/utility/extensions.dart';
import 'package:eco_system/widgets/images.dart';
import 'package:eco_system/widgets/percentage_avatar.dart';
import 'package:flutter/material.dart';

class CandidateCompatibilitySection extends StatelessWidget {
  const CandidateCompatibilitySection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: context.w,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      decoration: BoxDecoration(
          color: Styles.WHITE_COLOR,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Styles.BORDER)),
      child: Row(
        children: [
          PercentageAvatar(
            avatarPath: Assets.images.avatar.path,
            percentage: '80',
            avatarSize: 32.w,
            percentageMargin: 4.w,
            percentageRadius: 2.w,
            percentageTextStyle: AppTextStyles.w600
                .copyWith(color: Styles.TEXT_BLUE_DARK_COLOR, fontSize: 6),
          ),
          12.sw,
          Text(
            'ما مدي التوافق بين هشام وهذة الوظيفة؟',
            style: AppTextStyles.w400
                .copyWith(color: Styles.TEXT_COLOR, fontSize: 10),
          ),
          const Spacer(),
          Images(image: Assets.svgs.arrowLeft.path),
        ],
      ),
    );
  }
}
