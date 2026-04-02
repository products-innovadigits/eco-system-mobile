import 'package:core_system/core/utility/export.dart';

/// Prototype: local theme defaults — no API.
abstract class SplashRepo {
  static Future<ColorSchemeModel> fetchColorScheme() async {
    await Future.delayed(const Duration(milliseconds: 150));
    return ColorSchemeModel(
      primary: const Color(0xFF1565C0),
      onPrimary: const Color(0xFFFFFFFF),
      secondary: const Color(0xFF00897B),
      onSecondary: const Color(0xFFFFFFFF),
      surface: const Color(0xFFF5F5F5),
      onSurface: const Color(0xFF1C1B1F),
    );
  }
}
