// ignore_for_file: constant_identifier_names

import 'dart:io';

import 'package:dio/dio.dart';
import 'package:eco_system/bloc/main_app_bloc.dart';

import '../config/app_config.dart';
import '../helpers/shared_helper.dart';
import 'error/api_error_handler.dart';
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
