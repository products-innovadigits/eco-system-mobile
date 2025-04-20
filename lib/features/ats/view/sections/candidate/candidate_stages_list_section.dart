import 'package:eco_system/core/assets.gen.dart';
import 'package:eco_system/helpers/styles.dart';
import 'package:eco_system/helpers/text_styles.dart';
import 'package:eco_system/navigation/custom_navigation.dart';
import 'package:eco_system/navigation/routes.dart';
import 'package:eco_system/utility/extensions.dart';
import 'package:eco_system/widgets/images.dart';
import 'package:flutter/material.dart';

class CandidateStagesListSection extends StatelessWidget {
  const CandidateStagesListSection({super.key});

  @override
  Widget build(BuildContext context) {
    final Map<String, GlobalKey> stageKeys = {
      'المرحلة التطبيقية': GlobalKey(),
      'مرحلة المقابلة الهاتفية': GlobalKey(),
      'مرحلة التقييم': GlobalKey(),
      'مرحلة المقابلة': GlobalKey(),
      'مرحلة العرض': GlobalKey(),
      'مرحلة التوظيف': GlobalKey(),
    };
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        12.sh,
        ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) => InkWell(
                  onTap: () => CustomNavigator.push(Routes.CANDIDATES,
                      arguments: stageKeys.keys.elementAt(index)),
                  child: Row(
                    children: [
                      Icon(Icons.circle, size: 10, color: Styles.PRIMARY_COLOR),
                      SizedBox(width: 8.w),
                      Text(
                        stageKeys.keys.elementAt(index),
                        style: AppTextStyles.w400.copyWith(fontSize: 10),
                      ),
                      const Spacer(),
                      Images(image: Assets.svgs.arrowLeft.path, width: 7),
                    ],
                  ),
                ),
            separatorBuilder: (context, index) => 16.sh,
            itemCount: 6)
      ],
    );
  }
}
