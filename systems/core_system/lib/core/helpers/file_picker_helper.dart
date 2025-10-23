import 'dart:io';

import 'package:core_system/core/utility/export.dart';
import 'package:file_picker/file_picker.dart';

abstract class FilePickerHelper {
  static Future<PlatformFile?> pickFile({
    List<String>? allowedExtensions,
    String? type,
  }) async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: allowedExtensions != null && allowedExtensions.isNotEmpty
            ? FileType.custom
            : type == 'image'
            ? FileType.image
            : type == 'video'
            ? FileType.video
            : type == 'audio'
            ? FileType.audio
            : FileType.any,
        allowedExtensions: allowedExtensions,
        allowMultiple: false,
      );

      if (result != null && result.files.isNotEmpty) {
        return result.files.first;
      }
      return null;
    } catch (e) {
      print('Error picking file: $e');
      return null;
    }
  }

  static Future<List<PlatformFile>?> pickMultipleFiles({
    List<String>? allowedExtensions,
    String? type,
  }) async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: allowedExtensions != null && allowedExtensions.isNotEmpty
            ? FileType.custom
            : type == 'image'
            ? FileType.image
            : type == 'video'
            ? FileType.video
            : type == 'audio'
            ? FileType.audio
            : FileType.any,
        allowedExtensions: allowedExtensions,
        allowMultiple: true,
      );

      if (result != null && result.files.isNotEmpty) {
        return result.files;
      }
      return null;
    } catch (e) {
      print('Error picking files: $e');
      return null;
    }
  }

  static Future<File?> pickFileAsFile({
    List<String>? allowedExtensions,
    String? type,
  }) async {
    PlatformFile? platformFile = await pickFile(
      allowedExtensions: allowedExtensions,
      type: type,
    );

    if (platformFile != null && platformFile.path != null) {
      return File(platformFile.path!);
    }
    return null;
  }

  static String getFileExtension(String fileName) {
    return fileName.split('.').last.toLowerCase();
  }

  static String getFileName(String filePath) {
    return filePath.split('/').last;
  }

  static String formatFileSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    if (bytes < 1024 * 1024 * 1024)
      return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB';
  }
}
