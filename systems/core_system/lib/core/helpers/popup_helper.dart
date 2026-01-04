import 'package:core_system/core/utility/export.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

abstract class PopUpHelper {
  static Future<dynamic> showTopSheet({
    required BuildContext? context,
    required Widget? child,
  }) {
    return showGeneralDialog(
      context: context!,
      barrierDismissible: true,
      transitionDuration: Duration(milliseconds: 500),
      barrierLabel: MaterialLocalizations.of(context).dialogLabel,
      barrierColor: Colors.black.withValues(alpha: 0.5),
      pageBuilder: (context, anim1, anim2) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(15),
                  bottomRight: Radius.circular(15),
                ),
              ),
              child: child,
            ),
          ],
        );
      },
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        return SlideTransition(
          position: CurvedAnimation(
            parent: animation,
            curve: Curves.easeOut,
          ).drive(Tween<Offset>(begin: Offset(0, -1.0), end: Offset.zero)),
          child: child,
        );
      },
    );
  }

  static Future<dynamic> showBottomSheet({
    required Widget? child,
    double? height,
    String? header,
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
      backgroundColor: LightColor.scaffoldBg,
      builder: (context) {
        final mediaQuery = MediaQuery.of(context);
        final safeAreaBottom = mediaQuery.padding.bottom;
        final viewInsetsBottom = mediaQuery.viewInsets.bottom;
        final maxHeight = height ?? context.h * 0.8;

        return Padding(
          padding: EdgeInsets.only(bottom: safeAreaBottom + viewInsetsBottom),
          child: ConstrainedBox(
            constraints: BoxConstraints(maxHeight: maxHeight),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: context.w * 0.2,
                    height: 4.h,
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(50),
                    ),
                  ),
                  24.sh,
                  if (header != null) ...[
                    BottomSheetHeader(title: header),
                    16.sh,
                  ],
                  Flexible(child: SingleChildScrollView(child: child!)),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
