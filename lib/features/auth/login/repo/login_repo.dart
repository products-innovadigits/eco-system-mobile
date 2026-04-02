import 'package:core_system/core/utility/export.dart';

/// Prototype: simulated login — no backend. [LoginBloc] expects a Dio [Response].
abstract class LoginRepo {
  static Future<dynamic> login({
    required String username,
    required String password,
    ActiveSystemEnum systemTypeEnum = ActiveSystemEnum.projectManagement,
  }) async {
    await Future.delayed(const Duration(milliseconds: 400));
    final data = <String, dynamic>{
      'id': 1,
      'tokken': 'prototype_pm_access_token',
      'token': 'prototype_pms_bearer_token',
      'wellcomeMessage': 'Welcome to Eco System',
      'name': username.isNotEmpty ? username.split('@').first : 'Demo User',
      'email': username.isNotEmpty ? username : 'demo@ecosystem.app',
      'avatar': '',
    };
    return Response(
      requestOptions: RequestOptions(
        path: systemTypeEnum == ActiveSystemEnum.projectManagement
            ? ApiNames.login
            : ApiNames.pmsLogin,
      ),
      statusCode: 200,
      data: <String, dynamic>{'data': data},
    );
  }

  static Future<dynamic> strategyLogin({required String token}) async {
    await Future.delayed(const Duration(milliseconds: 200));
    return Response(
      requestOptions: RequestOptions(path: ApiNames.strategyLogin),
      statusCode: 200,
      data: <String, dynamic>{
        'data': {
          'id': 1,
          'tokken': token,
          'token': token,
          'wellcomeMessage': 'Strategy session',
          'name': 'Demo User',
          'email': 'demo@ecosystem.app',
          'avatar': '',
        },
      },
    );
  }
}
