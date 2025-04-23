import 'package:eco_system/helpers/styles.dart';
import 'package:eco_system/helpers/text_styles.dart';
import 'package:eco_system/utility/extensions.dart';
import 'package:flutter/material.dart';

class StatusWidget extends StatelessWidget {
  const StatusWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          padding: EdgeInsets.symmetric(
              horizontal: 12.w, vertical: 6.h),
          decoration: BoxDecoration(
            color:
            Styles.PRIMARY_COLOR.withValues(alpha: 0.1),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(16),
            ),
          ),
          child: Center(
              child: Text(
                'نشطة',
                style: AppTextStyles.w400.copyWith(
                    fontSize: 10, color: Styles.PRIMARY_COLOR),
              )),
        ),
      ],
    );
  }
}
