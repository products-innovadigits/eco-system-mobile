import 'package:eco_system/helpers/text_styles.dart';
import 'package:eco_system/helpers/translation/all_translation.dart';
import 'package:eco_system/utility/extensions.dart';
import 'package:flutter/material.dart';
import '../../../helpers/styles.dart';
import '../../../widgets/images.dart';

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
                child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(8.w),
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Styles.PRIMARY_COLOR.withOpacity(0.1)),
                  child: Images(
                      image: "assets/svgs/calendar.svg",
                      width: 16.w,
                      height: 16.w,
                      color: Styles.PRIMARY_COLOR),
                ),
                SizedBox(width: 8.w),
                Column(
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
                      (startDate ?? DateTime.now()).format("d MMM yyyy"),
                      textAlign: TextAlign.start,
                      style: AppTextStyles.w400
                          .copyWith(fontSize: 14, color: Styles.HEADER),
                    ),
                  ],
                ),
              ],
            )),
            Expanded(
                child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(8.w),
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Styles.PRIMARY_COLOR.withOpacity(0.1)),
                  child: Images(
                      image: "assets/svgs/calendar_tick.svg",
                      width: 16.w,
                      height: 16.w,
                      color: Styles.PRIMARY_COLOR),
                ),
                SizedBox(width: 8.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        allTranslations.text("end_date"),
                        textAlign: TextAlign.end,
                        style: AppTextStyles.w400.copyWith(
                            fontSize: 12, color: Styles.PRIMARY_COLOR),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        (endDate ?? DateTime.now()).format("d MMM yyyy"),
                        textAlign: TextAlign.end,
                        style: AppTextStyles.w400
                            .copyWith(fontSize: 14, color: Styles.HEADER),
                      ),
                    ],
                  ),
                ),
              ],
            ))
          ],
        )
      ],
    );
  }
}
