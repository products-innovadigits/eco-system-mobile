// ignore_for_file: constant_identifier_names

import 'dart:io';
import 'package:dio/dio.dart';
import 'package:eco_system/bloc/main_app_bloc.dart';
import '../config/app_config.dart';
import '../helpers/shared_helper.dart';
import '../utility/utility.dart';
import 'mapper.dart';
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
      _instance = Network._private();
    }
    return _instance!;
  }

  Future<dynamic> request(
    String endpoint, {
    body,
    Mapper? model,
    Map<String, dynamic>? query,
    Map<String, dynamic>? header,
    ServerMethods method = ServerMethods.GET,
  }) async {
    String token = await SharedHelper().readString(CachingKey.TOKEN);

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
        AppConfig.baseUrl + endpoint,
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
    } on SocketException catch (e) {
      cprint(
        "SocketException: ${e.address}",
        errorIn: AppConfig.baseUrl + endpoint,
        label: "SocketException",
      );
      cprint(
          "└------------------------------------------------------------------------------");
      cprint(
          "================================================================================");
      rethrow;
    } on DioException catch (e) {
      cprint(
        "| Error: ${e.error}: ${e.response?.toString()}",
        errorIn: AppConfig.baseUrl + endpoint,
        label: "DioError",
      );
      cprint(
          "└------------------------------------------------------------------------------");
      cprint(
          "================================================================================");
      if (model == null) {
        return e.response;
      } else {
        return Mapper(model, e.response?.data);
      }
    } catch (error) {
      cprint(
        "Unhandled Exception: $error",
        errorIn: AppConfig.baseUrl + endpoint,
        label: "Unhandled Exception",
      );
      cprint(
          "└------------------------------------------------------------------------------");
      cprint(
          "================================================================================");
      rethrow;
    }
  }
}
