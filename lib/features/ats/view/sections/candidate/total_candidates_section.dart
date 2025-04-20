import 'package:eco_system/helpers/styles.dart';
import 'package:eco_system/helpers/text_styles.dart';
import 'package:eco_system/helpers/translation/all_translation.dart';
import 'package:eco_system/navigation/custom_navigation.dart';
import 'package:eco_system/navigation/routes.dart';
import 'package:eco_system/utility/extensions.dart';
import 'package:flutter/material.dart';

class TotalCandidatesSection extends StatelessWidget {
  const TotalCandidatesSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              allTranslations.text('total_candidates'),
              style: AppTextStyles.w400
                  .copyWith(fontSize: 12, color: Styles.DETAILS),
            ),
            4.sh,
            Text(
              '103',
              style: AppTextStyles.w700.copyWith(fontSize: 14),
            ),
          ],
        ),
        InkWell(
          onTap: () => CustomNavigator.push(Routes.TALENT_POOL),
          child: Stack(
            textDirection: TextDirection.ltr,
            children: List.generate(
                5,
                (index) => Container(
                      width: 32.w,
                      height: 32.h,
                      margin: index == 0
                          ? EdgeInsets.only(left: 0)
                          : EdgeInsets.only(left: index * 17.w),
                      decoration: BoxDecoration(
                          color: Styles.PRIMARY_COLOR,
                          shape: BoxShape.circle,
                          border: Border.all(color: Styles.WHITE_COLOR),
                          image: DecorationImage(
                              image: AssetImage('assets/images/avatar.png'),
                              fit: BoxFit.contain)),
                      child: index == 4
                          ? Container(
                              width: 32.w,
                              height: 32.h,
                              decoration: BoxDecoration(
                                  color: Colors.black.withValues(alpha: 0.5),
                                  shape: BoxShape.circle),
                              child: Center(
                                child: Text(
                                  '+5',
                                  style: AppTextStyles.w400
                                      .copyWith(color: Styles.WHITE_COLOR),
                                ),
                              ),
                            )
                          : const SizedBox.shrink(),
                    )),
          ),
        ),
      ],
    );
  }
}
