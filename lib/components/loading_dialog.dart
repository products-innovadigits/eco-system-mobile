import 'package:eco_system/helpers/media_query_helper.dart';
import 'package:eco_system/navigation/custom_navigation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

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
