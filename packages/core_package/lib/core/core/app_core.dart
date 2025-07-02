import 'package:core_package/core/utility/export.dart';

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
          elevation: 1000,
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

  static showToastSnackBar({required AppNotification notification}) {
    Fluttertoast.showToast(
        msg: notification.message,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: notification.backgroundColor,
        textColor: Colors.white,
        fontSize: notification.fontSize);
  }

  static successMessage(message) => AppCore.showSnackBar(
        notification: AppNotification(
            message: message,
            backgroundColor: Styles.ACTIVE,
            borderColor: Styles.GREEN4,
            iconName: 'check-circle'),
      );

  static warningExitMessage(message) => AppCore.showToastSnackBar(
        notification: AppNotification(
            message: message, backgroundColor: Styles.DETAILS, fontSize: 16),
      );

  static successToastMessage(message) => AppCore.showToastSnackBar(
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

  static errorToastMessage(message) => AppCore.showToastSnackBar(
        notification: AppNotification(
          message: message,
          backgroundColor: Styles.IN_ACTIVE,
          borderColor: Styles.DARK_RED,
          iconName: 'fill-close-circle',
        ),
      );

  static String getMonthName(int monthNumber) {
    List<String> months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];

    if (monthNumber < 1 || monthNumber > 12) {
      return 'Invalid Month';
    }

    return months[monthNumber - 1];
  }
}
