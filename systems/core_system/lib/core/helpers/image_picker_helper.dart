import 'dart:io';

import 'package:core_system/core/utility/export.dart';
import 'package:flutter/cupertino.dart';

abstract class ImagePickerHelper {
  static void showOption({ValueChanged<File>? onGet}) {
    showDialog(
      context: CustomNavigator.navigatorState.currentContext!,
      builder: (_) {
        return CupertinoAlertDialog(
          title: Center(child: Text('Select Image Source')),
          actions: [
            CupertinoDialogAction(
              child: Text('Gallery'),
              onPressed: () => openGallery(onGet: onGet),
            ),
            CupertinoDialogAction(
              child: Text('Camera'),
              onPressed: () => openCamera(onGet: onGet),
            ),
          ],
        );
      },
    );
  }

  static Future<void> openGallery({ValueChanged<File>? onGet}) async {
    CustomNavigator.pop();
    var image = await ImagePicker().pickImage(source: ImageSource.gallery);
    onGet!(File(image!.path));
  }

  static Future<void> openCamera({ValueChanged<File>? onGet}) async {
    CustomNavigator.pop();
    var image = await ImagePicker().pickImage(source: ImageSource.camera);
    onGet!(File(image!.path));
  }
}
