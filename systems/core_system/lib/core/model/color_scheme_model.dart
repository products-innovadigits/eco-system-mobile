// core/config/themes/color_scheme_model.dart
import 'package:core_system/core/utility/export.dart'; // for SingleMapper / Mapper

Color _hex(String hex) {
  final v = hex.replaceAll('#', '');
  final argb = (v.length == 6 ? 'FF$v' : v);
  return Color(int.parse(argb, radix: 16));
}

/// Convert a Color to "#AARRGGBB" (or null if c is null).
String? _toHex(Color? c) {
  if (c == null) return null;
  final value = c.toARGB32().toRadixString(16).padLeft(8, '0').toUpperCase();
  return '#$value'; // includes alpha
}

/// Simple data class compatible with SingleMapper.
/// All fields optional: if null, we keep existing color.
class ColorSchemeModel extends SingleMapper {
  final Color? primary;
  final Color? onPrimary;
  final Color? secondary;
  final Color? onSecondary;
  final Color? tertiary;
  final Color? tertiaryContainer;
  final Color? surface;
  final Color? surfaceContainer;
  final Color? onSurface;
  final Color? outline;
  final Color? outlineVariant;
  final Color? error;
  final Color? errorContainer;

  ColorSchemeModel({
    this.primary,
    this.onPrimary,
    this.secondary,
    this.onSecondary,
    this.tertiary,
    this.tertiaryContainer,
    this.surface,
    this.surfaceContainer,
    this.onSurface,
    this.outline,
    this.outlineVariant,
    this.error,
    this.errorContainer,
  });

  /// Named constructor (like your UserModel) to build from JSON.
  ColorSchemeModel.fromJson(Map<String, dynamic> json)
    : primary = json['primary'] == null
          ? null
          : _hex(json['primary'] as String),
      onPrimary = json['onPrimary'] == null
          ? null
          : _hex(json['onPrimary'] as String),
      secondary = json['secondary'] == null
          ? null
          : _hex(json['secondary'] as String),
      onSecondary = json['onSecondary'] == null
          ? null
          : _hex(json['onSecondary'] as String),
      tertiary = json['tertiary'] == null
          ? null
          : _hex(json['tertiary'] as String),
      tertiaryContainer = json['tertiaryContainer'] == null
          ? null
          : _hex(json['tertiaryContainer'] as String),
      surface = json['surface'] == null
          ? null
          : _hex(json['surface'] as String),
      surfaceContainer = json['surfaceContainer'] == null
          ? null
          : _hex(json['surfaceContainer'] as String),
      onSurface = json['onSurface'] == null
          ? null
          : _hex(json['onSurface'] as String),
      outline = json['outline'] == null
          ? null
          : _hex(json['outline'] as String),
      outlineVariant = json['outlineVariant'] == null
          ? null
          : _hex(json['outlineVariant'] as String),
      error = json['error'] == null ? null : _hex(json['error'] as String),
      errorContainer = json['errorContainer'] == null
          ? null
          : _hex(json['errorContainer'] as String);

  /// Emit only non-null fields to keep payloads minimal.
  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};

    void put(String k, Color? c) {
      final v = _toHex(c);
      if (v != null) data[k] = v;
    }

    put('primary', primary);
    put('onPrimary', onPrimary);
    put('secondary', secondary);
    put('onSecondary', onSecondary);
    put('tertiary', tertiary);
    put('tertiaryContainer', tertiaryContainer);
    put('surface', surface);
    put('surfaceContainer', surfaceContainer);
    put('onSurface', onSurface);
    put('outline', outline);
    put('outlineVariant', outlineVariant);
    put('error', error);
    put('errorContainer', errorContainer);

    return data;
  }

  /// Required by SingleMapper: build an instance from JSON.
  @override
  Mapper fromJson(Map<String, dynamic> json) {
    return ColorSchemeModel.fromJson(json);
  }

  bool get isEmpty =>
      primary == null &&
      onPrimary == null &&
      secondary == null &&
      onSecondary == null &&
      tertiary == null &&
      tertiaryContainer == null &&
      surface == null &&
      surfaceContainer == null &&
      onSurface == null &&
      outline == null &&
      outlineVariant == null &&
      error == null &&
      errorContainer == null;
}
