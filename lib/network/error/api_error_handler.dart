import 'dart:developer';
import 'package:dio/dio.dart';
import '../../helpers/shared_helper.dart';
import '../../helpers/translation/all_translation.dart';

class ApiErrorHandler {
  static dynamic getMessage(error) async {
    dynamic errorDescription = "";
    if (error is Exception) {
      try {
        if (error is DioException) {
          switch (error.type) {
            case DioExceptionType.cancel:
              errorDescription = "Request to API server was cancelled";
              break;
            case DioExceptionType.connectionTimeout:
              errorDescription = "Connection timeout with API server";
              break;
            case DioExceptionType.unknown:
              errorDescription =
                  "Connection to API server failed due to internet connection";
              break;
            case DioExceptionType.receiveTimeout:
              errorDescription =
                  "Receive timeout in connection with API server";
              break;
            case DioExceptionType.badResponse:
              switch (error.response!.statusCode) {
                case 404:
                  errorDescription = error.response!.data["message"];
                  break;
                case 401:
                  if (await SharedHelper.sharedHelper
                          ?.readBoolean(CachingKey.IS_LOGIN) ==
                      true) {
                    SharedHelper.sharedHelper?.logout();
                  }
                  errorDescription =
                      allTranslations.text("your_session_has_been_expired");
                  break;
                case 500:
                  errorDescription = error.response!.data["message"];
                  break;
                case 503:
                  errorDescription = error.response!.statusMessage;
                  break;
                default:
                  log(error.response!.data.toString());

                  try {
                    errorDescription = error.response!.data["message"];
                  } catch (e) {
                    errorDescription = error.response!.data['data']["message"];
                  }
              }
              break;
            case DioExceptionType.sendTimeout:
              errorDescription = "Send timeout with server";
              break;
            case DioExceptionType.badCertificate:
              errorDescription = "Bad Certificate with server";
              break;
            case DioExceptionType.connectionError:
              errorDescription = "Connection Error with server";
              break;
          }
        } else {
          errorDescription = "Unexpected error occurred";
        }
      } on FormatException catch (e) {
        errorDescription = e.toString();
      }
    } else {
      errorDescription = error.toString();
    }
    return errorDescription;
  }
}
