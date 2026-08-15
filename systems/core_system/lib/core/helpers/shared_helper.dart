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

  /// [ActiveSystemEnum.value] of the system chosen at login (e.g. `pms`).
  /// Read back by `ActiveSystem.restore()` after a cold start.
  static const CachingKey chosenSystem = CachingKey('chosenSystem');

  /// Pre-unification key, which held the module id instead of the enum value.
  /// Only read, never written — see `ActiveSystem.restore()`.
  static const CachingKey legacyChosenSystemModuleId = CachingKey(
    'chosenSystemModuleId',
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

  /// Clears local session and navigates to [navigateTo] (defaults to splash).
  Future<void> logout({String navigateTo = Routes.SPLASH}) async {
    String currentLang = await allTranslations.getPreferredLanguage();
    box!.clear();

    /// The persisted choice went with the box; drop the in-memory copy too, or
    /// the next sign-in starts out pointed at the previous user's system.
    ActiveSystem.reset();
    CustomNavigator.push(navigateTo, clean: true);

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
