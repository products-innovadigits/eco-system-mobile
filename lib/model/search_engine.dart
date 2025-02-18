class SearchEngine {
  dynamic query;
  String? id;
  int limit;
  int totalCount;
  int currentPage;
  int maxPages;

  bool isLoading = true;
  SearchEngine({
    this.id,
    this.query,
    this.totalCount = 0,
    this.limit = 10,
    this.maxPages = 1,
    this.isLoading = true,
    this.currentPage = 0,
  });

  updateCurrentPage(int page) => currentPage = page;

  toJson() {
    Map data = {};
    data["query"] = query;
    data["id"] = id;
    data["current_page"] = currentPage;
    return data;
  }
}
