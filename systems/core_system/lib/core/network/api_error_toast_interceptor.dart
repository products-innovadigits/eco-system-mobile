import 'package:dio/dio.dart';

import '../core/app_core.dart';
import 'error/api_error_handler.dart';

/// Shows a toast with the message the API sent on a failed request, so every
/// screen reports backend errors the same way without repeating the toast.
///
/// The API reports failures with a localized text in
/// `validationErrors[].errorMessageEn`, which [ApiErrorHandler.getApiMessage]
/// reads, e.g. a 400 out of `ProjectProcess/next`:
///   {"succeeded": false, "data": null, "warningErrors": null,
///    "validationErrors": [{"errorCode": "-1", "errorMessage": "-1",
///     "errorMessageEn": "Invalid object name 'dbo.SystemCounters'."}]}
///
/// Deliberately silent in two cases:
///  - the response carries no message (connection blips, timeouts, empty
///    bodies), where the screens show their own error state instead,
///  - 401, where `AuthInterceptor` logs the user out and the toast would only
///    add noise to that.
///
/// A single call can opt out by passing `showErrorToast: false` to
/// `Network.request` / `Network.requestOrThrow`, for screens that already show
/// the error themselves.
///
/// Registered on the Dio instance in [Network].
class ApiErrorToastInterceptor extends Interceptor {
  /// Key holding the opt out flag in the request `extra` map.
  static const String showErrorToastKey = 'showErrorToast';

  /// Builds the `extra` map carrying the opt out flag down to [onError].
  static Map<String, dynamic> optionsExtra({required bool showErrorToast}) => {
    showErrorToastKey: showErrorToast,
  };

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (_shouldShowToast(err)) {
      final String? message = ApiErrorHandler.getApiMessage(err);
      if (message != null) {
        AppCore.errorToastMessage(message);
      }
    }
    handler.next(err);
  }

  bool _shouldShowToast(DioException err) {
    if (err.response?.statusCode == 401) return false;
    return err.requestOptions.extra[showErrorToastKey] != false;
  }
}
