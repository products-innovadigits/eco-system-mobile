import 'package:core_package/core/utility/export.dart';

abstract class KeyboardOperations{
  static bool isKeyboardOpen(){
    if(MediaQueryHelper.appMediaQueryViewInsets.bottom == 0.0){
      return false ;
    }else{
      return true ;
    }
  }
}