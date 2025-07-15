import 'package:core_package/core/utility/export.dart';

abstract class LoginRepo {
  static Future<dynamic> login({
    required String username,
    required String password,
  }) async {
    return await Network().request(
      ApiNames.login,
      // baseUrl: AppConfig.authBaseUrl,
      body: {
        "login": username,
        // "email": username,
        "password": password,
      },
      method: ServerMethods.POST,
    );
  }

  static Future<dynamic> strategyLogin({required String token}) async {
    return await Network().request(
      ApiNames.strategyLogin,
      body: {"token": token},
      method: ServerMethods.POST,
    );
  }
}
