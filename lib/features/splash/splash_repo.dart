import 'package:core_system/core/utility/export.dart';

abstract class SplashRepo {
  static Future<ColorSchemeModel> fetchColorScheme() async {
    return await Network().request(
      ApiNames.colorScheme,
      method: ServerMethods.GET,
      model: ColorSchemeModel(),
    );
  }
}
