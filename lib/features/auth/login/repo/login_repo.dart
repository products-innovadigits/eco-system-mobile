import 'package:core_package/core/utility/export.dart';

abstract class LoginRepo {
  static Future<dynamic> login({
    required String username,
    required String password,
  }) async {
    return await Network().request(
      ApiNames.login,
      body: {
        "login": username,
        // "email": username,
        "password": password,
      },
      method: ServerMethods.POST,
    );
  }
}
