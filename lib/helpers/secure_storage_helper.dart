import 'dart:convert';

import 'package:eco_system/features/auth/login/model/user_model.dart';
import 'package:eco_system/helpers/shared_helper.dart';
import 'package:eco_system/utility/utility.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageHelper {
  static SecureStorageHelper? secureStorageHelper = SecureStorageHelper();
  static const FlutterSecureStorage _storage = FlutterSecureStorage();

  static init() async {
    secureStorageHelper ??= SecureStorageHelper();
  }

  Future<void> saveUser(UserModel model) async {
    await _storage.write(key: CachingKey.TOKEN.value, value: model.accessToken);
    await _storage.write(
        key: CachingKey.USER.value, value: json.encode(model.toJson()));
    cprint('SAVE USER INFO >>> ${json.encode(model.toJson())}');
  }

  Future<UserModel> getUser() async {
    String? userData = await _storage.read(key: CachingKey.USER.value);
    if (userData == null) {
      throw Exception('No user data found');
    }
    UserModel user = UserModel.fromJson(jsonDecode(userData));
    cprint('USER INFO >>> ${user.toJson()}');
    return user;
  }

  Future<String> getToken() async {
    String token = await _storage.read(key: CachingKey.TOKEN.value) ?? '';
    return token;
  }

  Future<void> clearAll() async {
    await _storage.deleteAll();
  }

  Future<void> deleteUser() async {
    await _storage.delete(key: CachingKey.USER.value);
    await _storage.delete(key: CachingKey.TOKEN.value);
  }
}
