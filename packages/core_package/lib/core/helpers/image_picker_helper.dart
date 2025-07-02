import 'dart:io';

import 'package:core_package/core/utility/export.dart';
import 'package:flutter/cupertino.dart';

abstract class ImagePickerHelper {
  static showOption({ ValueChanged<File>? onGet}) {
    showDialog(
      context: CustomNavigator.navigatorState.currentContext!,
      builder: (_) {
        return CupertinoAlertDialog(
          title: Center(child: Text('Select Image Source')),
          actions: [
            CupertinoDialogAction(child: Text('Gallery'), onPressed: () => openGallery(onGet: onGet)),
            CupertinoDialogAction(child: Text('Camera'), onPressed: () => openCamera(onGet: onGet)),
          ],
        );
      },
    );
  }

  static openGallery({ValueChanged<File>? onGet}) async {
    CustomNavigator.pop();
    var _image = await ImagePicker().pickImage(source: ImageSource.gallery);
    onGet!(File(_image!.path));
  }

  static openCamera({ValueChanged<File>? onGet}) async {
    CustomNavigator.pop();
    var _image = await ImagePicker().pickImage(source: ImageSource.camera);
    onGet!(File(_image!.path));
  }
}
