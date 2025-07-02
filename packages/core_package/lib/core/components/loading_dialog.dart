import 'package:core_package/core/utility/export.dart';

void showLoadingDialog() {
  showDialog(
    barrierDismissible: false,
    context: CustomNavigator.navigatorState.currentContext!,
    builder: (BuildContext context) {
      return Scaffold(
        backgroundColor: const Color.fromRGBO(0, 0, 0, 0.2),
        body: SizedBox(
          height: MediaQueryHelper.appMediaQuerySize.height,
          width: MediaQueryHelper.appMediaQuerySize.width,
          child: const Center(
            child: Center(
              child: SpinKitFadingCircle(
                color: Colors.white,
              ),
            ),
          ),
        ),
      );
    },
  );
}
