import 'dart:async';
import 'package:flutter/material.dart';
import 'package:eco_system/navigation/custom_navigation.dart';
import 'package:eco_system/utility/utility.dart';
import '../components/custom_images.dart';
import '../helpers/styles.dart';
import '../helpers/text_styles.dart';
import 'app_notification.dart';

class AppCore {
  static AppCore? _instance;

  AppCore._initial();

  factory AppCore() {
    _instance ??= AppCore._initial();
    return _instance!;
  }

  static bool scrollListener(
      ScrollController controller, int maxPage, int currentPage) {
    double maxScroll = controller.position.maxScrollExtent;
    double currentScroll = controller.position.pixels;
    if (maxScroll == currentScroll && maxScroll != 0.0) {
      cprint(">>>>>>>>>>>>>>> get into equal scroll");
      cprint('$maxScroll   $currentScroll');
      if (currentPage < maxPage) {
        return true;
      } else {
        return false;
      }
    }
    return false;
  }

  static showSnackBar({required AppNotification notification}) {
    Timer(const Duration(milliseconds: 200), () {
      CustomNavigator.scaffoldState.currentState!.showSnackBar(
        SnackBar(
          behavior: notification.isFloating
              ? SnackBarBehavior.floating
              : SnackBarBehavior.fixed,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(notification.radius),
              side: BorderSide(width: 1, color: notification.borderColor)),
          margin: notification.isFloating ? const EdgeInsets.all(24) : null,
          content: SizedBox(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  if (notification.iconName != null)
                    customImageIconSVG(
                        imageName: notification.iconName, color: Colors.white),
                  if (notification.iconName != null) const SizedBox(width: 8),
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


  static successMessage(message) => AppCore.showSnackBar(
    notification: AppNotification(
        message: message,
        backgroundColor: Styles.ACTIVE,
        borderColor: Styles.GREEN4,
        iconName: 'check-circle'),
  );

  static errorMessage(message) => AppCore.showSnackBar(
    notification: AppNotification(
      message: message,
      backgroundColor: Styles.IN_ACTIVE,
      borderColor: Styles.DARK_RED,
      iconName: 'fill-close-circle',
    ),
  );

}
