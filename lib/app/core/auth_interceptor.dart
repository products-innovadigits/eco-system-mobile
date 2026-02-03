import 'package:core_system/core/helpers/shared_helper.dart';
import 'package:dio/dio.dart';

/// Interceptor that handles authentication-related responses.
/// On 401 Unauthorized, triggers logout and navigates to splash screen.
///
/// This interceptor should be registered with the Network layer at app startup:
/// ```dart
/// Network.addInterceptor(AuthInterceptor());
/// ```
class AuthInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (err.response?.statusCode == 401) {
      _handleUnauthorized();
    }
    handler.next(err);
  }

  Future<void> _handleUnauthorized() async {
    final isLoggedIn = await SharedHelper.sharedHelper?.readBoolean(
      CachingKey.isLogin,
    );
    if (isLoggedIn == true) {
      await SharedHelper.sharedHelper?.logout();
    }
  }
}
