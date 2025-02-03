import 'dart:async';

import 'package:flutter/material.dart';
import 'package:eco_system/components/empty_container.dart';
import 'package:eco_system/helpers/styles.dart';
import 'package:eco_system/helpers/translation/all_translation.dart';
import 'package:eco_system/main_widgets/normal_app_bar.dart';
import 'package:eco_system/navigation/custom_navigation.dart';
import 'dart:typed_data';


import '../components/custom_images.dart';
import '../helpers/text_styles.dart';
import 'app_notification.dart';

class AppCore {
  static AppCore? _instance;

  AppCore._initial();

  factory AppCore() {
    if (_instance == null) {
      _instance = AppCore._initial();
    }
    return _instance!;
  }

  static bool scrollListener(
      ScrollController controller, int maxPage, int currentPage) {
    double maxScroll = controller.position.maxScrollExtent;
    double currentScroll = controller.position.pixels;
    if (maxScroll == currentScroll && maxScroll != 0.0) {
      print(">>>>>>>>>>>>>>> get into equal scroll");
      print('$maxScroll   $currentScroll');
      if (currentPage < maxPage) {
        return true;
      } else {
        return false;
      }
    }
    return false;
  }

  static showSnackBar({required AppNotification notification}) {
    Timer(Duration(milliseconds: 200), () {
      CustomNavigator.scaffoldState.currentState!.showSnackBar(
        SnackBar(
          behavior: notification.isFloating
              ? SnackBarBehavior.floating
              : SnackBarBehavior.fixed,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(notification.radius),
              side: BorderSide(width: 1, color: notification.borderColor)),
          margin: notification.isFloating ? EdgeInsets.all(24) : null,
          content: SizedBox(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  if (notification.iconName != null)
                    customImageIconSVG(
                        imageName: notification.iconName, color: Colors.white),
                  if (notification.iconName != null) SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      notification.message,
                      style: AppTextStyles.w600.copyWith(fontSize: 13),
                    ),
                  ),
                ],
              ),
            ),
          ),
          backgroundColor: notification.backgroundColor,
        ),
      );
    });
  }









}
