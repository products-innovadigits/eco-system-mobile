import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../utility/utility.dart';

class NetworkLogger {
  static String _maskAuthorizationHeader(String value) {
    final trimmed = value.trim();
    const bearer = 'Bearer ';
    if (trimmed.length > bearer.length + 8 &&
        trimmed.toLowerCase().startsWith(bearer.toLowerCase())) {
      final token = trimmed.substring(bearer.length);
      final prefix = token.length >= 8 ? token.substring(0, 8) : token;
      return 'Bearer $prefix...<masked>';
    }
    return '<masked>';
  }

  static String _headersForLog(Map<String, dynamic> rawHeaders) {
    final buf = StringBuffer();
    rawHeaders.forEach((key, value) {
      final k = key.toString();
      final lower = k.toLowerCase();
      if (lower == 'authorization') {
        buf.write('$k: ${_maskAuthorizationHeader(value.toString())} | ');
      } else if (lower.contains('api-key') || lower == 'x-api-key') {
        buf.write('$k: <masked> | ');
      } else {
        buf.write('$k: $value | ');
      }
    });
    return buf.toString();
  }

  static final logger = InterceptorsWrapper(
    onRequest: (RequestOptions options, handler) {
      final headers = _headersForLog(options.headers);

      String body = "";
      String queryParameters = "";
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
      } else if (options.data is Map) {
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
      cprint("| Status code: ${response.statusCode}");
      cprint(
        "├------------------------------------------------------------------------------",
      );
      if (kReleaseMode) {
        cprint("| Response: <omitted in release build>");
      } else {
        final encoder = const JsonEncoder.withIndent('        ');
        try {
          final prettyprint = encoder.convert(response.data);
          const maxLen = 8000;
          if (prettyprint.length > maxLen) {
            cprint(
              "| Response (truncated): ${prettyprint.substring(0, maxLen)}…",
            );
          } else {
            cprint("| Response: $prettyprint");
          }
        } catch (_) {
          cprint("| Response: ${response.data}");
        }
      }
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
