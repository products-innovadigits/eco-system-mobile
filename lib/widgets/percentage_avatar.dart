import 'package:eco_system/helpers/styles.dart';
import 'package:eco_system/helpers/text_styles.dart';
import 'package:eco_system/utility/extensions.dart';
import 'package:flutter/material.dart';

class PercentageAvatar extends StatelessWidget {
  final String avatarPath;
  final String percentage;
  final double avatarSize;
  final double? stackHeight;
  final double? percentageMargin;
  final double? percentageRadius;
  final TextStyle? percentageTextStyle;
  final bool? withPercentage;

  const PercentageAvatar(
      {super.key,
      required this.avatarPath,
      required this.percentage,
      required this.avatarSize,
      this.stackHeight,
      this.percentageTextStyle,
      this.percentageMargin,
      this.percentageRadius,
      this.withPercentage = true});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: stackHeight ?? avatarSize,
      child: Stack(
        children: [
          Container(
            width: avatarSize,
            height: avatarSize,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Styles.PRIMARY_COLOR, width: 3),
              image: DecorationImage(
                  image: AssetImage(avatarPath), fit: BoxFit.fill),
            ),
          ),
          if (withPercentage == true)
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
                margin:
                    EdgeInsets.symmetric(horizontal: percentageMargin ?? 8.w),
                decoration: BoxDecoration(
                    borderRadius:
                        BorderRadius.circular(percentageRadius ?? 16.w),
                    color: Styles.WHITE_COLOR),
                child: Center(
                  child: Text(
                    '$percentage%',
                    style: percentageTextStyle ??
                        AppTextStyles.w600.copyWith(
                            color: Styles.PRIMARY_COLOR, fontSize: 10),
                  ),
                ),
              ),
            )
        ],
      ),
    );
  }
}
