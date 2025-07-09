// ignore_for_file: constant_identifier_names
import 'dart:io';

import 'package:dio/io.dart';

import '../config/app_config.dart';
import '../utility/export.dart';
import 'error/api_error_handler.dart';
import 'network_logger.dart';

enum ServerMethods { GET, POST, UPDATE, DELETE, PUT, PATCH }

class Network {
  static Network? _instance;
  static final Dio _dio = Dio();
  bool isActiveUser = true;

  Network._private();

  factory Network() {
    if (_instance == null) {
      _dio.options.connectTimeout = const Duration(seconds: 40);
      _dio.interceptors.add(NetworkLogger.logger);

      // if (kDebugMode) {
        // 👇 Add this block to ignore SSL certificates
        (_dio.httpClientAdapter as IOHttpClientAdapter).onHttpClientCreate =
            (client) {
          client.badCertificateCallback =
              (X509Certificate cert, String host, int port) => true;
          return client;
        };
        _instance = Network._private();
      // }
    }

    return _instance!;
  }

  Future<dynamic> request(
    String endpoint, {
    body,
    String systemType = 'strategy',
    Mapper? model,
    Map<String, dynamic>? query,
    Map<String, dynamic>? header,
    ServerMethods method = ServerMethods.GET,
  }) async {
    // String token = await SharedHelper().readString(CachingKey.TOKEN);
    String token = await SecureStorageHelper().getToken();

    _dio.options.headers = {
      'Authorization': 'Bearer $token',
      'Accept': 'application/json',
      "User-Agent": "Dart",
      'Lang': mainAppBloc.lang.value,
    };
    if (header != null) {
      _dio.options.headers.addAll(header);
    }
    try {
      Response response = await _dio.request(
        (systemType == 'strategy'
                ? AppConfig.strategyBaseUrl
                : AppConfig.atsBaseUrl) +
            endpoint,
        data: body,
        queryParameters: query,
        options: Options(
          method: method.name,
        ),
      );
      isActiveUser = true;
      if (model == null) {
        return response;
      } else {
        return Mapper(model, response.data);
      }
    } on DioException catch (e) {
      return ApiErrorHandler.getMessage(e);
    } on SocketException catch (e) {
      throw SocketException(e.toString());
    } on FormatException catch (_) {
      throw const FormatException("Unable to process the data");
    } catch (e) {
      rethrow;
    }
  }
}
