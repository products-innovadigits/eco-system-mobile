import 'package:core_system/core/network/error/network_exception.dart';
import 'package:pms_system/core/utility/pms_exports.dart';
import 'package:pms_system/features/employee_of_month_history/bloc/employee_of_month_history_events.dart';
import 'package:pms_system/features/employee_of_month_history/bloc/employee_of_month_history_states.dart';
import 'package:pms_system/features/employee_of_month_history/bloc/filtration/employee_of_month_history_filter_provider.dart';
import 'package:pms_system/features/employee_of_month_history/domain/employee_of_month_history_repo.dart';
import 'package:pms_system/features/employee_of_month_history/model/employee_of_month_history_model.dart';

class EmployeeOfMonthHistoryBloc
    extends Bloc<EmployeeOfMonthHistoryEvent, EmployeeOfMonthHistoryState> {
  final EmployeeOfMonthHistoryRepo repo;
  final EmployeeOfMonthHistoryFilterProvider? filterProvider;

  EmployeeOfMonthHistoryBloc({
    required this.repo,
    this.filterProvider,
  }) : super(const EmployeeOfMonthHistoryInitial()) {
    on<LoadEmployeeOfMonthHistory>(_loadHistory);
    on<RefreshEmployeeOfMonthHistory>(_onRefresh);
    on<EmployeeOfMonthHistorySearchChanged>(_onSearchChanged);
    on<LoadMoreEmployeeOfMonthHistory>(_onLoadMore);
  }

  SearchEngine _engine = SearchEngine();
  final List<EmployeeOfMonthHistoryItemModel> _items = [];
  String _searchKeyword = '';
  bool _isLoadingMore = false;

  Future<void> _onSearchChanged(
    EmployeeOfMonthHistorySearchChanged event,
    Emitter<EmployeeOfMonthHistoryState> emit,
  ) async {
    _searchKeyword = event.text.trim();
    _engine = SearchEngine(
      query: filterProvider?.getFilterParams() ?? {},
      currentPage: 0,
      maxPages: 1,
      totalCount: 0,
    );
    _items.clear();
    add(LoadEmployeeOfMonthHistory(searchEngine: _engine));
  }

  Future<void> _onLoadMore(
    LoadMoreEmployeeOfMonthHistory event,
    Emitter<EmployeeOfMonthHistoryState> emit,
  ) async {
    if (_isLoadingMore || !_engine.hasMorePages) return;
    _isLoadingMore = true;
    _engine.updateCurrentPage(_engine.currentPage + 1);
    add(LoadEmployeeOfMonthHistory(searchEngine: _engine));
  }

  Future<void> _loadHistory(
    LoadEmployeeOfMonthHistory event,
    Emitter<EmployeeOfMonthHistoryState> emit,
  ) async {
    try {
      _engine = event.searchEngine;

      if (_engine.currentPage == 0) {
        _items.clear();
        _isLoadingMore = false;
        emit(const EmployeeOfMonthHistoryLoading());
      } else {
        _isLoadingMore = true;
        emit(
          EmployeeOfMonthHistoryLoaded(
            items: List<EmployeeOfMonthHistoryItemModel>.from(_items),
            isLoadingMore: true,
            currentPage: _engine.currentPage,
            totalPages: _engine.maxPages,
            totalCount: _engine.totalCount,
            hasMore: _engine.hasMorePages,
          ),
        );
      }

      final filterParams = filterProvider?.getFilterParams() ?? {};
      final int pageIndexToRequest = _engine.nextPageIndex;

      final query = <String, dynamic>{
        ...?(_engine.query as Map<String, dynamic>?)?.entries
            .where((e) => e.value != null)
            .fold<Map<String, dynamic>>({}, (acc, e) => {...acc, e.key: e.value}),
        ...filterParams,
        'pageIndex': pageIndexToRequest,
        'pageSize': _engine.limit,
      };

      if (_searchKeyword.isNotEmpty) {
        query['keyword'] = _searchKeyword;
      }

      _engine.query = query;

      final EmployeeOfMonthHistoryModel res = await repo.getHistory(_engine);

      _isLoadingMore = false;

      if (res.data?.items != null && res.data!.items!.isNotEmpty) {
        _items.addAll(res.data!.items!);

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
          EmployeeOfMonthHistoryLoaded(
            items: List<EmployeeOfMonthHistoryItemModel>.from(_items),
            isLoadingMore: false,
            currentPage: _engine.currentPage,
            totalPages: _engine.maxPages,
            totalCount: _engine.totalCount,
            hasMore: _engine.hasMorePages,
          ),
        );
      } else {
        if (_items.isEmpty) {
          emit(const EmployeeOfMonthHistoryEmpty());
        } else {
          emit(
            EmployeeOfMonthHistoryLoaded(
              items: List<EmployeeOfMonthHistoryItemModel>.from(_items),
              isLoadingMore: false,
              currentPage: _engine.currentPage,
              totalPages: _engine.maxPages,
              totalCount: _engine.totalCount,
              hasMore: _engine.hasMorePages,
            ),
          );
        }
      }
    } on NetworkException catch (e) {
      _isLoadingMore = false;
      if (_items.isNotEmpty) {
        emit(
          EmployeeOfMonthHistoryLoaded(
            items: List<EmployeeOfMonthHistoryItemModel>.from(_items),
            isLoadingMore: false,
            currentPage: _engine.currentPage,
            totalPages: _engine.maxPages,
            totalCount: _engine.totalCount,
            hasMore: _engine.hasMorePages,
          ),
        );
      } else {
        emit(EmployeeOfMonthHistoryFailure(message: e.message));
      }
    } catch (e) {
      _isLoadingMore = false;
      if (_items.isNotEmpty) {
        emit(
          EmployeeOfMonthHistoryLoaded(
            items: List<EmployeeOfMonthHistoryItemModel>.from(_items),
            isLoadingMore: false,
            currentPage: _engine.currentPage,
            totalPages: _engine.maxPages,
            totalCount: _engine.totalCount,
            hasMore: _engine.hasMorePages,
          ),
        );
      } else {
        emit(EmployeeOfMonthHistoryFailure(message: e.toString()));
      }
    }
  }

  Future<void> _onRefresh(
    RefreshEmployeeOfMonthHistory event,
    Emitter<EmployeeOfMonthHistoryState> emit,
  ) async {
    final filterParams = filterProvider?.getFilterParams() ?? {};
    _searchKeyword = '';
    _engine = SearchEngine(
      query: {...filterParams},
      currentPage: 0,
      maxPages: 1,
      totalCount: 0,
    );
    _items.clear();
    add(LoadEmployeeOfMonthHistory(searchEngine: _engine));
  }
}
