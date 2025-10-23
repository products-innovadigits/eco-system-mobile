import 'dart:convert';

import 'package:dio/dio.dart';

import '../utility/utility.dart';

class NetworkLogger {
  static final logger = InterceptorsWrapper(
    onRequest: (RequestOptions options, handler) {
      String headers = "";
      String body = "";
      String queryParameters = "";
      // For Print Header
      options.headers.forEach((key, value) => headers += "$key: $value |");

      // For Print Body
      if (options.data.runtimeType == FormData) {
        FormData formData = options.data as FormData;

        // Log regular fields
        for (var i = 0; i < formData.fields.length; i++) {
          body += '${formData.fields[i].key}: ${formData.fields[i].value} | ';
        }

        // Log files if they exist
        if (formData.files.isNotEmpty) {
          for (var i = 0; i < formData.files.length; i++) {
            MapEntry<String, MultipartFile> fileEntry = formData.files[i];
            body +=
                '${fileEntry.key}: [FILE] ${fileEntry.value.filename ?? 'unnamed'} (${fileEntry.value.length} bytes) | ';
          }
        }
      } else if (options.data.runtimeType is Map) {
        (options.data as Map).forEach((key, value) => body += "$key: $value |");
      } else {
        body = "${options.data}";
      }
      // For Print queryParameters
      options.queryParameters.forEach(
        (key, value) => queryParameters += "$key: $value |",
      );
      cprint(
        "┌------------------------------------------------------------------------------",
      );
      cprint('''| Request: ${options.method} ${options.uri}''');
      cprint(
        "├------------------------------------------------------------------------------",
      );
      cprint('''| Headers: $headers''');
      cprint(
        "├------------------------------------------------------------------------------",
      );
      cprint('''| Body: $body''');

      // Add detailed file information if FormData contains files
      if (options.data.runtimeType == FormData) {
        FormData formData = options.data as FormData;
        if (formData.files.isNotEmpty) {
          cprint(
            "├------------------------------------------------------------------------------",
          );
          cprint('''| File Details:''');
          for (var i = 0; i < formData.files.length; i++) {
            MapEntry<String, MultipartFile> fileEntry = formData.files[i];
            cprint('''|   - Field: ${fileEntry.key}''');
            cprint('''|     File: ${fileEntry.value.filename ?? 'unnamed'}''');
            cprint('''|     Size: ${fileEntry.value.length} bytes''');
            cprint(
              '''|     ContentType: ${fileEntry.value.contentType ?? 'unknown'}''',
            );
          }
        }
      }

      cprint(
        "├------------------------------------------------------------------------------",
      );
      cprint('''| QueryParameters: $queryParameters''');
      cprint(
        "├------------------------------------------------------------------------------",
      );
      handler.next(options);
    },
    onResponse: (Response response, handler) async {
      JsonEncoder encoder = const JsonEncoder.withIndent('        ');
      String prettyprint = encoder.convert(response.data);
      cprint("| Status code: ${response.statusCode}");
      cprint(
        "├------------------------------------------------------------------------------",
      );
      cprint("| Response: $prettyprint");
      cprint(
        "└------------------------------------------------------------------------------",
      );
      cprint(
        "================================================================================",
      );
      handler.next(response);
    },
    onError: (DioException error, handler) async {
      handler.next(error); //continue
    },
  );
}
