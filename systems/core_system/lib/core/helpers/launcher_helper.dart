import 'dart:developer';
import 'dart:io';

import 'package:core_system/core/config/app_config.dart';
import 'package:core_system/core/utility/export.dart';
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

  // static Future<void> downloadFiles(String pdfFilePath) async {
  //   try {
  //   log('PdfFilePath :: $pdfFilePath');
  //   await launchUrl(Uri.parse('https://194.163.168.5:447$pdfFilePath'));
  //   AppCore.successToastMessage(
  //     allTranslations.text(LocaleKeys.file_downloaded_successfully),
  //   );
  //   } catch (e) {
  //     AppCore.errorToastMessage(allTranslations.text('download_failed'));
  //   }
  // }

  static Future<void> downloadFiles({
    required BuildContext context,
    required String filePath,
    String? fullLink,
  }) async {
    log('FilePath :: $filePath');

    // PM relative paths are served from the same host as [AppConfig.projectManagementBaseUrl]
    // (origin only — not the ATS host). Do not use [AppConfig.atsBaseUrl] here.
    final String originalUrl = filePath.toLowerCase().startsWith('http')
        ? filePath
        : '${AppConfig.projectManagementOrigin}$filePath';
    final Uri originalUri = Uri.parse(fullLink ?? originalUrl);

    // show modal loading dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => PopScope(
        canPop: false,
        child: Center(
          child: SizedBox(
            width: 64.w,
            height: 64.h,
            child: CircularProgressIndicator.adaptive(),
          ),
        ),
      ),
    );

    try {
      if (Platform.isIOS) {
        // iOS: Open URL in Safari which will trigger download
        if (await canLaunchUrl(originalUri)) {
          await launchUrl(originalUri, mode: LaunchMode.externalApplication);
          AppCore.successToastMessage(
            allTranslations.text(LocaleKeys.file_downloaded_successfully),
          );
        } else {
          AppCore.errorToastMessage(allTranslations.text('download_failed'));
        }
      } else {
        // Android: Use Chrome-specific URL scheme for better download handling
        final String chromeUrlString = originalUrl
            .replaceFirst('https://', 'googlechromes://')
            .replaceFirst('http://', 'googlechrome://');

        final Uri chromeUri = Uri.parse(chromeUrlString);

        // Check if we can open Chrome
        if (await canLaunchUrl(chromeUri)) {
          await launchUrl(chromeUri, mode: LaunchMode.externalApplication);
        } else {
          // Fallback: Chrome is not installed, open default browser
          log('Chrome not found, falling back to default browser');
          if (await canLaunchUrl(originalUri)) {
            await launchUrl(originalUri, mode: LaunchMode.externalApplication);
          } else {
            AppCore.errorToastMessage(allTranslations.text('download_failed'));
          }
        }

        AppCore.successToastMessage(
          allTranslations.text(LocaleKeys.file_downloaded_successfully),
        );
      }
    } catch (e) {
      log('Error launching URL: $e');
      AppCore.errorToastMessage(allTranslations.text('download_failed'));
    } finally {
      // dismiss loading dialog if still shown
      try {
        if (!context.mounted) return;

        final navigator = Navigator.of(context, rootNavigator: true);
        if (navigator.canPop()) {
          navigator.pop();
        }
      } catch (_) {}
    }
  }
}
