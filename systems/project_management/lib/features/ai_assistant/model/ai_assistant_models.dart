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

/// Pagination slice from `meta.pagination` on `/projects/query` responses.
class AiAssistantQueryPagination {
  AiAssistantQueryPagination({
    required this.page,
    required this.pageSize,
    required this.hasMore,
    this.nextPage,
  });

  final int page;
  final int pageSize;
  final bool hasMore;
  final int? nextPage;

  factory AiAssistantQueryPagination.initial({int pageSize = 10}) {
    return AiAssistantQueryPagination(
      page: 1,
      pageSize: pageSize,
      hasMore: false,
      nextPage: null,
    );
  }
}

/// Parsed `/projects/query` payload: rows plus pagination meta.
class AiAssistantQueryProjectsResult {
  AiAssistantQueryProjectsResult({
    required this.items,
    required this.pagination,
  });

  final List<AiAssistantQueryItem> items;
  final AiAssistantQueryPagination pagination;

  factory AiAssistantQueryProjectsResult.empty() {
    return AiAssistantQueryProjectsResult(
      items: [],
      pagination: AiAssistantQueryPagination.initial(),
    );
  }
}
