import 'package:eco_system/bloc/user_bloc.dart';
import 'package:eco_system/core/app_state.dart';
import 'package:eco_system/helpers/text_styles.dart';
import 'package:eco_system/helpers/translation/all_translation.dart';
import 'package:eco_system/utility/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../helpers/styles.dart';
import '../../../widgets/profile_image_widget.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserBloc, AppState>(
      builder: (context, state) {
        return Container(
          width: context.w,
          height: context.h * 0.3,
          padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 16.h),
          decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("assets/images/home_header_bg.png"),
                  fit: BoxFit.cover)),
          child: SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          RichText(
                            text: TextSpan(
                              text: allTranslations.text(
                                  DateTime.now().format("a") == "AM"
                                      ? "morning"
                                      : "evening"),
                              style: AppTextStyles.w700.copyWith(
                                  fontSize: 24, color: Styles.WHITE_COLOR),
                              children: [
                                TextSpan(
                                  text:
                                      " ${allTranslations.text("mr/")} ${UserBloc.instance.user?.name ?? "Name"} ${DateTime.now().format("a") == "AM" ? "🌤" : "🌤"}",
                                  style: AppTextStyles.w700.copyWith(
                                      fontSize: 24, color: Styles.WHITE_COLOR),
                                )
                              ],
                            ),
                          ),
                          SizedBox(height: 4.h),
                          Text(
                            allTranslations.text("home_welcome_message"),
                            style: AppTextStyles.w400.copyWith(
                              fontSize: 16,
                              color: Color(0xffE8E9EB),
                            ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(width: 8.w),
                    ProfileImageWidget(radius: 25.w),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
