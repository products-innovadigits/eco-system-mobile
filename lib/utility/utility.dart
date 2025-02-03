import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:developer' as developer;
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'dart:io';

void cprint(dynamic data, {String? errorIn, String? event, String? label}) {
  if (kDebugMode) {
    if (errorIn != null) {
      print('****************************** error ******************************');
      developer.log('[${label ?? "Error"}]', time: DateTime.now(), error: data, name: errorIn);
      print('****************************** error ******************************');
    } else if (data != null) {
      developer.log(data, time: DateTime.now(), name: label ?? "Log");
    }
    if (event != null) {
      Utility.logEvent(event, parameter: {});
    }
  }
}

class Utility {
  static launchURL(String url) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      cprint('Could not launch $url');
    }
  }

  static void logEvent(String event, {Map<String, dynamic>? parameter}) {
    kReleaseMode ? developer.log("message") : cprint("[EVENT]: $event");
  }

  static void debugLog(String log, {dynamic param = ""}) {
    final String time = DateFormat("mm:ss:mmm").format(DateTime.now());
    cprint("[$time][Log]: $log, $param");
  }

  static Locale getLocale(BuildContext context) {
    return Localizations.localeOf(context);
  }

  static Future<File> compressImage(File file) async {
    var result = await FlutterImageCompress.compressWithFile(
      file.path,
      quality: 70,
      minHeight: 1920,
      minWidth: 1080,
    );

    final compressedFile = result == null ? file : File(file.path)
      ..writeAsBytesSync(result!);
    return compressedFile;
  }
}
