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

    final Uri uri = Uri(
      scheme: 'tel',
      path: cleanNumber,
    );

    if (!await launchUrl(uri)) {
      throw Exception('Could not launch phone call to $phoneNumber');
    }
  }

  static Future<void> sendEmail(String email) async {
    if (email.isEmpty) return;

    final Uri uri = Uri(
      scheme: 'mailto',
      path: email,
    );

    if (!await launchUrl(uri)) {
      throw Exception('Could not launch email to $email');
    }
  }
}
