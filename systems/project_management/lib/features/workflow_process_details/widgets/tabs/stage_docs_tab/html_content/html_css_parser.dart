import 'package:flutter/material.dart';
import 'package:html/dom.dart' as dom;

/// Reads the subset of inline HTML styling the document renderer supports:
/// background colors, padding and table borders. Only styling that comes
/// from the HTML response is used; nothing falls back to app colors.
abstract final class HtmlCssParser {
  static final _whitespace = RegExp(r'\s+');
  static final _nonNumeric = RegExp(r'[^\d.]');
  static final _digitsOnly = RegExp(r'^\d+$');
  static final _rgb = RegExp(r'rgb\(\s*(\d+)\s*,\s*(\d+)\s*,\s*(\d+)\s*\)');
  static final _rgba = RegExp(
    r'rgba\(\s*(\d+)\s*,\s*(\d+)\s*,\s*(\d+)\s*,\s*([0-9.]+)\s*\)',
  );

  /// Background color from the `bgcolor` attribute, then the CSS
  /// `background-color` and `background` properties.
  static Color? background(dom.Element el) {
    final bgAttr = parseColor(el.attributes['bgcolor']);
    if (bgAttr != null) return bgAttr;

    final style = el.attributes['style'] ?? '';
    return parseColor(_property(style, 'background-color')) ??
        parseColor(_property(style, 'background'));
  }

  /// Padding from the element's style.
  /// Supports 1 (all), 2 (vertical horizontal) and 4 (top right bottom left)
  /// values; anything else is treated as no padding.
  static EdgeInsets padding(dom.Element el) {
    final padding = _property(el.attributes['style'] ?? '', 'padding');
    if (padding == null || padding.isEmpty) return EdgeInsets.zero;

    final values = padding
        .split(_whitespace)
        .map((v) => v.replaceAll(_nonNumeric, ''))
        .where((v) => v.isNotEmpty)
        .map((v) => double.tryParse(v) ?? 0.0)
        .toList();

    return switch (values) {
      [final all] => EdgeInsets.all(all),
      [final vertical, final horizontal] => EdgeInsets.symmetric(
        vertical: vertical,
        horizontal: horizontal,
      ),
      [final top, final right, final bottom, final left] => EdgeInsets.only(
        top: top,
        right: right,
        bottom: bottom,
        left: left,
      ),
      _ => EdgeInsets.zero,
    };
  }

  /// Table border from the `border` style (e.g. "1px solid #ccc") or the
  /// separate `border-width`/`border-color` styles.
  ///
  /// Returns null unless both a width and a color come from the response.
  /// Only vertical lines are drawn; horizontal separators are never shown.
  static TableBorder? tableBorder(dom.Element table) {
    final style = table.attributes['style'] ?? '';
    double? width;
    Color? color;

    final border = _property(style, 'border');
    if (border != null && border.isNotEmpty) {
      for (final part in border.split(_whitespace)) {
        if (part.contains('px') ||
            part.contains('pt') ||
            _digitsOnly.hasMatch(part)) {
          width = double.tryParse(part.replaceAll(_nonNumeric, '')) ?? 0.0;
        } else if (part.startsWith('#') || part.startsWith('rgb')) {
          color = parseColor(part);
        }
      }
    } else {
      final borderWidth = _property(style, 'border-width');
      if (borderWidth != null) {
        width = double.tryParse(borderWidth.replaceAll(_nonNumeric, '')) ?? 0.0;
      }
      color = parseColor(_property(style, 'border-color'));
    }

    // Fall back to the `border="1"` attribute; it carries no color, so it
    // only draws when a color came from the style.
    final borderAttr = table.attributes['border'];
    if (width == null && borderAttr != null && borderAttr.isNotEmpty) {
      width = double.tryParse(borderAttr) ?? 1.0;
    }

    if (width == null || width <= 0 || color == null) return null;

    final side = BorderSide(color: color, width: width);
    return TableBorder(left: side, right: side, verticalInside: side);
  }

  /// Parses `#RRGGBB`, `#AARRGGBB`, `rgb()` and `rgba()` colors.
  /// For multi-token values like "#ffffff center" the first token is used.
  /// Returns null for transparent/none and for anything unparseable.
  static Color? parseColor(String? css) {
    if (css == null) return null;
    var s = css.trim().toLowerCase();
    if (s.isEmpty || s == 'transparent' || s == 'none') return null;

    // rgb()/rgba() may contain spaces; other values keep their first token.
    if (!s.startsWith('rgb(') && !s.startsWith('rgba(')) {
      s = s.split(_whitespace).first;
    }

    if (s.startsWith('#')) {
      final hex = s.substring(1);
      final argb = switch (hex.length) {
        6 => int.tryParse('ff$hex', radix: 16),
        8 => int.tryParse(hex, radix: 16),
        _ => null,
      };
      if (argb != null) return Color(argb);
    }

    final rgb = _rgb.firstMatch(s);
    if (rgb != null) {
      return Color.fromARGB(
        255,
        _channel(rgb.group(1)),
        _channel(rgb.group(2)),
        _channel(rgb.group(3)),
      );
    }

    final rgba = _rgba.firstMatch(s);
    if (rgba != null) {
      final opacity = double.tryParse(rgba.group(4)!);
      if (opacity == null) return null;
      return Color.fromARGB(
        (opacity * 255).round().clamp(0, 255),
        _channel(rgba.group(1)),
        _channel(rgba.group(2)),
        _channel(rgba.group(3)),
      );
    }

    return null;
  }

  static int _channel(String? value) =>
      (int.tryParse(value ?? '') ?? 0).clamp(0, 255);

  /// Value of [key] in an inline `style` string, or null if absent.
  static String? _property(String style, String key) {
    for (final declaration in style.split(';')) {
      final idx = declaration.indexOf(':');
      if (idx == -1) continue;
      if (declaration.substring(0, idx).trim().toLowerCase() == key) {
        return declaration.substring(idx + 1).trim();
      }
    }
    return null;
  }
}
