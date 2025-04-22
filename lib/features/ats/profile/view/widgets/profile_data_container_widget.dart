import 'package:eco_system/helpers/styles.dart';
import 'package:eco_system/helpers/text_styles.dart';
import 'package:eco_system/utility/extensions.dart';
import 'package:eco_system/widgets/images.dart';
import 'package:flutter/material.dart';

class ProfileDataContainerWidget extends StatelessWidget {
  final String title;
  final String icon;

  const ProfileDataContainerWidget(
      {super.key, required this.title, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
      decoration: BoxDecoration(
          color: Colors.transparent,
          border: Border.all(color: Styles.WHITE_COLOR),
          borderRadius: BorderRadius.circular(48)),
      child: Row(
        children: [
          Images(image: icon),
          6.sw,
          Text(
            title,
            style: AppTextStyles.w500
                .copyWith(color: Styles.WHITE_COLOR, fontSize: 10),
          ),
        ],
      ),
    );
  }
}
