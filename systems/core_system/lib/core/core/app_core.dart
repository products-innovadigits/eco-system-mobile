import 'package:core_system/core/utility/export.dart';

class AppCore {
  static AppCore? _instance;

  AppCore._initial();

  factory AppCore() {
    _instance ??= AppCore._initial();
    return _instance!;
  }

  static bool scrollListener(
    ScrollController controller,
    int maxPage,
    int currentPage,
  ) {
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

  static void showSnackBar({required AppNotification notification}) {
    Timer(const Duration(milliseconds: 200), () {
      CustomNavigator.scaffoldState.currentState!.showSnackBar(
        SnackBar(
          behavior: notification.isFloating
              ? SnackBarBehavior.floating
              : SnackBarBehavior.fixed,
          elevation: 1000,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(notification.radius),
            side: BorderSide(width: 1, color: notification.borderColor),
          ),
          margin: notification.isFloating ? const EdgeInsets.all(24) : null,
          content: SizedBox(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  if (notification.iconName != null)
                    customImageIconSVG(
                      imageName: notification.iconName,
                      color: Colors.white,
                    ),
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

  static Future<bool?> showToastSnackBar({
    required AppNotification notification,
  }) {
    return Fluttertoast.showToast(
      msg: notification.message,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: notification.backgroundColor,
      textColor: Colors.white,
      fontSize: notification.fontSize,
    );
  }

  static void successMessage(String message) => AppCore.showSnackBar(
    notification: AppNotification(
      message: message,
      backgroundColor: LightColor.secondary,
      borderColor: LightColor.secondary,
      iconName: 'check-circle',
    ),
  );

  static Future<bool?> warningExitMessage(String message) =>
      AppCore.showToastSnackBar(
        notification: AppNotification(
          message: message,
          backgroundColor: LightColor.placeHolderText,
          fontSize: 16,
        ),
      );

  static Future<bool?> successToastMessage(String message) =>
      AppCore.showToastSnackBar(
        notification: AppNotification(
          message: message,
          backgroundColor: LightColor.secondary,
          borderColor: LightColor.secondary,
          iconName: 'check-circle',
        ),
      );

  static void errorMessage(String message) => AppCore.showSnackBar(
    notification: AppNotification(
      message: message,
      backgroundColor: LightColor.error,
      borderColor: LightColor.error,
      iconName: 'fill-close-circle',
    ),
  );

  static Future<bool?> errorToastMessage(String message) =>
      AppCore.showToastSnackBar(
        notification: AppNotification(
          message: message,
          backgroundColor: LightColor.error,
          borderColor: LightColor.error,
          iconName: 'fill-close-circle',
        ),
      );

  static String getMonthName(int monthNumber) {
    List<String> months = mainAppBloc.lang.valueOrNull == 'en'
        ? [
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
            'Dec',
          ]
        : [
            'يناير',
            'فبراير',
            'مارس',
            'أبريل',
            'مايو',
            'يونيو',
            'يوليو',
            'أغسطس',
            'سبتمبر',
            'أكتوبر',
            'نوفمبر',
            'ديسمبر',
          ];

    if (monthNumber < 1 || monthNumber > 12) {
      return 'Invalid Month';
    }

    return months[monthNumber - 1];
  }
}
