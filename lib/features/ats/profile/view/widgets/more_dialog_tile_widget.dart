import 'package:eco_system/core/app_event.dart';
import 'package:eco_system/features/ats/profile/bloc/profile_bloc.dart';
import 'package:eco_system/helpers/styles.dart';
import 'package:eco_system/helpers/text_styles.dart';
import 'package:eco_system/helpers/translation/all_translation.dart';
import 'package:eco_system/utility/extensions.dart';
import 'package:eco_system/widgets/images.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MoreDialogTileWidget extends StatelessWidget {
  final String title;
  final String iconPath;
  final VoidCallback onTap;

  const MoreDialogTileWidget(
      {super.key,
      required this.title,
      required this.iconPath,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: context.w * 0.5,
      child: InkWell(
        onTap: () {
          onTap();
          Future.microtask(() {
            context.read<ProfileBloc>().add(ShowDialog(arguments: false));
          });
        },
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
              child: Row(
                children: [
                  Images(image: iconPath),
                  8.sw,
                  Text(allTranslations.text(title),
                      style: AppTextStyles.w400.copyWith(fontSize: 12))
                ],
              ),
            ),
            Divider(color: Styles.BORDER, height: 2.h),
          ],
        ),
      ),
    );
  }
}
