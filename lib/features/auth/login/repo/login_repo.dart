import 'package:core_system/core/utility/export.dart';

abstract class LoginRepo {
  /// Scope the ATS backend expects alongside the credentials.
  static const String _atsScope = 'user.mini';

  static Future<dynamic> login({
    required String username,
    required String password,
    ActiveSystemEnum systemTypeEnum = ActiveSystemEnum.projectManagement,
  }) async {
    return await Network().request(
      _endpoint(systemTypeEnum),
      body: _body(systemTypeEnum, username: username, password: password),
      systemTypeEnum: systemTypeEnum,
      method: ServerMethods.POST,
    );
  }

  /// Each system authenticates against its own backend, so the path is
  /// resolved per system and sent to that system's base URL.
  static String _endpoint(ActiveSystemEnum systemTypeEnum) {
    if (systemTypeEnum == ActiveSystemEnum.pms) return ApiNames.pmsLogin;
    if (systemTypeEnum == ActiveSystemEnum.ats) return ApiNames.atsLogin;
    return ApiNames.login;
  }

  static Map<String, dynamic> _body(
    ActiveSystemEnum systemTypeEnum, {
    required String username,
    required String password,
  }) {
    if (systemTypeEnum == ActiveSystemEnum.ats) {
      return {"email": username, "password": password, "scope": _atsScope};
    }
    if (systemTypeEnum == ActiveSystemEnum.pms) {
      return {"email": username, "password": password};
    }
    return {"login": username, "password": password};
  }

  static Future<dynamic> strategyLogin({required String token}) async {
    return await Network().request(
      ApiNames.strategyLogin,
      body: {"token": token},
      method: ServerMethods.POST,
    );
  }
}
