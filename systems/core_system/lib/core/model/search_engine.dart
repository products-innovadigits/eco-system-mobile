class SearchEngine {
  dynamic query;
  String? id;
  String? searchText;
  int limit;
  int totalCount;
  int currentPage;
  int maxPages;

  bool isLoading = true;

  SearchEngine({
    this.id,
    this.searchText,
    this.query,
    this.totalCount = 0,
    this.limit = 10,
    this.maxPages = 1,
    this.isLoading = true,
    this.currentPage = 0,
  });

  int updateCurrentPage(int page) => currentPage = page;

  /// Sync pagination data from API response
  /// API uses 1-based page indexing, SearchEngine uses 0-based
  void syncPaginationFromApi({
    required int apiCurrentPage, // 1-based from API
    required int totalPages,
    required int totalCount,
    int? pageSize,
    bool? isLastPage,
  }) {
    // Convert API's 1-based page to 0-based for SearchEngine
    currentPage = apiCurrentPage - 1;
    maxPages = totalPages;
    this.totalCount = totalCount;
    if (pageSize != null) {
      limit = pageSize;
    }
  }

  /// Check if there are more pages to load
  bool get hasMorePages => currentPage < maxPages - 1;

  /// Get the next page index (0-based) for API request
  int get nextPageIndex => currentPage + 1;

  Map toJson() {
    Map data = {};
    data["query"] = query;
    data["id"] = id;
    data["searchText"] = searchText;
    data["current_page"] = currentPage;
    return data;
  }
}
