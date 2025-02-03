import 'package:flutter/material.dart';
import 'package:eco_system/helpers/media_query_helper.dart';
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
    return DateFormat.E('en_US').format(date)+","+" "+ DateFormat.Md('en_US').format(date);
  }

    static String periodFormat(DateTime start , DateTime end) {
     return allTranslations.text('from')
          +" "+TextHelper.formatDateWithDayName(start)+ " "+"(${start.year})"+" "+allTranslations.text('to')+" "+TextHelper.formatDateWithDayName(end) + " "+"(${end.year})";
  }


  static String formatTime(DateTime date) {
    String _formattedTime = DateFormat.jm().format(date);
    return _formattedTime;
  }

  static String reverseDate(String date) {
    var list = date.split('-').reversed.toList() ;
    date = list[0]+"-"+list[1]+"-"+list[2];
    return date;
  }

 static String parsePrice({required String price}) {
    String newString = "";
    newString = price.replaceAll(new RegExp(r'[^0-9]'), '');
    print(newString);
    return newString;
  }

  static String formatDateTime(DateTime date) {
    String _formattedTime = formatTime(date);
    String _formattedDate = formatDateWithMonthName(date);
    return _formattedDate + ' at ' + _formattedTime;
  }

  static String name(String name) {
    if (name.length < 10) {
      return name;
    } else {
      return ' .. ' + name.substring(0, 10);
    }
  }

  static String nameProfile(String name) {
    if (name.length < 20) {
      return name;
    } else {
      return ' .. ' + name.substring(0, 20);
    }
  }

  static String paresHTML(String htmlText) {
    RegExp exp = RegExp(r"<[^>]*>", multiLine: true, caseSensitive: true);
    return htmlText.replaceAll(exp, '');
  }
}

class Constants {
  static const EMAIL_EXP =
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
  static const PHONE_EXP =
      r'^(?:\+?0[-.●]?)?\(?([0-9]{3})\)?[-.●]?([0-9]{3})[-.●]?([0-9]{4})$';
  static const INTERNET_CONNECTION_FIELD = 'تحقق من الاتصال بالانترنت';
  static const USER_NOT_FOUND = 'هذا المستخدم غير موجود';
  static const SHOW_DATE = "period_to_period";
  static const DATE_FORMAT = "y-MM-dd";
  static const HOUR_FORMAT = "hh:mm";
  static const Y_STATUS = "Y";
  static const N_STATUS = "N";
  static const P_STATUS = "P";
  static const SELF_SERVICE_REQUEST = "SELF_SERVICE_REQUEST";
  static const FOLLOW_REQUEST = "FOLLOW_REQUEST";
  static const APPROVED = "APPROVED";
  static const REJECTED = "REJECTED";
  static const CORRECT = "CORRECT";
  static const DELETE = "DELETE";
  static const CURRENCY = "JOR";
}
