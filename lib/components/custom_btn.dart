import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:eco_system/helpers/styles.dart';

class CustomBtn extends StatelessWidget {
  final String? text;
  final GestureTapCallback? onTap;
  final Color? color;
  final Color? txtColor;
  final IconData? icon;
  final Widget? image;
  final bool? loading;
  final double? btnWidth;
  final double? btnHeight;
  final double? txtFontSize;
  final double? paddingWidth;
  final double? horizontalPadding;
  final double? radius;
  final bool? withPadding;
  final bool? onlyBorder;
  final bool? showTransparent;
  /// you can't use text if you are going to use a widget instead
  final Widget? widget;
  const CustomBtn(
      {Key? key,
      @required this.text,
      @required this.onTap,
      this.color,
      this.widget,
      this.txtColor,
      this.paddingWidth,
      this.icon,
      this.loading = false,
      this.btnWidth,
      this.txtFontSize,
      this.withPadding = true,
      this.image,
      this.onlyBorder = false,
      this.btnHeight,
      this.showTransparent = false, this.radius, this.horizontalPadding})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
      return InkWell(
        onTap: onTap!,
        child: Padding(
          padding: withPadding!
              ? const EdgeInsets.only(right: 5, left: 5)
              : EdgeInsets.zero,
          child: Stack(
            children: [
              Container(
                height: btnHeight ?? 45,
                width: btnWidth,
                decoration: BoxDecoration(
                  border: onlyBorder! ? Border.all(color: txtColor!) : null,
                  borderRadius: BorderRadius.circular(radius ?? 5.0),
                  color: onlyBorder!
                      ? color
                      : showTransparent!
                          ? Styles.PRIMARY_COLOR.withOpacity(.5)
                          : loading! ? color!.withOpacity(.6):color ?? Styles.PRIMARY_COLOR,
                  // gradient: onlyBorder!
                  //     ? null
                  //     : const LinearGradient(
                  //         colors: [
                  //             Styles.LOGIN_BTN_COLOR,
                  //             Styles.HOME_ICONS_COLOR,
                  //           ],
                  //         stops: [
                  //             0,
                  //             4
                  //           ],
                  //         end: Alignment.bottomCenter,
                  //         begin: Alignment.topCenter),
                ),
                child: loading! ? SpinKitThreeBounce(
                  color: Styles.WHITE_COLOR,
                  size: 25,
                ):Padding(
                  padding:  EdgeInsets.symmetric(horizontal: horizontalPadding ?? 15.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [

                      icon != null
                          ? Icon(
                        icon,
                        color: txtColor,
                      )
                          : Container(),
                      image != null ? image! : Container(),
                      icon != null || image != null && text != ''
                          ?  SizedBox(width: paddingWidth ?? 14)
                          : Container(),
                      widget ?? Text(
                        text!,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: txtColor ?? Colors.white,
                            fontWeight: FontWeight.w800,
                            fontSize: txtFontSize ?? 15),
                      ),

                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }
}
