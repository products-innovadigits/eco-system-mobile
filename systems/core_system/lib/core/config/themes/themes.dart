import 'package:core_system/core/config/themes/app_typography.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../colors/dark_colors.dart';
import '../colors/light_colors.dart';

// final ThemeData _lightTheme = buildLightTheme();
final ThemeData _darkTheme = _buildDarkTheme();

ThemeData buildLightTheme() {
  final base = ThemeData.light();
  return base.copyWith(
    colorScheme: ColorScheme.light(
      surface: LightColor.scaffoldBg,
      surfaceContainer: LightColor.cardBg,
      primary: LightColor.primary,
      secondary: LightColor.secondary,
      tertiary: LightColor.tertiary,
      tertiaryContainer: LightColor.tertiaryLight,
      onSurface: LightColor.primary,
      outline: LightColor.border,
      outlineVariant: LightColor.placeHolderText,
      onPrimary: LightColor.white,
      error: LightColor.error,
      errorContainer: LightColor.warning,
    ),
    brightness: Brightness.light,
    primaryColor: LightColor.primary,
    primaryColorLight: LightColor.primaryColorLight,
    primaryColorDark: LightColor.primaryDark,
    secondaryHeaderColor: LightColor.secondary,
    canvasColor: LightColor.white,
    scaffoldBackgroundColor: LightColor.scaffoldBg,
    bottomAppBarTheme: const BottomAppBarThemeData(
      color: LightColor.white,
      elevation: 10,
    ),
    cardColor: LightColor.white,
    dividerColor: LightColor.grey,
    highlightColor: LightColor.grey,
    splashColor: LightColor.white,
    unselectedWidgetColor: LightColor.white,
    disabledColor: LightColor.primary.withValues(alpha: 0.3),
    toggleButtonsTheme: ToggleButtonsThemeData(color: LightColor.secondary),
    dialogTheme: DialogThemeData(backgroundColor: LightColor.white),
    tabBarTheme: TabBarThemeData(indicatorColor: LightColor.primary),
    hintColor: LightColor.primary,
    primaryTextTheme: Typography.material2018(
      platform: TargetPlatform.iOS,
    ).black,
    // textTheme: Typography.material2018(
    //   platform: TargetPlatform.iOS,
    // ).black,
    textTheme: TextTheme(
      bodyLarge: AppTypography.bodyLarge,
      bodyMedium: AppTypography.bodyMedium,
      bodySmall: AppTypography.bodySmall,
      displayLarge: AppTypography.displayLarge,
      displayMedium: AppTypography.displayMedium,
      displaySmall: AppTypography.displaySmall,
      headlineLarge: AppTypography.headlineLarge,
      headlineMedium: AppTypography.headlineMedium,
      headlineSmall: AppTypography.headlineSmall,
      titleLarge: AppTypography.titleLarge,
      titleMedium: AppTypography.titleMedium,
      titleSmall: AppTypography.titleSmall,
      labelLarge: AppTypography.labelLarge,
      labelMedium: AppTypography.labelMedium,
      labelSmall: AppTypography.labelSmall,
    ),
    primaryIconTheme: IconThemeData(color: LightColor.primary),
    buttonTheme: base.buttonTheme.copyWith(buttonColor: LightColor.primary),
    iconTheme: base.iconTheme.copyWith(color: LightColor.white),
    sliderTheme: const SliderThemeData().copyWith(
      valueIndicatorColor: LightColor.secondary,
      showValueIndicator: ShowValueIndicator.onlyForContinuous,
    ),
    visualDensity: VisualDensity.adaptivePlatformDensity,
    appBarTheme: base.appBarTheme.copyWith(
      centerTitle: true,
      elevation: 0,
      backgroundColor: LightColor.white,
      foregroundColor: LightColor.white,
      surfaceTintColor: LightColor.white,
      titleTextStyle: TextStyle(
        fontSize: 16,
        color: LightColor.primary,
        fontWeight: FontWeight.w700,
      ),
      // systemOverlayStyle: SystemUiOverlayStyle(
      //   systemNavigationBarColor: Colors.transparent,
      //   statusBarColor: Colors.transparent,
      //   systemNavigationBarIconBrightness: Brightness.light,
      //   statusBarIconBrightness: Brightness.light,
      //   statusBarBrightness: Brightness.dark,
      // ),
    ),
    pageTransitionsTheme: const PageTransitionsTheme(
      builders: {
        TargetPlatform.android: CupertinoPageTransitionsBuilder(),
        TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
      },
    ),
    inputDecorationTheme: InputDecorationTheme(
      isDense: true,
      hintStyle: const TextStyle(fontSize: 14, color: LightColor.grey),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: LightColor.greyLight),
      ),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
    ),
    dataTableTheme: DataTableThemeData(
      dataRowColor: WidgetStateProperty.all(LightColor.error),
      headingRowColor: WidgetStateProperty.all(LightColor.white),
      headingTextStyle: TextStyle(color: LightColor.error),
    ),
    snackBarTheme: base.snackBarTheme.copyWith(
      actionTextColor: LightColor.secondary,
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(foregroundColor: LightColor.grey),
    ),
    radioTheme: RadioThemeData(
      fillColor: WidgetStateProperty.all(LightColor.primary),
    ),
  );
}

