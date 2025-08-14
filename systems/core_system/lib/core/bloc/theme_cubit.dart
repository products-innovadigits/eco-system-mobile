import 'package:core_system/core/utility/export.dart';

ThemeData buildLightThemeFromModel({ColorSchemeModel? m}) {
  // 1) start from your current theme (keeps typography, components, etc.)
  final base = Themes.lightTheme().themeData;
  final cs0 = base.colorScheme;

  // 2) if model is null or empty, just return base
  if (m == null || m.isEmpty) return base;

  // 3) fallbacks are your current LightColor mapping (your list)
  final primary = m.primary ?? LightColor.primary;
  final onPrimary = m.onPrimary ?? LightColor.white;
  final secondary = m.secondary ?? LightColor.secondary;
  final tertiary = m.tertiary ?? LightColor.tertiary;
  final tertiaryContainer = m.tertiaryContainer ?? LightColor.tertiaryLight;
  final surface = m.surface ?? LightColor.scaffoldBg;
  final surfaceContainer = m.surfaceContainer ?? LightColor.cardBg;
  final onSurface = m.onSurface ?? LightColor.primary;
  final outline = m.outline ?? LightColor.border;
  final outlineVariant = m.outlineVariant ?? LightColor.placeHolderText;
  final error = m.error ?? LightColor.error;
  final errorContainer = m.errorContainer ?? LightColor.warning;

  // 4) override ColorScheme selectively
  final cs = cs0.copyWith(
    primary: primary,
    onPrimary: onPrimary,
    secondary: secondary,
    tertiary: tertiary,
    tertiaryContainer: tertiaryContainer,
    surfaceContainer: surfaceContainer,
    surface: surface,
    onSurface: onSurface,
    outline: outline,
    outlineVariant: outlineVariant,
    error: error,
    errorContainer: errorContainer,
  );

  // 5) provide container‑like colors via scaffold/card/etc. (common pattern)
  return base.copyWith(
    colorScheme: cs,
    scaffoldBackgroundColor: surface,
    cardColor: surfaceContainer,
  );
}

class ThemeCubit extends Cubit<ThemeState> {
  ThemeCubit() : super(ThemeState(themeData: buildLightThemeFromModel()));

  static ThemeCubit get instance =>
      BlocProvider.of(CustomNavigator.navigatorState.currentContext!);

  void applyModel(ColorSchemeModel? model) {
    final theme = buildLightThemeFromModel(m: model);
    emit(ThemeState(themeData: theme, model: model));
  }

  /// Optional: call at boot to ensure base theme is applied
  void init() {
    emit(ThemeState(themeData: buildLightThemeFromModel(), model: null));
  }
}

class ThemeState {
  final ThemeData themeData;
  final ColorSchemeModel? model;

  const ThemeState({required this.themeData, this.model});
}
