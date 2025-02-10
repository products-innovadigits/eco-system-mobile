import 'package:eco_system/config/api_names.dart';
import 'package:eco_system/network/network_layer.dart';

abstract class LoginRepo {
  static Future<dynamic> login({
    required String username,
    required String password,
  }) async {
    return await Network().request(
      ApiNames.login,
      body: {
        "login": username,
        "password": password,
      },
      method: ServerMethods.POST,
    );
  }
}
