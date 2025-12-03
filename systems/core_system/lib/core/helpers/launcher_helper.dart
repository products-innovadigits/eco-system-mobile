import 'dart:developer';

import 'package:core_system/core/core/app_core.dart';
import 'package:core_system/core/core/app_strings/locale_keys.dart';
import 'package:core_system/core/helpers/translation/all_translation.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher.dart';

abstract class LauncherHelper {
  static Future<void> openUrl(String url) async {
    if (url.isEmpty) return;

    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri)) {
      throw Exception('Could not launch $url');
    }
  }

  static Future<void> makePhoneCall(String phoneNumber) async {
    if (phoneNumber.isEmpty) return;

    // Remove any non-digit characters from the phone number
    final cleanNumber = phoneNumber.replaceAll(RegExp(r'[^\d+]'), '');

    final Uri uri = Uri(scheme: 'tel', path: cleanNumber);

    if (!await launchUrl(uri)) {
      throw Exception('Could not launch phone call to $phoneNumber');
    }
  }

  static Future<void> sendEmail(String email) async {
    if (email.isEmpty) return;

    final Uri uri = Uri(scheme: 'mailto', path: email);

    if (!await launchUrl(uri)) {
      throw Exception('Could not launch email to $email');
    }
  }

  static Future<void> downloadFiles(String pdfFilePath) async {
    try {
      log('PdfFilePath :: $pdfFilePath');
      await launchUrl(Uri.parse('https://194.163.168.5:447$pdfFilePath'));
      AppCore.successToastMessage(
        allTranslations.text(LocaleKeys.file_downloaded_successfully),
      );
    } catch (e) {
      AppCore.errorToastMessage(allTranslations.text('download_failed'));
    }
  }
}
