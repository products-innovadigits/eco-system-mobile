import 'package:core_system/core/utility/export.dart';

abstract class LoginRepo {
  static Future<dynamic> login({
    required String username,
    required String password,
    ActiveSystemEnum systemTypeEnum = ActiveSystemEnum.projectManagement,
  }) async {
    return await Network().request(
      ApiNames.login,
      body: {"login": username, "password": password},
      systemTypeEnum: systemTypeEnum,
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
