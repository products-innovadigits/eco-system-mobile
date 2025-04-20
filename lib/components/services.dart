import 'dart:io';

import 'package:dio/dio.dart';
import 'package:eco_system/utility/utility.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';

void shareTheApp() async {
  try {
    // String _msg;
    // StringBuffer _sb = new StringBuffer();
    // _sb.write("لتنزيل التطبيق اضغط على الرابط\n");
    // _sb.write("https://www.foraplus.com/");
    // _msg = _sb.toString();

    // final ByteData bytes = await rootBundle.load('assets/splash.png');
    // await Share.file(
    //     'esys image', 'esys.png', bytes.buffer.asuint8List(), 'image/jpeg',
    //     text: _msg);
  } catch (e) {
    cprint('error: $e');
  }
}

void shareTheAppIOS() async {
  try {
    // String _msg;
    // StringBuffer _sb = new StringBuffer();
    // _sb.write("لتنزيل التطبيق اضغط على الرابط\n");
    // _sb.write("https://www.foraplus.com/");
    // _msg = _sb.toString();
    // final ByteData bytes = await rootBundle.load('assets/splash.png');
    // await Share.file(
    //     'esys image', 'esys.png', bytes.buffer.asuint8List(), 'image/jpeg',
    //     text: _msg);
  } catch (e) {
    cprint('error: $e');
  }
}

void launchURL({String? url}) async {
  final Uri launcher = Uri(
    scheme: 'https',
    path: url!.replaceAll('https', ''),
  );
  if (!await launchUrl(launcher)) {
    throw 'Could not launch $url';
  }
}

void sendWhatsApp({String? phone}) async {
  String? url;
  phone == null
      ? url = "whatsapp://send?phone=+966580491109"
      : url = "whatsapp://send?phone=$phone";

  launchURL(url: url);
}

Future<void> callUser({String? phoneNumber}) async {
  final Uri launchUri = Uri(
    scheme: 'tel',
    path: phoneNumber,
  );
  await launchUrl(launchUri);
}

void sendEmail({String? email}) {
  final Uri emailLaunchUri = Uri(
    scheme: 'mailto',
    path: email!,
  );
  launchUrl(emailLaunchUri);
}

//this for whatsapp
void openUserWhatsapp(String phone) async {
  String launcher = "https://api.whatsapp.com/send?phone=$phone";
  launchURL(url: launcher);
}

void goToMap(double lat, double long) async {
  cprint("_______________get your fucken location__________________");

  final url = 'https://www.google.com/maps/search/?api=1&query=$lat,$long';
  launchURL(url: url);
}

Future<bool> saveFile(String url, String fileName) async {
  try {
    if (await _requestPermission(Permission.storage)) {
      Directory? directory;
      directory = await getTemporaryDirectory();
      String newPath = "";
      List<String> paths = directory.path.split("/");
      for (int x = 1; x < paths.length; x++) {
        String folder = paths[x];
        if (folder != "Android") {
          newPath += "/$folder";
        } else {
          break;
        }
      }
      newPath = "$newPath/PDF_Download";
      directory = Directory(newPath);

      File saveFile = File("${directory.path}/$fileName.pdf");
      if (!await directory.exists()) {
        await directory.create(recursive: true);
      }
      if (await directory.exists()) {
        await Dio().download(
          "http://$url",
          saveFile.path,
        );
      }

      cprint(saveFile.path);

      // Share.shareFiles(
      //   [saveFile.path],
      //   subject: 'Share PDF',
      //   text: 'Hello, check your share files!',
      // );
    }
    return true;
  } catch (e) {
    cprint(e);
    return false;
  }
}

Future<bool> _requestPermission(Permission permission) async {
  if (await permission.isGranted) {
    return true;
  } else {
    var result = await permission.request();
    if (result == PermissionStatus.granted) {
      return true;
    }
  }
  return false;
}
