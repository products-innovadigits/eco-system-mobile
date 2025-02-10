import 'package:eco_system/bloc/main_app_bloc.dart';
import 'package:eco_system/helpers/text_styles.dart';
import 'package:eco_system/utility/extensions.dart';
import 'package:eco_system/widgets/images.dart';
import 'package:flutter/material.dart';
import 'package:eco_system/components/custom_arrow_back.dart';
import 'package:eco_system/helpers/media_query_helper.dart';
import 'package:eco_system/helpers/styles.dart';
import 'package:eco_system/navigation/custom_navigation.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final Widget? action;
  const CustomAppBar({
    super.key,
    required this.title,
    this.action,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 18.h),
      decoration: BoxDecoration(
          color: Styles.WHITE_COLOR,
          border: Border(bottom: BorderSide(color: Styles.BORDER_COLOR))),
      child: SafeArea(
        bottom: false,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            InkWell(
                onTap: () => CustomNavigator.pop(),
                child: RotatedBox(
                  quarterTurns: mainAppBloc.lang.valueOrNull == "en" ? 2 : 0,
                  child: Images(
                    image: "assets/svgs/arrow_back.svg",
                    color: Styles.HEADER,
                    width: 24.w,
                    height: 24.h,
                  ),
                )),
            Expanded(
              child: Text(
                title ?? "",
                style: AppTextStyles.w700.copyWith(
                  fontSize: 18,
                  color: Styles.HEADER,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            action ?? SizedBox()
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize =>
      Size(CustomNavigator.navigatorState.currentContext!.w, 100);
}
