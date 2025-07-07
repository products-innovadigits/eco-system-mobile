import 'package:core_package/core/utility/export.dart';

abstract class MediaQueryHelper{

  static get instance => MediaQuery.of(CustomNavigator.navigatorState.currentContext!);


  static Size get  appMediaQuerySize => instance.size;
  static double get  width => appMediaQuerySize.width;
  static double get  height => appMediaQuerySize.height;

  static EdgeInsets get appMediaQueryPadding => instance.padding;
  static double get topPadding => appMediaQueryPadding.top;

  static EdgeInsets get appMediaQueryViewPadding => instance.viewPadding;

  static EdgeInsets get  appMediaQueryViewInsets => instance.viewInsets;
}