import 'package:eco_system/core/assets.gen.dart';
import 'package:eco_system/helpers/styles.dart';
import 'package:eco_system/utility/extensions.dart';
import 'package:eco_system/widgets/images.dart';
import 'package:flutter/material.dart';

class CustomCheckBoxWidget extends StatefulWidget {
  final Function(bool) onCheck;

  const CustomCheckBoxWidget({super.key, required this.onCheck});

  @override
  State<CustomCheckBoxWidget> createState() => _CustomCheckBoxWidgetState();
}

class _CustomCheckBoxWidgetState extends State<CustomCheckBoxWidget> {
  bool isTalentSelected = false;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        setState(() {
          isTalentSelected = !isTalentSelected;
          widget.onCheck(isTalentSelected);
        });
      },
      child: Container(
        padding: EdgeInsets.all(2),
        width: 14.w,
        height: 14.w,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(2),
          border: Border.all(color: Styles.PRIMARY_COLOR),
          color: isTalentSelected ? Styles.PRIMARY_COLOR : Styles.WHITE_COLOR,
        ),
        child: isTalentSelected
            ? Images(image: Assets.svgs.check.path)
            : const SizedBox.shrink(),
      ),
    );
  }
}
