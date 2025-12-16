import 'package:flutter/material.dart';

/// Helper class containing constants and utility functions for HTML content rendering.
class HtmlContentHelper {
  // -------------------------
  // Constants - Layout & Spacing
  // -------------------------

  /// Spacing between inline elements in paragraphs
  static const double inlineSpacing = 6.0;

  /// Vertical spacing between paragraph runs
  static const double paragraphRunSpacing = 8.0;

  /// Vertical spacing after paragraphs
  static const double paragraphBottomSpacing = 8.0;

  /// Vertical spacing after tables
  static const double tableBottomSpacing = 12.0;

  /// Spacing for line breaks
  static const double lineBreakSpacing = 8.0;

  /// Minimum width for table cells
  static const double tableCellMinWidth = 140.0;

  /// Minimum width for input fields
  static const double inputFieldMinWidth = 170.0;

  /// Maximum width for input fields
  static const double inputFieldMaxWidth = 280.0;

  /// Horizontal padding for input fields
  static const double inputFieldHorizontalPadding = 10.0;

  /// Vertical padding for input fields
  static const double inputFieldVerticalPadding = 10.0;

  /// Margin around fields inside table cells to avoid touching borders
  static const double tableCellFieldMargin = 8.0;

  /// Table cell padding
  static const EdgeInsets tableCellPadding =
      EdgeInsets.symmetric(vertical: 12, horizontal: 12);

  /// Date picker year range (50 years before/after current year)
  static const int datePickerYearRange = 50;

  // -------------------------
  // Constants - Dialog
  // -------------------------

  /// Dialog border radius
  static const double dialogBorderRadius = 16.0;

  /// Dialog padding
  static const double dialogPadding = 16.0;

  /// Dialog inset padding
  static const EdgeInsets dialogInsetPadding =
      EdgeInsets.symmetric(horizontal: 16, vertical: 16);

  // -------------------------
  // Field value helpers
  // -------------------------

  /// Reads the current value from a field object.
  /// Supports both FieldModel objects and Map<String, dynamic> structures.
  static String readFieldValue(dynamic field) {
    try {
      final v = field.meta?.value;
      return (v ?? '').toString();
    } catch (_) {
      if (field is Map) {
        final meta = field['meta'];
        if (meta is Map) return (meta['value'] ?? '').toString();
      }
      return '';
    }
  }

  /// Writes a new value to a field object.
  /// Supports both FieldModel objects and Map<String, dynamic> structures.
  static void writeFieldValue(dynamic field, String value) {
    try {
      if (field.meta != null) {
        field.meta.value = value;
        return;
      }
    } catch (_) {}

    if (field is Map) {
      final meta = field['meta'];
      if (meta is Map) {
        meta['value'] = value;
      } else {
        field['meta'] = {'value': value};
      }
    }
  }

  /// Reads the field type (e.g., 'text', 'number', 'email', 'url', 'date').
  static String readFieldType(dynamic field) {
    try {
      return (field.type ?? '').toString();
    } catch (_) {
      if (field is Map) return (field['type'] ?? '').toString();
      return '';
    }
  }

  /// Reads the placeholder text for a field.
  static String readFieldPlaceholder(dynamic field) {
    try {
      return (field.meta?.placeholder ?? '').toString();
    } catch (_) {
      if (field is Map) {
        final meta = field['meta'];
        if (meta is Map) return (meta['placeholder'] ?? '').toString();
      }
      return '';
    }
  }

  // -------------------------
  // Text utilities
  // -------------------------

  /// Cleans text by replacing non-breaking spaces with regular spaces.
  static String cleanText(String s) => s.replaceAll('\u00A0', ' ');
}

