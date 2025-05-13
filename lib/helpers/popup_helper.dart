import 'package:eco_system/components/animated_widget.dart';
import 'package:eco_system/navigation/custom_navigation.dart';
import 'package:eco_system/utility/extensions.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

abstract class PopUpHelper {
  static showTopSheet(
      {@required BuildContext? context, @required Widget? child}) {
    return showGeneralDialog(
      context: context!,
      barrierDismissible: true,
      transitionDuration: Duration(milliseconds: 500),
      barrierLabel: MaterialLocalizations.of(context).dialogLabel,
      barrierColor: Colors.black.withOpacity(0.5),
      pageBuilder: (context, _, __) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Card(
              child: child,
              elevation: 2,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(15),
                      bottomRight: Radius.circular(15))),
            ),
          ],
        );
      },
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        return SlideTransition(
          position: CurvedAnimation(
            parent: animation,
            curve: Curves.easeOut,
          ).drive(
            Tween<Offset>(
              begin: Offset(0, -1.0),
              end: Offset.zero,
            ),
          ),
          child: child,
        );
      },
    );
  }

  static showBottomSheet({
    @required Widget? child,
    double? height,
  }) {
    return showMaterialModalBottomSheet(
      elevation: 2,
      enableDrag: true,
      clipBehavior: Clip.antiAlias,
      context: CustomNavigator.navigatorState.currentContext!,
      expand: false,
      useRootNavigator: true,
      isDismissible: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(15),
          topLeft: Radius.circular(15),
        ),
      ),
      backgroundColor: Colors.white,
      // isScrollControlled: true,
      builder: (context) {
        return Padding(
          padding: MediaQuery.of(CustomNavigator.navigatorState.currentContext!)
              .viewInsets,
          child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
              constraints:
                  height != null ? BoxConstraints(maxHeight: height) : null,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: context.w * 0.2,
                    height: 5.h,
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(50),
                    ),
                  ),
                  24.sh,
                  Flexible(
                    child: ListAnimator(
                      controller: ScrollController(),
                      data: [child!],
                    ),
                  ),
                ],
              )),
        );
      },
    );
  }
}
