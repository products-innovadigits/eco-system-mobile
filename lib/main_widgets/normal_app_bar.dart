import 'package:flutter/material.dart';
import 'package:eco_system/components/custom_arrow_back.dart';
import 'package:eco_system/components/custom_images.dart';
import 'package:eco_system/helpers/media_query_helper.dart';
import 'package:eco_system/helpers/styles.dart';
import 'package:eco_system/navigation/custom_navigation.dart';
class NormalAppBar extends StatelessWidget {
  final String? title ;
  final Widget? action;
  const NormalAppBar({Key? key, required this.title, this.action}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  Container(
        height: MediaQueryHelper.topPadding + 70,
        color: Styles.PRIMARY_COLOR,
        child: Padding(
        padding: EdgeInsets.only(
        top: MediaQueryHelper.topPadding, right: 24, left: 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          InkWell(
              onTap: ()=> CustomNavigator.pop(),
              child: ArrowBack()),
          Expanded(
            child: Text(
             title!,
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Styles.WHITE_COLOR),
              textAlign: TextAlign.center,
            ),
          ),
          action ?? Container()

        ],
      ),
    ));
  }
}
