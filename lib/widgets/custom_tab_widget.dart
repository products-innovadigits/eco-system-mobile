import 'package:eco_system/helpers/styles.dart';
import 'package:eco_system/helpers/translation/all_translation.dart';
import 'package:flutter/material.dart';

class CustomTabWidget extends StatelessWidget {
  final String title;
  final bool isSelected;
  final VoidCallback onTap;

  const CustomTabWidget(
      {super.key,
      required this.title,
      required this.isSelected,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Styles.WHITE_COLOR,
            border: Border(
                bottom: BorderSide(
                    color: isSelected ? Styles.PRIMARY_COLOR : Styles.BORDER,
                    width: 2)),
          ),
          child: Text(
            allTranslations.text(title),
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                color: isSelected ? Styles.PRIMARY_COLOR : Styles.SUB_TEXT_DARK_COLOR),
          ),
        ),
      ),
    );
  }
}
