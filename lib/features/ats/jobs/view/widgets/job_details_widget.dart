import 'package:eco_system/helpers/styles.dart';
import 'package:eco_system/helpers/text_styles.dart';
import 'package:eco_system/utility/extensions.dart';
import 'package:flutter/material.dart';

class JobDetailsWidget extends StatelessWidget {
  final bool? hasStatus;

  const JobDetailsWidget({super.key, this.hasStatus = false});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'قائد فريق  تصميم المنتجات',
              style: AppTextStyles.w400.copyWith(color: Styles.TEXT_COLOR),
            ),
            if (hasStatus ?? false)
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                decoration: BoxDecoration(
                  color: Colors.green.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Center(
                    child: Text(
                  'نشطة',
                  style: AppTextStyles.w400
                      .copyWith(fontSize: 10, color: Colors.green),
                )),
              )
          ],
        ),
        SizedBox(height: 8.h),
        Text(
          'دوام كامل . مصر . تصميم',
          style: AppTextStyles.w400
              .copyWith(color: Styles.SUB_TEXT_DARK_COLOR, fontSize: 10),
        ),
        Padding(
          padding: EdgeInsets.all(16.h),
          child: Divider(color: Styles.BORDER),
        ),
      ],
    );
  }
}
