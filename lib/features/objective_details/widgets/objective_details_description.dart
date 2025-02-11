import 'package:eco_system/helpers/text_styles.dart';
import 'package:eco_system/helpers/translation/all_translation.dart';
import 'package:eco_system/utility/extensions.dart';
import 'package:flutter/material.dart';
import '../../../helpers/styles.dart';

class ObjectiveDetailsDescription extends StatelessWidget {
  const ObjectiveDetailsDescription(
      {super.key, this.description, this.startDate, required this.endDate});
  final String? description;
  final DateTime? startDate, endDate;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          description ?? "",
          textAlign: TextAlign.center,
          style:
              AppTextStyles.w400.copyWith(fontSize: 12, color: Styles.HEADER),
        ),
        SizedBox(height: 16.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  allTranslations.text("start_date"),
                  textAlign: TextAlign.start,
                  style: AppTextStyles.w400
                      .copyWith(fontSize: 12, color: Styles.PRIMARY_COLOR),
                ),
                SizedBox(height: 4.h),
                Text(
                  (startDate ?? DateTime.now()).format("d/MMM/yyyy"),
                  textAlign: TextAlign.start,
                  style: AppTextStyles.w400
                      .copyWith(fontSize: 14, color: Styles.HEADER),
                ),
              ],
            )),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.w),
              child: Text(
                "------",
                textAlign: TextAlign.start,
                style: AppTextStyles.w400
                    .copyWith(fontSize: 12, color: Styles.PRIMARY_COLOR),
              ),
            ),
            Expanded(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  allTranslations.text("end_date"),
                  textAlign: TextAlign.end,
                  style: AppTextStyles.w400
                      .copyWith(fontSize: 12, color: Styles.PRIMARY_COLOR),
                ),
                SizedBox(height: 4.h),
                Text(
                  (endDate ?? DateTime.now()).format("d/MMM/yyyy"),
                  textAlign: TextAlign.end,
                  style: AppTextStyles.w400
                      .copyWith(fontSize: 14, color: Styles.HEADER),
                ),
              ],
            ))
          ],
        )
      ],
    );
  }
}
