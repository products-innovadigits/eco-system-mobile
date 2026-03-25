import 'package:core_system/core/utility/export.dart';

abstract class LoginRepo {
  static Future<dynamic> login({
    required String username,
    required String password,
    ActiveSystemEnum systemTypeEnum = ActiveSystemEnum.projectManagement,
  }) async {
    return await Network().request(
      // ApiNames.login,
      systemTypeEnum == ActiveSystemEnum.projectManagement
          ? ApiNames.login
          : ApiNames.pmsLogin,
      // body: {"login": username, "password": password},
      body: {
        (systemTypeEnum == ActiveSystemEnum.projectManagement
                ? "login"
                : "email"):
            username,
        "password": password,
      },
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
