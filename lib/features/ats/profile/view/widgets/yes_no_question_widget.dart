import 'package:eco_system/core/assets.gen.dart';
import 'package:eco_system/helpers/text_styles.dart';
import 'package:eco_system/utility/extensions.dart';
import 'package:eco_system/widgets/images.dart';
import 'package:flutter/material.dart';

class YesNoQuestionWidget extends StatelessWidget {
  final String question;
  final bool isCorrect;

  const YesNoQuestionWidget(
      {super.key, required this.question, required this.isCorrect});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 14.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Color(0xffE6F5F4).withValues(alpha: 0.4),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(question, style: AppTextStyles.w400.copyWith(fontSize: 11)),
          Images(
              image: isCorrect
                  ? Assets.svgs.correct.path
                  : Assets.svgs.wrong.path),
        ],
      ),
    );
  }
}
