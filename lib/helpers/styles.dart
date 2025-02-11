import 'package:flutter/material.dart';

import '../bloc/main_app_bloc.dart';

abstract class Styles {
  static const Color RED_CHART_COLOR = Color(0xffE24F4F);
  static const Color PRIMARY_COLOR = Color(0xff2b6c9f);
  static const Color ACCENT_PRIMARY_COLOR = Color(0xffF7F1FC);
  static const Color ACCENT_COLOR = Color(0xFF70EEC8);
  static const Color FIELD_BORDER = Color(0xFFF9F9FA);
  static const Color SUB_TEXT = Color(0xFF6A7887);
  static const Color BG_IMAGE_COLOR = Color(0xFF032D5F);
  static const Color ACTIVE = Color(0xFF2FAB86);
  static const Color IN_ACTIVE = Color(0xFFDB5353);
  static const Color PENDING = Color(0xFFA6840A);
  static const Color SCAFFOLD_BG = Color(0xFFE5E5E5);
  static const Color HEADER = Color(0xFF000000);

  static const Color TITLE = Color(0xFF08150D);
  static const Color PLACE_HOLDER = Color(0xFF7F8B93);
  static const Color FILL_COLOR = Color(0xFFFAFAFA);
  static const Color CARD_BORDER = Color(0xFFE4E9FC);
  static const Color UN_SELECTED = Color(0xFFF5F5F5);
  static const Color FEED_COLOR2 = Color(0xFF3051CE);
  static const Color CHECK_IN = Color(0xFF01A9AC);
  static const Color QUICK_ACTIONS = Color(0xFFEFF2FD);
  static const Color TEAMS_GRADIENT = Color(0xFF374A90);
  static const Color DETAILS = Color(0xFF8F8F8F);
  static const Color HINT = Color(0xFFA7A7A7);
  static const Color WHITE_COLOR = Color(0xFFFFFFFF);
  static const Color LIGHT_BLUE = Color(0xff70EEC8);
  static const Color GREEN = Color(0xff2FAB86);
  static const Color GREEN2 = Color(0xff09A66D);
  static const Color GREEN3 = Color(0xff759613);
  static const Color GREEN4 = Color(0xff209370);
  static const Color LIGHT_GREEN = Color(0xffEEF5F7);
  static const Color LIGHT_GREEN2 = Color(0xffF4FBDF);
  static const Color ORANGE1 = Color(0xffFF8753);
  static const Color ORANGE2 = Color(0xffE68D24);
  static const Color ORANGE3 = Color(0xffFE9365);
  static const Color LIGHT_ORANGE = Color(0xffFDF8F1);
  static const Color LIGHT_GREY_BORDER = Color(0XFFEEEEEE);
  static const Color BOARDING_BLUR = Color.fromRGBO(0, 0, 0, 0.7);
  static const Color SELECTED_BACKGROUND = Color(0xffCBC0FD);
  static const Color SUBTITLE = Color(0xff737373);
  static const Color REMOVE_COLOR = Color(0xffFDEEEE);
  static const Color BORDER_COLOR = Color(0xffEFEFF5);
  static const Color ALERT_COLOR = Color(0xffDBAB02);
  static const Color DARK_RED = Color(0xff982929);
  static const Color DARK_GREEN = Color(0xff279473);
  static const Color CIRCLE_BACKGROUND = Color(0xff4D7272);
  static const Color CIRCLE_BACKGROUND2 = Color(0xff8CB3B3);
  static const Color CIRCLE_BACKGROUND3 = Color(0xffA98CB3);
  static const Color CIRCLE_BACKGROUND4 = Color(0xffADB38C);
  static const Color CIRCLE_BACKGROUND5 = Color(0xffAF5252);
  static const Color CIRCLE_BACKGROUND6 = Color(0xff817C0B);
  static const Color CIRCLE_BACKGROUND7 = Color(0xff728ADE);
  static const Color CIRCLE_BACKGROUND8 = Color(0xff49A5A5);
  static const SCREEN_PADDING =
      const EdgeInsets.symmetric(horizontal: 16, vertical: 20);
  static const HORIZONTAL_PADDING =
      const EdgeInsets.symmetric(horizontal: 16, vertical: 20);
  static const VERTICAL_PADDING =
      const EdgeInsets.symmetric(horizontal: 16, vertical: 20);
  static const TextStyle UN_SELECTED_TAB =
      TextStyle(color: Styles.HINT, fontSize: 13, fontWeight: FontWeight.w600);
  static const TextStyle SELECTED_TAB = TextStyle(
      color: Styles.PRIMARY_COLOR, fontSize: 13, fontWeight: FontWeight.w800);
  static TextStyle HEADER_STYLE({size}) => TextStyle(
      color: Styles.HEADER,
      fontSize: size ?? 14,
      fontWeight: FontWeight.w700,
      fontFamily: mainAppBloc.lang.valueOrNull);
  static const TextStyle MINI_HEADER_STYLE = TextStyle(
      color: Styles.HEADER,
      fontSize: 12,
      fontWeight: FontWeight.w600,
      fontFamily: 'text');
  static const TextStyle SUB_HEADER_STYLE =
      TextStyle(color: Styles.TITLE, fontSize: 12, fontWeight: FontWeight.w600);
  static TextStyle PLACE_HOLDER_STYLE({fontFamily, fontWeight, size}) =>
      TextStyle(
          color: Styles.PLACE_HOLDER,
          fontSize: size ?? 12,
          fontWeight: fontWeight ?? FontWeight.w800,
          fontFamily: fontFamily ?? mainAppBloc.lang.valueOrNull);
  static const TextStyle CONTENT_STYLE = TextStyle(
      fontSize: 16, fontWeight: FontWeight.normal, color: Colors.grey);

  static const String FONT_EN = 'en';
  static const String FONT_AR = 'ar';
  static BorderRadius borderRadius = BorderRadius.circular(10.0);

  static Widget logo({Color? color, double? height, double? width}) =>
      Image.asset(
        'assets/logo.png',
        height: height ?? 190.0,
        width: width ?? 250.0,
        color: color,
        fit: BoxFit.contain,
      );
  static final Widget splash = Image.asset(
    'assets/images/splash.png',
    height: 158.0,
    width: 180.0,
  );
  static const Widget divider = Padding(
    padding: EdgeInsets.symmetric(horizontal: 24),
    child: Divider(color: Styles.HINT, thickness: 1.0),
  );

  static const List<Color> objectivesColors = [
    Colors.teal,
    PRIMARY_COLOR,
    Colors.pink,
  ];
}
