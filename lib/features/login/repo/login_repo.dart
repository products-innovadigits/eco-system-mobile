import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:eco_system/app_config/api_names.dart';
import 'package:eco_system/app_config/app_config.dart';
import 'package:eco_system/features/login/model/user_model.dart';
import 'package:eco_system/helpers/text_helper.dart';
import 'package:eco_system/network/network_layer.dart';

abstract class LoginRepo {
  static Future<dynamic> login({
      @required String? username,
      @required String? password}) async {

    return await Network()
        .request('${ApiNames.LOGIN}?email=$username&password=$password',method: ServerMethods.POST,
            model: UserModel());
  }
}
