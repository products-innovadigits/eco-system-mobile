import 'package:eco_system/core/assets.gen.dart';
import 'package:eco_system/helpers/styles.dart';
import 'package:eco_system/helpers/text_styles.dart';
import 'package:eco_system/utility/extensions.dart';
import 'package:eco_system/widgets/images.dart';
import 'package:flutter/material.dart';

class CandidateCardWidget extends StatelessWidget {
  const CandidateCardWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: context.w,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      decoration: BoxDecoration(
          color: Styles.WHITE_COLOR,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Styles.BORDER)),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 35.h,
                child: Stack(
                  children: [
                    Container(
                      width: 32.w,
                      height: 32.h,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                            color: Styles.PRIMARY_COLOR, width: 2),
                        image: DecorationImage(
                            image:
                            AssetImage(Assets.images.avatar.path),
                            fit: BoxFit.contain),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 6.w,
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 4.w, vertical: 2.h),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(2),
                            color: Styles.WHITE_COLOR),
                        child: Center(
                          child: Text(
                            '10%',
                            style: AppTextStyles.w600.copyWith(
                                color: Styles.TEXT_BLUE_DARK_COLOR,
                                fontSize: 6),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              8.sw,
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'هشام منصور',
                    style: AppTextStyles.w500.copyWith(
                        color: Styles.TEXT_COLOR, fontSize: 12),
                  ),
                  2.sh,
                  Row(
                    children: [
                      Text(
                        'مدير المشروعات . ',
                        style: AppTextStyles.w400.copyWith(
                            color: Styles.SUB_TEXT_DARK_COLOR, fontSize: 10),
                      ),
                      Text('5 من الوظائف',
                          style: AppTextStyles.w400
                              .copyWith(color: Styles.PRIMARY_COLOR, fontSize: 10))
                    ],
                  ),
                ],
              ),
              const Spacer(),
              Images(image: Assets.svgs.arrowLeft.path),
            ],
          ),
          Padding(
            padding: EdgeInsets.all(12.h),
            child: Divider(color: Styles.BORDER),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                'السعودية',
                style: AppTextStyles.w500.copyWith(
                    color: Styles.SUB_TEXT_DARK_COLOR, fontSize: 10),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.w),
                child: Icon(Icons.circle,
                    color: Styles.SUB_TEXT_DARK_COLOR, size: 5),
              ),
              Text(
                'قدم طلب منذ 3 اشهر',
                style: AppTextStyles.w500.copyWith(
                    color: Styles.SUB_TEXT_DARK_COLOR, fontSize: 10),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
