import 'package:core_package/core/config/colors/light_colors.dart';
import 'package:core_package/core/helpers/font_sizes.dart';
import 'package:core_package/core/helpers/styles.dart';
import 'package:flutter/material.dart';

abstract class AppTypography {
  // Display
  static const displayLarge = TextStyle(
      fontSize: FontSizes.f32,
      fontWeight: FontWeight.w700,
      fontFamily: Styles.FONT_AR,
      color: LightColor.primary);
  static const displayMedium = TextStyle(
      fontSize: FontSizes.f28,
      fontWeight: FontWeight.w700,
      fontFamily: Styles.FONT_AR,
      color: LightColor.primary);
  static const displaySmall = TextStyle(
      fontSize: FontSizes.f26,
      fontWeight: FontWeight.w700,
      fontFamily: Styles.FONT_AR,
      color: LightColor.primary);

  // Headline
  static const headlineLarge = TextStyle(
      fontSize: FontSizes.f24,
      fontWeight: FontWeight.w700,
      fontFamily: Styles.FONT_AR,
      color: LightColor.primary);
  static const headlineMedium = TextStyle(
      fontSize: FontSizes.f22,
      fontWeight: FontWeight.w600,
      fontFamily: Styles.FONT_AR,
      color: LightColor.primary);
  static const headlineSmall = TextStyle(
      fontSize: FontSizes.f20,
      fontWeight: FontWeight.w500,
      fontFamily: Styles.FONT_AR,
      color: LightColor.primary);

  // Title
  static const titleLarge = TextStyle(
      fontSize: FontSizes.f18,
      fontWeight: FontWeight.w700,
      fontFamily: Styles.FONT_AR,
      color: LightColor.primary);
  static const titleMedium = TextStyle(
      fontSize: FontSizes.f16,
      fontWeight: FontWeight.w500,
      fontFamily: Styles.FONT_AR,
      color: LightColor.primary);
  static const titleSmall = TextStyle(
      fontSize: FontSizes.f14,
      fontWeight: FontWeight.w500,
      fontFamily: Styles.FONT_AR,
      color: LightColor.primary);

  // Body
  static const bodyLarge = TextStyle(
      fontSize: FontSizes.f16,
      fontWeight: FontWeight.w400,
      fontFamily: Styles.FONT_AR,
      color: LightColor.primary);
  static const bodyMedium = TextStyle(
      fontSize: FontSizes.f14,
      fontWeight: FontWeight.w400,
      fontFamily: Styles.FONT_AR,
      color: LightColor.primary);
  static const bodySmall = TextStyle(
      fontSize: FontSizes.f12,
      fontWeight: FontWeight.w400,
      fontFamily: Styles.FONT_AR,
      color: LightColor.primary);

  // Label
  static const labelLarge = TextStyle(
      fontSize: FontSizes.f16,
      fontWeight: FontWeight.w500,
      fontFamily: Styles.FONT_AR,
      color: LightColor.primary);
  static const labelMedium = TextStyle(
      fontSize: FontSizes.f14,
      fontWeight: FontWeight.w500,
      fontFamily: Styles.FONT_AR,
      color: LightColor.primary);
  static const labelSmall = TextStyle(
      fontSize: FontSizes.f12,
      fontWeight: FontWeight.w500,
      fontFamily: Styles.FONT_AR,
      color: LightColor.primary);
}
