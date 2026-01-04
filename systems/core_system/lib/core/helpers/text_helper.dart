import 'dart:developer';

import 'package:intl/intl.dart';

import 'translation/all_translation.dart';

class TextHelper {
  static String formatDate(DateTime date) {
    return "${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
  }

  static String formatDateWithMonthName(DateTime date) {
    return DateFormat.yMMMMd('en_US').format(date);
  }

  static String formatDateWithDayMonthName(DateTime date) {
    return DateFormat.MMMMEEEEd('en_US').format(date);
  }

  static String formatDateWithTime(DateTime date) {
    return DateFormat.jm('en_US').format(date);
  }

  static String formatDateWithDayName(DateTime date) {
    return "${DateFormat.E('en_US').format(date)}, ${DateFormat.Md('en_US').format(date)}";
  }

  static String periodFormat(DateTime start, DateTime end) {
    return "${allTranslations.text('from')} ${TextHelper.formatDateWithDayName(start)} (${start.year}) ${allTranslations.text('to')} ${TextHelper.formatDateWithDayName(end)} (${end.year})";
  }

  static String formatTime(DateTime date) {
    String formattedTime = DateFormat.jm().format(date);
    return formattedTime;
  }

  static String reverseDate(String date) {
    var list = date.split('-').reversed.toList();
    date = "${list[0]}-${list[1]}-${list[2]}";
    return date;
  }

  static String parsePrice({required String price}) {
    String newString = "";
    newString = price.replaceAll(RegExp(r'[^0-9]'), '');
    log(newString);
    return newString;
  }

  static String formatDateTime(DateTime date) {
    String formattedTime = formatTime(date);
    String formattedDate = formatDateWithMonthName(date);
    return '$formattedDate at $formattedTime';
  }

  static String name(String name) {
    if (name.length < 10) {
      return name;
    } else {
      return ' .. ${name.substring(0, 10)}';
    }
  }

  static String nameProfile(String name) {
    if (name.length < 20) {
      return name;
    } else {
      return ' .. ${name.substring(0, 20)}';
    }
  }

  static String paresHTML(String htmlText) {
    RegExp exp = RegExp(r"<[^>]*>", multiLine: true, caseSensitive: true);
    return htmlText.replaceAll(exp, '');
  }
}

class Constants {
  static const phoneExp =
      r'^(?:\+?0[-.●]?)?\(?([0-9]{3})\)?[-.●]?([0-9]{3})[-.●]?([0-9]{4})$';
  static const dateFormat = "y-MM-dd";
}
