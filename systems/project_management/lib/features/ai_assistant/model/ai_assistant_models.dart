/// AI assistant natural-language query: one row from the API `data` array.
///
/// [fields] holds every non-null value from the server object as strings so the UI can show
/// arbitrary columns. [displayKeyOrder] follows [meta.columns] when present, then any extra keys.
/// Id-style keys (`id`, `*_id`) are omitted on the result card; values are still parsed for [projectId].
class AiAssistantQueryItem {
  AiAssistantQueryItem({
    required this.projectId,
    required this.fields,
    required this.displayKeyOrder,
  });

  /// From `projects_id` or `id`, for navigation to project details.
  final int? projectId;

  /// API keys → display values (stringified).
  final Map<String, String> fields;

  /// Keys in UI order.
  final List<String> displayKeyOrder;
}

/// A clickable clarification/empty suggestion chip from the API.
///
/// [question] is the exact natural-language query re-sent to `/projects/query`
/// when the user taps the card; [label] is the short Arabic text shown.
class AiAssistantSuggestion {
  AiAssistantSuggestion({
    required this.id,
    required this.label,
    required this.question,
  });

  final String id;
  final String label;
  final String question;
}

/// Parsed `/projects/query` payload.
///
/// Besides the [items] rows, it carries the response's `meta.result_type`
/// (`results` | `empty` | `clarification`) plus the clarification [message] and
/// [suggestions] so the UI can render an interactive clarification instead of a
/// bare failure. Empty and clarification are distinct states — never mixed.
class AiAssistantQueryProjectsResult {
  AiAssistantQueryProjectsResult({
    required this.items,
    this.resultType,
    this.message,
    this.suggestions = const [],
  });

  final List<AiAssistantQueryItem> items;

  /// `results` | `empty` | `clarification` | `error` (null on legacy shapes).
  final String? resultType;

  /// User-facing message (for clarification: the question asking to clarify).
  final String? message;

  /// Clickable suggestion chips (clarification, and gentle chips on empty).
  final List<AiAssistantSuggestion> suggestions;

  bool get isClarification => resultType == 'clarification';
}
