import 'package:flutter/material.dart';

abstract class Styles {
  static const Color accentPrimaryColor = Color(0xff615E83);
  static const Color fieldBorder = Color(0xFFF9F9FA);
  static const Color subText = Color(0xFF6A7887);
  static const Color bgImageColor = Color(0xFF032D5F);
  static const Color active = Color(0xFF2FAB86);
  static const Color inActive = Color(0xFFDB5353);
  static const Color pending = Color(0xFFA6840A);
  static const Color scaffoldBg = Color(0xffFCFCFC);
  static const Color header = Color(0xFF000000);
  static const Color border = Color(0xFFF4F4F4);
  static const Color iconGreyColor = Color(0xFFCBCBCB);
  static const Color iconDarkColor = Color(0xFF292D32);
  static const Color surface = Color(0xFFE7EAEC);
  static const Color surfaceSecondary = Color(0xFFE6F5F4);
  static const Color darkBlue = Color(0xFF054699);

  static const Color textColor = Color(0xff00403C);
  static const Color textBlueDarkColor = Color(0xff001A6D);
  static const Color subTextDarkColor = Color(0xffB4B4B4);
  static const Color title = Color(0xFF08131C);
  static const Color placeHolder = Color(0xFF7F8B93);
  static const Color fillColor = Color(0xFFFAFAFA);
  static const Color details = Color(0xFF8F8F8F);
  static const Color hint = Color(0xFFA7A7A7);
  static const Color whiteColor = Color(0xFFFFFFFF);
  static const Color lightBlue = Color(0xff70EEC8);
  static const Color boardingBlur = Color.fromRGBO(0, 0, 0, 0.7);
  static const Color darkRed = Color(0xff982929);
  static const TextStyle subHeaderStyle = TextStyle(
    color: Styles.title,
    fontSize: 12,
    fontWeight: FontWeight.w600,
  );

  static const String fontAr = 'ar';

  static Widget logo({Color? color, double? height, double? width}) =>
      Image.asset(
        'assets/zulfi_logo.png',
        height: height ?? 300.0,
        width: width ?? 300.0,
        color: color,
        colorBlendMode: color != null ? BlendMode.srcIn : null,
        fit: BoxFit.contain,
      );
  static final Widget splash = Image.asset(
    'assets/images/splash.png',
    height: 158.0,
    width: 180.0,
  );
  static const Widget divider = Padding(
    padding: EdgeInsets.symmetric(horizontal: 24),
    child: Divider(color: Styles.hint, thickness: 1.0),
  );
}
