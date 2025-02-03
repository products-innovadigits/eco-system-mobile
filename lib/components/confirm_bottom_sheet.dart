import 'package:flutter/material.dart';
import 'package:eco_system/components/custom_btn.dart';
import 'package:eco_system/components/custom_images.dart';
import 'package:eco_system/helpers/media_query_helper.dart';
import 'package:eco_system/helpers/styles.dart';
import 'package:eco_system/navigation/custom_navigation.dart';

abstract class CustomBottomSheet {
  static show(
      {Function? onConfirm,
      @required String? label,
      @required Widget? list,
      double? height , BuildContext? context}) {
    showModalBottomSheet(
      context: context ?? CustomNavigator.navigatorState.currentContext!,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return Material(
          type: MaterialType.transparency,
          child: Opacity(
            opacity: 1.0,
            child: Container(
              height: height ?? 240,
              width: MediaQueryHelper.width,
              decoration: const BoxDecoration(
                  color: Styles.WHITE_COLOR,
                  borderRadius: const BorderRadius.only(
                    topRight: const Radius.circular(30),
                    topLeft: const Radius.circular(30),
                  )),
              child: Column(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(30.0, 0.0, 30.0, 20.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                          const SizedBox(height: 24),
                          const SizedBox(height: 16),
                          Text(
                            label!,
                            style: const TextStyle(
                                fontSize: 14, fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(height: 16),
                          Expanded(child: list!),
                        ],
                      ),
                    ),
                  ),
                  Visibility(
                    visible: onConfirm != null,
                    child: CustomBtn(
                      text: 'Submit',
                      paddingWidth: 0.0,
                      horizontalPadding: 0.0,
                      onTap: () {
                        onConfirm!();
                      },
                      btnHeight: 79,
                      withPadding: false,
                      radius: 0,
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }

}
