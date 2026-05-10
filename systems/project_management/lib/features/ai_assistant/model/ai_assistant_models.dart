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

/// Parsed `/projects/query` payload: list of dynamic rows.
class AiAssistantQueryProjectsResult {
  AiAssistantQueryProjectsResult({required this.items});

  final List<AiAssistantQueryItem> items;
}
