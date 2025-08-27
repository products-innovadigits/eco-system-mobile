import 'package:core_system/core/model/color_scheme_model.dart';
import 'package:flutter/material.dart';

class LightColor {
  // static const Color primary = Color(0xff2b6c9f);
  static Color scaffoldBg = Color(0xffFAFAFA);
  static Color cardBg = Color(0xffFFFFFF);
  static Color primary = Color(0xff020F4C);
  static Color secondary = Color(0xff175CD3);
  static Color tertiary = Color(0xff097867);
  static Color tertiaryLight = Color(0xff079455);
  static Color placeHolderText = Color(0xff9DA4AE);

  // static const Color textPrimary = Color(0xff020F4C);
  static Color border = Color(0xffF3F4F6);
  static const Color primaryDark = Color(0xff64748B);
  static const Color primaryColorLight = Color(0xffE2E8F0);
  static const Color black = Colors.black;

  // static const Color secondary = Color(0xff175CD3);
  static const Color grey = Color(0xff64748B);
  static const Color greyLight = Color(0xffEFEFF5);
  static const Color white = Colors.white;
  static Color error = Color(0xffD92D20);
  static Color warning = Color(0xffDC6803);
  static const Color lightGreen = Color(0xff59BF75);

  // Timeline colors ====================
  static const Color timelineHeader = Color(0xffE9E9E9);
  static const Color timelineBorder = Color(0xffF3F4F6);

  // chart colors ====================

  static const Color chartPrimary = Color(0xff020F4C);
  static const Color chartSecondary = Color(0xffDC6803);
  static const Color chartTertiary = Color(0xff097867);

  static Color statusColors(String value, {bool isLineProgress = false}) {
    final primaryChart = isLineProgress
        ? LightColor.secondary
        : LightColor.chartPrimary;
    switch (value) {
      case "مكتمل":
        return LightColor.tertiary;
      case "متقدم":
        return primaryChart;
      case "متأخر":
        return LightColor.chartSecondary;
      default:
        return primaryChart;
    }
  }

  static Color strategicTypeColors(String value) {
    switch (value) {
      case "تشغيلي":
        return LightColor.chartTertiary;
      case "خططى":
        return LightColor.chartSecondary;
      default:
        return LightColor.chartTertiary;
    }
  }

  static const List<Color> projectCategoryColors = [
    Color(0xffD92D20),
    Color(0xff020F4C),
    Color(0xffF39C12),
    Color(0xFF2FAB86),
    Color(0xff615E83),
    Color(0xFFDB5353),
    Color(0xFF3051CE),
    Color(0xffE68D24),
    Color(0xffFE9365),
  ];

  static void update(ColorSchemeModel? m) {
    if (m == null) return;
    primary = m.primary ?? primary;
    secondary = m.secondary ?? secondary;
    tertiary = m.tertiary ?? tertiary;
    tertiaryLight = m.tertiaryContainer ?? tertiaryLight;
    scaffoldBg = m.surface ?? scaffoldBg;
    cardBg = m.surfaceContainer ?? cardBg;
    border = m.outline ?? border;
    placeHolderText = m.outlineVariant ?? placeHolderText;
    error = m.error ?? error;
    warning = m.errorContainer ?? warning;
  }
}
