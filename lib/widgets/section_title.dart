import 'package:eco_system/helpers/translation/all_translation.dart';
import 'package:eco_system/utility/extensions.dart';
import 'package:eco_system/widgets/images.dart';
import 'package:flutter/material.dart';

import '../components/shimmer/custom_shimmer.dart';
import '../helpers/styles.dart';
import '../helpers/text_styles.dart';

class SectionTitle extends StatelessWidget {
  const SectionTitle({
    super.key,
    required this.title,
    this.withView = false,
    this.subText,
    this.onViewTap,
    this.icon,
  });

  final String title;
  final String? subText;
  final String? icon;
  final bool withView;
  final Function()? onViewTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          if (icon != null) ...[
            Images(image: icon!),
            16.sw,
          ],
          Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: AppTextStyles.w700.copyWith(fontSize: 14),
              ),
              if (subText != null)
                Padding(
                  padding: EdgeInsets.only(top: 4.h),
                  child: Text(
                    subText!,
                    style: AppTextStyles.w400
                        .copyWith(fontSize: 11, color: Styles.DETAILS),
                  ),
                ),
            ],
          )),
          if (withView)
            InkWell(
              onTap: onViewTap,
              child: Row(
                children: [
                  Text(
                    "${allTranslations.text("view_more")}  ",
                    style: AppTextStyles.w500
                        .copyWith(fontSize: 11, color: Styles.PRIMARY_COLOR),
                  ),
                  // Icon(Icons.arrow_forward_rounded,
                  //     size: 16, color: Styles.PRIMARY_COLOR)
                ],
              ),
            )
        ],
      ),
    );
  }
}

class SectionTitleShimmer extends StatelessWidget {
  const SectionTitleShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CustomShimmerText(width: 100),
          CustomShimmerText(width: 70),
        ],
      ),
    );
  }
}
