import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;

import '../helpers/translation/all_translation.dart';
import '../navigation/custom_navigation.dart';

extension StringEx on String {
  String takeOnly(int value) {
    if (length > value) {
      return "${substring(0, value)} ...";
    }
    return this;
  }

  bool get isPhone =>
      RegExp(
        r'^[\+]?[(]?[0-9]{3}[)]?[-\s\.]?[0-9]{3}[-\s\.]?[0-9]{4,6}$',
      ).hasMatch(this) &&
      (length > 8 || length <= 10);

  bool isNumeric() {
    for (int i = 0; i < length; i++) {
      if (double.tryParse(this[i]) != null) {
        return true;
      }
    }
    return false;
  }

  bool get isEmail => RegExp(
    r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$',
  ).hasMatch(this);

  bool get isArabic => RegExp("/[\u0600-\u06FF\u0750-\u077F]/").hasMatch(this);

  bool get isEnglish => RegExp('[a-zA-Z]').hasMatch(this);

  TextDirection get textDirection =>
      RegExp('[a-zA-Z]').hasMatch(this) ? TextDirection.ltr : TextDirection.rtl;

  Color get toColor {
    String colorStr = this;
    colorStr = "FF$colorStr";
    colorStr = colorStr.replaceAll("#", "");
    int val = 0;
    int len = colorStr.length;
    for (int i = 0; i < len; i++) {
      int hexDigit = colorStr.codeUnitAt(i);
      if (hexDigit >= 48 && hexDigit <= 57) {
        val += (hexDigit - 48) * (1 << (4 * (len - 1 - i)));
      } else if (hexDigit >= 65 && hexDigit <= 70) {
        val += (hexDigit - 55) * (1 << (4 * (len - 1 - i)));
      } else if (hexDigit >= 97 && hexDigit <= 102) {
        val += (hexDigit - 87) * (1 << (4 * (len - 1 - i)));
      } else {
        throw const FormatException(
          "An error occurred when converting a color",
        );
      }
    }
    return Color(val);
  }
}

extension NumEx on int {
  Duration get hours => Duration(hours: this);

  Duration get minutes => Duration(minutes: this);

  Duration get seconds => Duration(seconds: this);

  Duration get milliseconds => Duration(milliseconds: this);
}

extension WidgetEx on Widget {
  Widget ripple(Function()? onPressed) =>
      InkWell(onTap: onPressed, child: this);

  Widget paddingAll(double value) =>
      Padding(padding: EdgeInsets.all(value), child: this);

  Widget paddingOnly({
    double left = 0.0,
    double top = 0.0,
    double right = 0.0,
    double bottom = 0.0,
  }) => Padding(
    padding: EdgeInsets.only(
      left: left,
      top: top,
      right: right,
      bottom: bottom,
    ),
    child: this,
  );

  Widget paddingSymmetric({double vertical = 0.0, double horizontal = 0.0}) =>
      Padding(
        padding: EdgeInsets.symmetric(
          vertical: vertical,
          horizontal: horizontal,
        ),
        child: this,
      );

  Widget boarder(double value) =>
      ClipRRect(borderRadius: BorderRadius.circular(value), child: this);

  Widget get onCenter => Center(child: this);
}

extension ContextEX on BuildContext {
  double get h => MediaQuery.of(this).size.height;

  double get w => MediaQuery.of(this).size.width;

  ColorScheme get color => Theme.of(this).colorScheme;

  ThemeData get theme => Theme.of(this);

  TextTheme get textTheme => Theme.of(this).textTheme;
}

extension DateTimeExtension on DateTime {
  DateTime next(int day) {
    return add(Duration(days: (day - weekday) % DateTime.daysPerWeek));
  }

  bool isSameDate(DateTime other) =>
      year == other.year && month == other.month && day == other.day;

  String get dayName => intl.DateFormat('EEEE').format(this);

  /// Formats this date with [fromat], in [cutomlocale] or the app's current
  /// language.
  ///
  /// Returns an empty string instead of throwing when the pattern or the
  /// locale data cannot be used.
  String format(String fromat, {String? cutomlocale}) {
    try {
      return intl.DateFormat(
        fromat,
        cutomlocale ?? _appLocaleCode(),
      ).format(this);
    } catch (e) {
      return "";
    }
  }
}

/// Language used for date formatting: the mounted navigator's locale, falling
/// back to the selected app language when there is no navigator yet — during
/// startup, in an isolate, or under test. Reading it through the global
/// navigator context used to be an unguarded `!`, which threw in exactly those
/// cases.
String _appLocaleCode() {
  try {
    final BuildContext? context = CustomNavigator.navigatorState.currentContext;
    if (context != null) {
      final Locale? locale = Localizations.maybeLocaleOf(context);
      if (locale != null) return locale.languageCode;
    }
  } catch (_) {
    // Reading a GlobalKey's context throws outright when the widgets binding
    // is not up yet, so this has to be guarded, not just null-checked.
  }
  return allTranslations.currentLanguage;
}
