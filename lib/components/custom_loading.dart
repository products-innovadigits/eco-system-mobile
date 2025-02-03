import 'package:flutter/material.dart';
import 'package:eco_system/helpers/media_query_helper.dart';
import 'package:eco_system/helpers/styles.dart';

class CustomLoading extends StatelessWidget {
  final bool? loading;
  final margin;
  final color;
  final value;
  final double? remain;
  final double? height ;
  final bool isTextLoading ;

  const CustomLoading(
      {Key? key,
      this.loading,
      this.margin,
      this.isTextLoading = false,
      this.color,
      this.value,
      this.remain = 0.0, this.height})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return isTextLoading ? Visibility(
      visible: loading ?? true,
      child: Container(
        height: 50,
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text("Loading ... " , style: Styles.SUB_HEADER_STYLE,)
              ],
            ),
          )),
    ):Visibility(
      visible: loading ?? true,
      child: Padding(
        padding:  EdgeInsets.only(bottom: MediaQueryHelper.appMediaQueryViewPadding.bottom),
        child: SizedBox(
          height:height ??  MediaQueryHelper.height - remain!,
          child: Center(
                  child: CircularProgressIndicator(color: color ?? Styles.PRIMARY_COLOR, )),
        ),
      ),
    );
  }
}
