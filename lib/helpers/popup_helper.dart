import 'package:eco_system/utility/extensions.dart';
import 'package:flutter/material.dart';

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

  static showBottomSheet(
      {@required BuildContext? context, @required Widget? child,
        double? height,}) {
    return showModalBottomSheet(
      context: context!,
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(15),
          topLeft: Radius.circular(15),
        ),
      ),
      backgroundColor: Colors.white,
      isScrollControlled: true,
      builder: (_) {
        return Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
            constraints: height != null
                ? BoxConstraints(maxHeight: height)
                : null,
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
                child!,
              ],
            ));
      },
    );
  }
}
