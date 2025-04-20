import 'dart:convert';
import 'dart:developer';

import 'package:eco_system/core/enums.dart';
import 'package:eco_system/helpers/translation/all_translation.dart';
import 'package:eco_system/navigation/custom_navigation.dart';
import 'package:eco_system/navigation/routes.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../features/auth/login/model/user_model.dart';

class CachingKey extends Enum<String> {
  const CachingKey(String val) : super(val);
  static const CachingKey USER = CachingKey('USER');
  static const CachingKey REMEMBER_ME = CachingKey('USER');
  static const CachingKey TOKEN = CachingKey('REAL_TOKEN');
  static const CachingKey DEVICE_TOKEN = CachingKey('DEVICE_TOKEN');
  static const CachingKey IS_LOGIN = CachingKey('IS_LOGIN');
  static const CachingKey SKIP = CachingKey('SKIP');
  static const CachingKey PERSONAL_ID = CachingKey('PERSONAL_ID');
  static const CachingKey SITE_ID = CachingKey('SITE_ID');
  static const CachingKey URL_CODE = CachingKey('URL_CODE');
  static const CachingKey USER_LAT = CachingKey('USER_LAT');
  static const CachingKey USER_LONG = CachingKey('USER_LONG');
  static const CachingKey CHECK_LOCATION = CachingKey('CHECK_LOCATION');
  static const CachingKey ADDRESS = CachingKey('ADDRESS');
  static const CachingKey COUNTRY = CachingKey('COUNTRY');
  static const CachingKey COUNTRY_NAME = CachingKey('COUNTRY_NAME');
  static const CachingKey IS_OPEN_SITTING = CachingKey('IS_OPEN_SITTING');
  static const CachingKey USER_SECOND = CachingKey('USER_SECOND');
  static const CachingKey USER_MINUTE = CachingKey('USER_MINUTE');
  static const CachingKey USER_HOURS = CachingKey('USER_HOURS');
}

class SharedHelper {
  // static SharedPreferences? shared;
  static SharedHelper? sharedHelper = SharedHelper();
  static Box? box;
  static init() async {
    if (box == null) {
      await Hive.initFlutter();
      // shared = await SharedPreferences.getInstance();
      box = await Hive.openBox('testBox');
      sharedHelper = SharedHelper();
    }
  }

  removeData(CachingKey key) async {
    box!.delete(key.value);
  }

  Future<void> saveUser(UserModel model,
      {bool remember = false, String? password}) async {
    writeData(CachingKey.TOKEN, model.accessToken);
    writeData(CachingKey.SKIP, true);
    writeData(CachingKey.IS_LOGIN, true);
    writeData(CachingKey.USER, json.encode(model.toJson()));
    log('SAVE USER INFO >>> ${json.encode(model.toJson())}');
    // writeData(
    //     CachingKey.REMEMBER_ME,
    //     jsonEncode({
    //       'email': remember ? model.email : '',
    //       'password': remember ? password : '',
    //       'type': 'mobile'
    //     }));
  }

  Future<UserModel> getUser() async {
    UserModel _user;
    _user = UserModel.fromJson(jsonDecode(box!.get(CachingKey.USER.value)!));
    log('USER INFO >>> ${_user.toJson()}');
    return _user;
  }

  clear(CachingKey key) async {
    box!.clear();
  }

  logout() async {
    String currentLang = await allTranslations.getPreferredLanguage();
    box!.clear();
    CustomNavigator.push(Routes.SPLASH, clean: true);

    SharedHelper.sharedHelper!.writeData(CachingKey.SKIP, true);
    allTranslations.setNewLanguage(currentLang, true);
    allTranslations.setPreferredLanguage(currentLang);
  }

  Future<Map<String, dynamic>> remember() async {
    return jsonDecode(box!.get(CachingKey.REMEMBER_ME.value) ?? '{}');
  }

  Future<Map<String, dynamic>> forgetCredentials() async {
    return removeData(CachingKey.REMEMBER_ME);
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
      return null;
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
