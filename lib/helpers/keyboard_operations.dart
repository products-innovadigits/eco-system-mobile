import 'dart:math';

import 'package:flutter/material.dart';
import 'package:eco_system/helpers/media_query_helper.dart';
import 'package:eco_system/navigation/custom_navigation.dart';
abstract class KeyboardOperations{
  static bool isKeyboardOpen(){
    if(MediaQueryHelper.appMediaQueryViewInsets.bottom == 0.0){
      return false ;
    }else{
      return true ;
    }
  }
}