import 'package:project_management/core/utility/project_management_exports.dart';

/// Field labels for RAG `/projects/query` rows (normalized keys such as `projects_name`).
///
/// Canonical backend companion repo: **`rag_first`**
/// (`test_planner.py` `table_columns`, `src/schema/project_schema.py`,
/// `src/loaders/query_builder.py` aliases, aggregation `*_value` in
/// `src/planning/sql_builder.py`, and report response samples).
/// Add `ai_query_field_<normalized_key>` to `assets/langs/en.json` and `ar.json` for new MCP columns.

/// SQL-style id columns — used for navigation only, not shown on result cards.
bool isAiAssistantQueryIdFieldKey(String rawKey) {
  final k = rawKey.trim().toLowerCase();
  if (k == 'id') return true;
  return k.endsWith('_id');
}

/// Localizes a dynamic API column name (`projects_name`, etc.).
///
/// Looks up [`ai_query_field_$rawKey`] in locale JSON; if missing, humanizes segments.
String localizedAiAssistantQueryFieldLabel(String rawKey) {
  final trimmed = rawKey.trim();
  if (trimmed.isEmpty) return '';

  final lookupKey = 'ai_query_field_$trimmed';
  final translated = allTranslations.text(lookupKey);
  if (_translationLooksPresent(translated, lookupKey)) {
    return translated;
  }

  return _humanizeFieldKey(trimmed);
}

bool _translationLooksPresent(String value, String requestedKey) {
  return value != '** $requestedKey not found';
}

String _humanizeFieldKey(String rawKey) {
  final segments = rawKey.split('_').where((s) => s.isNotEmpty).toList();
  if (segments.isEmpty) return rawKey;

  final words = segments.map((segment) {
    if (segment.isEmpty) return segment;
    final lower = segment.toLowerCase();
    return '${lower[0].toUpperCase()}${lower.length > 1 ? lower.substring(1) : ''}';
  });

  return words.join(' ');
}
