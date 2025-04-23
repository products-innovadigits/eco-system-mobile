import 'package:eco_system/core/assets.gen.dart';
import 'package:eco_system/helpers/styles.dart';
import 'package:eco_system/helpers/text_styles.dart';
import 'package:eco_system/navigation/custom_navigation.dart';
import 'package:eco_system/utility/extensions.dart';
import 'package:eco_system/widgets/images.dart';
import 'package:flutter/material.dart';

class ProfileCustomAppbarWidget extends StatelessWidget {
  final String title;

  const ProfileCustomAppbarWidget({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        GestureDetector(
            onTap: () => CustomNavigator.pop(),
            child: Images(
                image: Assets.svgs.arrowBack.path, color: Styles.WHITE_COLOR)),
        8.sw,
        Text(title,
            style: AppTextStyles.w700.copyWith(color: Styles.WHITE_COLOR)),
        const Spacer(),
        Images(image: Assets.svgs.profileMore.path, color: Styles.WHITE_COLOR),
      ],
    );
  }
}
