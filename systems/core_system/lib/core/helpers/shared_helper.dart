import 'dart:developer';

import 'package:core_system/core/utility/export.dart';
import 'package:hive_flutter/hive_flutter.dart';

class CachingKey extends Enum<String> {
  const CachingKey(super.val);
  static const CachingKey user = CachingKey('user');
  static const CachingKey rememberMe = CachingKey('rememberMe');
  static const CachingKey token = CachingKey('token');
  static const CachingKey deviceToken = CachingKey('deviceToken');
  static const CachingKey isLogin = CachingKey('isLogin');
  static const CachingKey skipBoarding = CachingKey('skipBoarding');

  /// Module id from [SystemModule.id] chosen at login (e.g. `pms_system`).
  /// Used to restore [AppConfig.activeSystem] after app restart.
  static const CachingKey chosenSystemModuleId = CachingKey(
    'chosenSystemModuleId',
  );

  /// JSON array of module ids the user chose at login (customize mode). Empty/absent = all enabled modules.
  static const CachingKey allowedSystemModuleIds = CachingKey(
    'allowedSystemModuleIds',
  );
}

class SharedHelper {
  // static SharedPreferences? shared;
  static SharedHelper? sharedHelper = SharedHelper();
  static Box? box;
  static Future<void> init() async {
    if (box == null) {
      await Hive.initFlutter();
      // shared = await SharedPreferences.getInstance();
      box = await Hive.openBox('testBox');
      sharedHelper = SharedHelper();
    }
  }

  void removeData(CachingKey key) async {
    box!.delete(key.value);
  }

  Future<void> saveUser(
    // UserModel model,
    // {bool remember = false, String? password}
  ) async {
    // writeData(CachingKey.TOKEN, model.accessToken);
    writeData(CachingKey.skipBoarding, true);
    writeData(CachingKey.isLogin, true);
    // writeData(CachingKey.USER, json.encode(model.toJson()));
    // log('SAVE USER INFO >>> ${json.encode(model.toJson())}');
    // writeData(
    //     CachingKey.REMEMBER_ME,
    //     jsonEncode({
    //       'email': remember ? model.email : '',
    //       'password': remember ? password : '',
    //       'type': 'mobile'
    //     }));
  }

  Future<UserModel> getUser() async {
    UserModel user;
    user = UserModel.fromJson(jsonDecode(box!.get(CachingKey.user.value)!));
    cprint('USER INFO >>> ${user.toJson()}');
    return user;
  }

  Future<void> clear(CachingKey key) async {
    box!.clear();
  }

  Future<void> logout() async {
    String currentLang = await allTranslations.getPreferredLanguage();
    box!.clear();
    CustomNavigator.push(Routes.LOGIN, clean: true);

    SharedHelper.sharedHelper!.writeData(CachingKey.skipBoarding, true);
    allTranslations.setNewLanguage(currentLang, true);
    allTranslations.setPreferredLanguage(currentLang);
  }

  Future<Map<String, dynamic>> remember() async {
    return jsonDecode(box!.get(CachingKey.rememberMe.value) ?? '{}');
  }

  Future<void> writeData(CachingKey key, value) async {
    log("Saving => $value local => with key ${key.value}");
    if (value is String) {
      box!.put(key.value, value);
    } else if (value is int) {
      box!.put(key.value, value);
    } else if (value is bool) {
      box!.put(key.value, value);
    } else if (value is double) {
      box!.put(key.value, value);
    } else {
      return;
    }
  }

  Future<bool> readBoolean(CachingKey key) async {
    return Future.value(box!.get(key.value) ?? false);
  }

  Future<double> readDouble(CachingKey key) async {
    return Future.value(box!.get(key.value) ?? 0.0);
  }

  Future<int> readInteger(CachingKey key) async {
    return Future.value(box!.get(key.value) ?? 0);
  }

  Future<String> readString(CachingKey key) async {
    return Future.value(box!.get(key.value) ?? "");
  }
}
