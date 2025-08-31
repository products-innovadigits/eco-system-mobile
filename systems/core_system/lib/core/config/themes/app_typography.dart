import 'package:core_system/core/config/colors/light_colors.dart';
import 'package:core_system/core/helpers/font_sizes.dart';
import 'package:core_system/core/helpers/styles.dart';
import 'package:flutter/material.dart';

abstract class AppTypography {
  // Display
  static TextStyle get displayLarge => TextStyle(
    fontSize: FontSizes.f32,
    fontWeight: FontWeight.w700,
    fontFamily: Styles.FONT_AR,
    color: LightColor.primary,
  );

  static TextStyle get displayMedium => TextStyle(
    fontSize: FontSizes.f28,
    fontWeight: FontWeight.w700,
    fontFamily: Styles.FONT_AR,
    color: LightColor.primary,
  );

  static TextStyle get displaySmall => TextStyle(
    fontSize: FontSizes.f26,
    fontWeight: FontWeight.w700,
    fontFamily: Styles.FONT_AR,
    color: LightColor.primary,
  );

  // Headline
  static TextStyle get headlineLarge => TextStyle(
    fontSize: FontSizes.f24,
    fontWeight: FontWeight.w700,
    fontFamily: Styles.FONT_AR,
    color: LightColor.primary,
  );

  static TextStyle get headlineMedium => TextStyle(
    fontSize: FontSizes.f22,
    fontWeight: FontWeight.w600,
    fontFamily: Styles.FONT_AR,
    color: LightColor.primary,
  );

  static TextStyle get headlineSmall => TextStyle(
    fontSize: FontSizes.f20,
    fontWeight: FontWeight.w500,
    fontFamily: Styles.FONT_AR,
    color: LightColor.primary,
  );

  // Title
  static TextStyle get titleLarge => TextStyle(
    fontSize: FontSizes.f18,
    fontWeight: FontWeight.w700,
    fontFamily: Styles.FONT_AR,
    color: LightColor.primary,
  );

  static TextStyle get titleMedium => TextStyle(
    fontSize: FontSizes.f16,
    fontWeight: FontWeight.w500,
    fontFamily: Styles.FONT_AR,
    color: LightColor.primary,
  );

  static TextStyle get titleSmall => TextStyle(
    fontSize: FontSizes.f14,
    fontWeight: FontWeight.w500,
    fontFamily: Styles.FONT_AR,
    color: LightColor.primary,
  );

  // Body
  static TextStyle get bodyLarge => TextStyle(
    fontSize: FontSizes.f16,
    fontWeight: FontWeight.w400,
    fontFamily: Styles.FONT_AR,
    color: LightColor.primary,
  );

  static TextStyle get bodyMedium => TextStyle(
    fontSize: FontSizes.f14,
    fontWeight: FontWeight.w400,
    fontFamily: Styles.FONT_AR,
    color: LightColor.primary,
  );

  static TextStyle get bodySmall => TextStyle(
    fontSize: FontSizes.f12,
    fontWeight: FontWeight.w400,
    fontFamily: Styles.FONT_AR,
    color: LightColor.primary,
  );

  // Label
  static TextStyle get labelLarge => TextStyle(
    fontSize: FontSizes.f16,
    fontWeight: FontWeight.w500,
    fontFamily: Styles.FONT_AR,
    color: LightColor.primary,
  );

  static TextStyle get labelMedium => TextStyle(
    fontSize: FontSizes.f14,
    fontWeight: FontWeight.w500,
    fontFamily: Styles.FONT_AR,
    color: LightColor.primary,
  );

  static TextStyle get labelSmall => TextStyle(
    fontSize: FontSizes.f12,
    fontWeight: FontWeight.w500,
    fontFamily: Styles.FONT_AR,
    color: LightColor.primary,
  );
}
