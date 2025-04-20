import 'package:eco_system/helpers/translation/all_translation.dart';
import 'package:eco_system/utility/extensions.dart';
import 'package:eco_system/widgets/images.dart';
import 'package:flutter/material.dart';

class NavAppItem extends StatelessWidget {
  final String title;
  final bool isSelected;
  final Color color;
  final String icon;
  final String activeIcon;

  const NavAppItem(
      {super.key,
      required this.title,
      required this.isSelected,
      required this.icon,
      required this.color,
      required this.activeIcon});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 20.h,
        ),
        Images(
          image: isSelected
              ? 'assets/svgs/$activeIcon.svg'
              : 'assets/svgs/$icon.svg',
          color: color,
        ),
        SizedBox(height: 2.h),
        Text(
          allTranslations.text(title),
          style: TextStyle(
            color: color,
            fontSize: 11,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 10.h),
        isSelected
            ? Images(
                image: 'assets/svgs/navbar-arrow.svg',
                color: context.theme.primaryColor,
              )
            : SizedBox.shrink(),
      ],
    );
  }
}
