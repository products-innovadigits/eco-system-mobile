import 'package:eco_system/core/assets.gen.dart';
import 'package:eco_system/helpers/styles.dart';
import 'package:eco_system/helpers/text_styles.dart';
import 'package:eco_system/utility/extensions.dart';
import 'package:eco_system/widgets/images.dart';
import 'package:flutter/material.dart';

class CompatibilityPercentageWidget extends StatelessWidget {
  final String title;
  final double percentage;

  const CompatibilityPercentageWidget(
      {super.key, required this.title, required this.percentage});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
      decoration: BoxDecoration(
          color: Styles.PRIMARY_COLOR.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8)),
      child: Row(
        children: [
          Images(image: Assets.svgs.percentageCircle.path),
          8.sw,
          Text('$title : ',
              textDirection: TextDirection.rtl,
              style: AppTextStyles.w400.copyWith(color: Styles.TEXT_COLOR)),
          2.sw,
          Text('%${percentage.toInt()}',
              style: AppTextStyles.w800.copyWith(color: Styles.PRIMARY_COLOR)),
        ],
      ),
    );
  }
}
