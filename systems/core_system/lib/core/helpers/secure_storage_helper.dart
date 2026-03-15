import 'package:core_system/core/utility/export.dart';

class SecureStorageHelper {
  static SecureStorageHelper? secureStorageHelper = SecureStorageHelper();
  static const FlutterSecureStorage _storage = FlutterSecureStorage();

  static Future<void> init() async {
    secureStorageHelper ??= SecureStorageHelper();
  }

  Future<void> saveUser(UserModel model , {String? token}) async {
    await _storage.write(key: CachingKey.token.value, value: token);
    await _storage.write(
      key: CachingKey.user.value,
      value: json.encode(model.toJson()),
    );
    cprint('SAVE USER INFO >>> ${json.encode(model.toJson())}');
  }

  Future<UserModel> getUser() async {
    String? userData = await _storage.read(key: CachingKey.user.value);
    if (userData == null) {
      throw Exception('No user data found');
    }
    UserModel user = UserModel.fromJson(jsonDecode(userData));
    cprint('USER INFO >>> ${user.toJson()}');
    return user;
  }

  Future<String> getToken() async {
    String token = await _storage.read(key: CachingKey.token.value) ?? '';
    return token;
  }

  Future<void> clearAll() async {
    await _storage.deleteAll();
  }

  Future<void> deleteUser() async {
    await _storage.delete(key: CachingKey.user.value);
    await _storage.delete(key: CachingKey.token.value);
  }
}
