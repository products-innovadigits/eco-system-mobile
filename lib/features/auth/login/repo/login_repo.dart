import 'package:core_system/core/utility/export.dart';

abstract class LoginRepo {
  static Future<dynamic> login({
    required String username,
    required String password,
    ActiveSystemEnum systemTypeEnum = ActiveSystemEnum.projectManagement,
  }) async {
    final String endpoint;
    final Map<String, dynamic> body;
    if (systemTypeEnum == ActiveSystemEnum.projectManagement ||
        systemTypeEnum == ActiveSystemEnum.strategy) {
      endpoint = ApiNames.login;
      body = {'login': username, 'password': password};
    } else {
      endpoint = ApiNames.pmsLogin;
      body = {'email': username, 'password': password};
    }
    return await Network().request(
      endpoint,
      body: body,
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
