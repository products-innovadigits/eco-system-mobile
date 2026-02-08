import 'package:core_system/core/network/error/network_exception.dart';
import 'package:project_management/core/utility/project_management_exports.dart';
import 'package:project_management/features/projects/bloc/filtration/projects_filter_provider.dart';

class ProjectsBloc extends Bloc<ProjectsEvent, ProjectsState> {
  final ProjectsRepo repo;
  final ProjectsFilterProvider? filterProvider;
  final ProjectsSortingBloc? _sortingBloc;

  ProjectsBloc({
    required this.repo,
    ProjectsSortingBloc? sortingBloc,
    this.filterProvider,
  }) : _sortingBloc = sortingBloc,
       super(const ProjectsInitial()) {
    on<LoadProjects>(_getProjects);
    on<RefreshProjects>(_onRefresh);
    on<SearchChanged>(_onSearchChanged);
    on<LoadMoreProjects>(_onLoadMore);

    // Listen to sorting changes
    if (_sortingBloc != null) {
      _sortingSubscription = _sortingBloc.stream.listen((sortingState) {
        if (sortingState is SortingApplied || sortingState is SortingReset) {
          // Reset pagination when sorting changes
          _engine = SearchEngine(
            query: filterProvider?.getFilterParams() ?? {},
            currentPage: 0,
            maxPages: 1,
            totalCount: 0,
          );
          _projects.clear();
          add(LoadProjects(searchEngine: _engine));
        }
      });
    }
  }

  SearchEngine _engine = SearchEngine();
  final List<ProjectDetailsModel> _projects = [];
  String _searchKeyword = '';
  bool _isLoadingMore = false;

  StreamSubscription? _sortingSubscription;

  Future<void> _onSearchChanged(
    SearchChanged event,
    Emitter<ProjectsState> emit,
  ) async {
    _searchKeyword = event.text.trim();
    // Reset pagination when search changes
    _engine = SearchEngine(
      query: filterProvider?.getFilterParams() ?? {},
      currentPage: 0,
      maxPages: 1,
      totalCount: 0,
    );
    _projects.clear();
    add(LoadProjects(searchEngine: _engine));
  }

  Future<void> _onLoadMore(
    LoadMoreProjects event,
    Emitter<ProjectsState> emit,
  ) async {
    // Ignore if already loading or no more pages
    if (_isLoadingMore || !_engine.hasMorePages) {
      return;
    }

    // Increment page and load
    _engine.updateCurrentPage(_engine.currentPage + 1);
    add(LoadProjects(searchEngine: _engine));
  }

  Future<void> _getProjects(
    LoadProjects event,
    Emitter<ProjectsState> emit,
  ) async {
    try {
      // Update engine from event
      _engine = event.searchEngine;

      // Handle pagination states
      if (_engine.currentPage == 0) {
        _projects.clear();
        _isLoadingMore = false;
        emit(const ProjectsLoading());
      } else {
        _isLoadingMore = true;
        emit(
          ProjectsLoaded(
            projects: _projects,
            isLoadingMore: true,
            currentPage: _engine.currentPage,
            totalPages: _engine.maxPages,
            hasMore: _engine.hasMorePages,
          ),
        );
      }

      // Get sorting and filter parameters
      final sortingParams = _sortingBloc?.getSortingParams() ?? {};
      final filterParams = filterProvider?.getFilterParams() ?? {};

      // Use nextPageIndex which converts 0-based to 1-based for API
      int pageIndexToRequest = _engine.nextPageIndex;

      // Build query
      final query = <String, dynamic>{
        ...?(_engine.query as Map<String, dynamic>?)?.entries
            .where((e) => e.value != null)
            .fold<Map<String, dynamic>>(
              {},
              (acc, e) => {...acc, e.key: e.value},
            ),
        ...sortingParams,
        ...filterParams,
        "pageIndex": pageIndexToRequest,
        "pageSize": _engine.limit,
      };

      // Only add searchKeyword if not empty
      if (_searchKeyword.isNotEmpty) {
        query["searchKeyword"] = _searchKeyword;
      }

      _engine.query = query;

      ProjectsModel res = await repo.getProjects(_engine);

      _isLoadingMore = false;

      if (res.data?.items != null && res.data!.items!.isNotEmpty) {
        _projects.addAll(res.data!.items!);

        // Sync pagination info from API response
        if (res.data!.currentPage != null &&
            res.data!.totalPages != null &&
            res.data!.totalCount != null) {
          _engine.syncPaginationFromApi(
            apiCurrentPage: res.data!.currentPage!,
            totalPages: res.data!.totalPages!,
            totalCount: res.data!.totalCount!,
            pageSize: res.data!.pageSize,
            isLastPage: res.data!.isLastPage,
          );
        } else {
          _engine.updateCurrentPage(pageIndexToRequest - 1);
        }

        emit(
          ProjectsLoaded(
            projects: _projects,
            isLoadingMore: false,
            currentPage: _engine.currentPage,
            totalPages: _engine.maxPages,
            hasMore: _engine.hasMorePages,
          ),
        );
      } else {
        if (_projects.isEmpty) {
          emit(const ProjectsEmpty());
        } else {
          emit(
            ProjectsLoaded(
              projects: _projects,
              isLoadingMore: false,
              currentPage: _engine.currentPage,
              totalPages: _engine.maxPages,
              hasMore: _engine.hasMorePages,
            ),
          );
        }
      }
    } on NetworkException catch (e) {
      _isLoadingMore = false;
      emit(ProjectsFailure(message: e.message));
    } catch (e) {
      _isLoadingMore = false;
      emit(ProjectsFailure(message: e.toString()));
    }
  }

  Future<void> _onRefresh(
    RefreshProjects event,
    Emitter<ProjectsState> emit,
  ) async {
    final filterParams = filterProvider?.getFilterParams() ?? {};
    final sortingParams = _sortingBloc?.getSortingParams() ?? {};
    // Reset everything
    _searchKeyword = '';
    _engine = SearchEngine(
      query: {...filterParams, ...sortingParams},
      currentPage: 0,
      maxPages: 1,
      totalCount: 0,
    );
    _projects.clear();

    add(LoadProjects(searchEngine: _engine));
  }

  @override
  Future<void> close() {
    _sortingSubscription?.cancel();
    return super.close();
  }
}