ThemeData _buildDarkTheme() {
  final base = ThemeData.dark();
  return base.copyWith(
    colorScheme: const ColorScheme.light(
      secondary: DarkColor.secondary,
      primary: DarkColor.primary,
      error: DarkColor.brightRed,
      surface: DarkColor.offWhite,
    ),
    brightness: Brightness.light,
    primaryColor: DarkColor.primary,
    primaryColorLight: DarkColor.primary.withValues(alpha: 0.5),
    primaryColorDark: DarkColor.primary.withValues(alpha: 1),
    secondaryHeaderColor: DarkColor.secondary,
    canvasColor: DarkColor.offWhite,
    scaffoldBackgroundColor: DarkColor.black,
    bottomAppBarTheme: const BottomAppBarThemeData(color: DarkColor.offWhite),
    cardColor: DarkColor.offWhite,
    dividerColor: DarkColor.grey,
    highlightColor: DarkColor.grey,
    splashColor: DarkColor.offWhite,
    unselectedWidgetColor: DarkColor.offWhite,
    disabledColor: DarkColor.primary.withValues(alpha: 0.3),
    toggleButtonsTheme: const ToggleButtonsThemeData(
      color: DarkColor.secondary,
    ),
    dialogTheme: DialogThemeData(backgroundColor: DarkColor.offWhite),
    tabBarTheme: TabBarThemeData(indicatorColor: DarkColor.primary),
    hintColor: DarkColor.primary,
    primaryTextTheme: Typography.material2018(
      platform: TargetPlatform.iOS,
    ).white,
    textTheme: Typography.material2018(platform: TargetPlatform.iOS).white,
    primaryIconTheme: const IconThemeData(color: DarkColor.grey),
    buttonTheme: base.buttonTheme.copyWith(buttonColor: Colors.orange),
    iconTheme: base.iconTheme.copyWith(color: DarkColor.primary),
    sliderTheme: const SliderThemeData().copyWith(
      valueIndicatorColor: DarkColor.secondary,
      showValueIndicator: ShowValueIndicator.onlyForContinuous,
    ),
    visualDensity: VisualDensity.adaptivePlatformDensity,
    appBarTheme: base.appBarTheme.copyWith(
      backgroundColor: DarkColor.black,
      foregroundColor: Colors.white,
      shadowColor: const Color(0xff222222),
      centerTitle: true,
      elevation: 1.0,
      toolbarHeight: 38,
      systemOverlayStyle: SystemUiOverlayStyle(
        systemNavigationBarColor: Colors.transparent,
        statusBarColor: Colors.transparent,
        systemNavigationBarIconBrightness: Brightness.dark,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      isDense: true,
      hintStyle: const TextStyle(fontSize: 12, color: DarkColor.grey),
      labelStyle: const TextStyle(fontSize: 14, color: DarkColor.primary),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      floatingLabelStyle: const TextStyle(
        fontSize: 14,
        color: DarkColor.primary,
      ),
      alignLabelWithHint: true,
      floatingLabelBehavior: FloatingLabelBehavior.always,
      fillColor: DarkColor.grey.withValues(alpha: 0.1),
      filled: true,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
    ),
    pageTransitionsTheme: const PageTransitionsTheme(
      builders: {
        TargetPlatform.android: CupertinoPageTransitionsBuilder(),
        TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
      },
    ),
    snackBarTheme: base.snackBarTheme.copyWith(
      actionTextColor: DarkColor.secondary,
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(foregroundColor: DarkColor.grey),
    ),
  );
}

class Themes {
  final ThemeData themeData;
  Themes({required this.themeData});
  factory Themes.lightTheme() => Themes(themeData: buildLightTheme());

  factory Themes.darkTheme() => Themes(themeData: _darkTheme);
}
