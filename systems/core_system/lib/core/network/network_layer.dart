// ignore_for_file: constant_identifier_names
import 'dart:developer' as developer;
import 'dart:io';

import 'package:dio/io.dart';

import '../config/app_config.dart';
import '../debug/debug_interceptor.dart';
import '../debug/debug_log_store.dart';
import '../utility/export.dart';
import 'api_error_toast_interceptor.dart';
import 'error/api_error_handler.dart';
import 'error/network_exception.dart';
import 'network_logger.dart';

enum ServerMethods { GET, POST, UPDATE, DELETE, PUT, PATCH }

class Network {
  static Network? _instance;
  static final Dio _dio = Dio();
  bool isActiveUser = true;

  Network._private();

  /// Adds an interceptor to the Dio instance.
  /// Use this to add app-layer interceptors like AuthInterceptor.
  static void addInterceptor(Interceptor interceptor) {
    _dio.interceptors.add(interceptor);
  }

  factory Network() {
    if (_instance == null) {
      _dio.options.connectTimeout = const Duration(seconds: 40);
      _dio.interceptors.add(NetworkLogger.logger);
      // Before the toast interceptor, so a failure is captured as it comes off
      // the wire rather than after the error has been handled.
      if (AppConfig.enableDebugOverlay) {
        _dio.interceptors.add(DebugInterceptor());
      }
      _dio.interceptors.add(ApiErrorToastInterceptor());

      // if (kDebugMode) {
      // 👇 Add this block to ignore SSL certificates
      (_dio.httpClientAdapter as IOHttpClientAdapter).createHttpClient = () {
        final client = HttpClient();
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
    String? baseUrl,
    ActiveSystemEnum systemTypeEnum = ActiveSystemEnum.strategy,
    Mapper? model,
    Map<String, dynamic>? query,
    Map<String, dynamic>? header,
    ServerMethods method = ServerMethods.GET,
    bool showErrorToast = true,
  }) async {
    // final bool isConnected = await ConnectivityService().checkConnection();
    // if (!isConnected) {
    //   AppCore.errorToastMessage(
    //     allTranslations.text(LocaleKeys.no_internet_connection),
    //   );
    //
    //   throw SocketException('No internet connection');
    // }
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
        (baseUrl ?? AppConfig.getBaseUrl(systemTypeEnum)) + endpoint,
        data: body,
        queryParameters: query,
        options: Options(
          method: method.name,
          extra: ApiErrorToastInterceptor.optionsExtra(
            showErrorToast: showErrorToast,
          ),
        ),
      );
      isActiveUser = true;
      if (model == null) {
        return response;
      } else {
        return mapResponse(model, response);
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

  /// Makes a network request and throws [NetworkException] on failure.
  ///
  /// Unlike [request], this method throws exceptions instead of returning
  /// error strings, making it easier to handle errors with try-catch.
  Future<dynamic> requestOrThrow(
    String endpoint, {
    body,
    String? baseUrl,
    ActiveSystemEnum systemTypeEnum = ActiveSystemEnum.projectManagement,
    Mapper? model,
    Map<String, dynamic>? query,
    Map<String, dynamic>? header,
    ServerMethods method = ServerMethods.GET,
    bool showErrorToast = true,
  }) async {
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
        (baseUrl ?? AppConfig.getBaseUrl(systemTypeEnum)) + endpoint,
        data: body,
        queryParameters: query,
        options: Options(
          method: method.name,
          extra: ApiErrorToastInterceptor.optionsExtra(
            showErrorToast: showErrorToast,
          ),
        ),
      );
      isActiveUser = true;
      if (model == null) {
        return response;
      } else {
        return mapResponse(model, response);
      }
    } on DioException catch (e) {
      throw ApiErrorHandler.getException(e);
    } on SocketException catch (e) {
      throw SocketException(e.toString());
    } on FormatException catch (_) {
      throw const FormatException("Unable to process the data");
    } catch (e) {
      rethrow;
    }
  }

  /// Maps [response] onto [model], reporting a failure before rethrowing it.
  ///
  /// Callers usually catch everything and show a generic error, so a field
  /// whose JSON type no longer matches its model (a String where the model
  /// declares `num?`) would otherwise leave no trace. The error names the
  /// types involved and the top stack frame is the `fromJson` line that threw.
  ///
  /// Logged here because the `on FormatException` clauses in [request] and
  /// [requestOrThrow] replace the original error with a generic one.
  @visibleForTesting
  static Mapper mapResponse(Mapper model, Response response) {
    try {
      return Mapper(model, response.data);
    } catch (error, stackTrace) {
      final options = response.requestOptions;
      final summary =
          'Failed to parse ${model.runtimeType} from '
          '${options.method} ${options.uri}';
      developer.log(
        summary,
        name: 'Network',
        level: 1000,
        error: error,
        stackTrace: stackTrace,
      );
      final logId = DebugInterceptor.logIdOf(options);
      if (logId != null) {
        final frames = stackTrace.toString().split('\n').take(8).join('\n');
        DebugLogStore.instance.logError(
          id: logId,
          error: '$summary\n\n$error\n\n$frames',
        );
      }
      rethrow;
    }
  }
}

// Future<bool> _hasInternetConnection() async {
//   try {
//     final result = await InternetAddress.lookup('example.com');
//     return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
//   } on SocketException {
//     return false;
//   } catch (_) {
//     return false;
//   }
// }
