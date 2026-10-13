import 'package:flutter/material.dart';
import 'package:project_management/features/workflow_process_details/model/current_step_document_model.dart';

/// Layout constants and field accessors for HTML document rendering.
abstract final class HtmlContentHelper {
  // -------------------------
  // Layout & spacing
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

  // -------------------------
  // Dialog
  // -------------------------

  /// Dialog border radius
  static const double dialogBorderRadius = 16.0;

  /// Dialog padding
  static const double dialogPadding = 16.0;

  /// Dialog inset padding
  static const EdgeInsets dialogInsetPadding = EdgeInsets.all(16);

  // -------------------------
  // Field accessors
  // -------------------------

  /// The field's current value, or '' when it has none.
  /// Accepts a [FieldDefinition] or its raw JSON map.
  static String readFieldValue(Object? field) =>
      _readMeta(field, 'value', (meta) => meta.value);

  /// The field's placeholder text, or '' when it has none.
  /// Accepts a [FieldDefinition] or its raw JSON map.
  static String readFieldPlaceholder(Object? field) =>
      _readMeta(field, 'placeholder', (meta) => meta.placeholder);

  static String _readMeta(
    Object? field,
    String key,
    String? Function(FieldMeta meta) fromModel,
  ) {
    final value = switch (field) {
      FieldDefinition(:final meta?) => fromModel(meta),
      {'meta': final Map meta} => meta[key],
      _ => null,
    };
    return value?.toString() ?? '';
  }

  // -------------------------
  // Text
  // -------------------------

  /// Replaces non-breaking spaces with regular spaces.
  static String cleanText(String s) => s.replaceAll(' ', ' ');
}
