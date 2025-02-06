import 'package:flutter/material.dart';
import 'package:eco_system/navigation/custom_navigation.dart';

class CustomSimpleDialog {
  static parentSimpleDialog({
    required List<Widget>? customListWidget,
  }) {
    return showGeneralDialog(
        barrierColor: Colors.black.withOpacity(0.5),
        transitionBuilder: (context, a1, a2, widget) {
          return Transform.scale(
            scale: a1.value,
            child: Opacity(
                opacity: a1.value,
                child: SimpleDialog(
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(
                    Radius.circular(10),
                  )),
                  elevation: 3,
                  contentPadding: const EdgeInsets.all(5),
                  children: customListWidget!,
                )),
          );
        },
        transitionDuration: const Duration(milliseconds: 300),
        barrierDismissible: true,
        barrierLabel: '',
        context: CustomNavigator.navigatorState.currentContext!,
        // ignore: missing_return
        pageBuilder: (context, animation1, animation2) {
          return Container();
        });
  }
}
