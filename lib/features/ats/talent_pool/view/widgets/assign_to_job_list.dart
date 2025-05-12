import 'package:eco_system/features/ats/talent_pool/view/widgets/status_widget.dart';
import 'package:eco_system/helpers/styles.dart';
import 'package:eco_system/helpers/text_styles.dart';
import 'package:eco_system/utility/extensions.dart';
import 'package:eco_system/widgets/custom_check_box_widget.dart';
import 'package:flutter/material.dart';

class AssignToJobList extends StatelessWidget {
  const AssignToJobList({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: context.h * 0.6,
      child: ListView.separated(
        itemBuilder: (context, index) => Container(
          width: context.w,
          decoration: BoxDecoration(
              color: Styles.WHITE_COLOR,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Styles.BORDER)),
          child: Column(
            children: [
              StatusWidget(),
              Padding(
                padding: EdgeInsetsDirectional.only(start: 12.w, bottom: 24.h),
                child: Row(
                  children: [
                    CustomCheckBoxWidget(onCheck: (val) {}),
                    8.sw,
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'قائد فريق  تصميم المنتجات',
                          style: AppTextStyles.w500
                              .copyWith(color: Styles.TEXT_COLOR),
                        ),
                        4.sh,
                        Text(
                          'دوام كامل . مصر . تصميم',
                          style: AppTextStyles.w400.copyWith(
                              color: Styles.SUB_TEXT_DARK_COLOR, fontSize: 10),
                        ),
                      ],
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
        separatorBuilder: (context, index) => 12.sh,
        itemCount: 12,
      ),
    );
  }
}
