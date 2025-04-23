import 'package:eco_system/helpers/styles.dart';
import 'package:eco_system/helpers/text_styles.dart';
import 'package:eco_system/utility/extensions.dart';
import 'package:flutter/material.dart';

class CandidateInfoCardWidget extends StatelessWidget {
  final bool? isPrimaryColor;
  final String title;
  final String value;

  const CandidateInfoCardWidget(
      {super.key,
      this.isPrimaryColor = true,
      required this.title,
      required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: (isPrimaryColor ?? true)
              ? Styles.PRIMARY_COLOR.withValues(alpha: 0.1)
              : Styles.DARK_BLUE.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12)),
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(value,
                style: AppTextStyles.w700.copyWith(
                    color: (isPrimaryColor ?? true)
                        ? Styles.PRIMARY_COLOR
                        : Styles.DARK_BLUE , fontSize: 16)),
            4.sh,
            Text(title,
                style: AppTextStyles.w600
                    .copyWith(color: Styles.SUB_TEXT_DARK_COLOR, fontSize: 10)),
          ],
        ),
      ),
    );
  }
}
