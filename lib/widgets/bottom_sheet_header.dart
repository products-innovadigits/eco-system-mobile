import 'package:eco_system/core/assets.gen.dart';
import 'package:eco_system/helpers/text_styles.dart';
import 'package:eco_system/helpers/translation/all_translation.dart';
import 'package:eco_system/navigation/custom_navigation.dart';
import 'package:eco_system/widgets/images.dart';
import 'package:flutter/material.dart';

class BottomSheetHeader extends StatelessWidget {
  final String title;

  const BottomSheetHeader({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          allTranslations.text(title),
          style: AppTextStyles.w700.copyWith(fontSize: 16),
        ),
        const Spacer(),
        GestureDetector(
            onTap: () => CustomNavigator.pop(),
            child: Images(image: Assets.svgs.closeSquare.path)),
      ],
    );
  }
}
