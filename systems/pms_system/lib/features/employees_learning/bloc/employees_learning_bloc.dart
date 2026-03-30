import 'package:core_system/core/network/error/network_exception.dart';
import 'package:pms_system/core/utility/pms_exports.dart';
import 'package:pms_system/features/employees_learning/bloc/employees_learning_events.dart';
import 'package:pms_system/features/employees_learning/bloc/employees_learning_states.dart';
import 'package:pms_system/features/employees_learning/bloc/filtration/employees_filter_provider.dart';
import 'package:pms_system/features/employees_learning/domain/employees_learning_repo.dart';
import 'package:pms_system/features/employees_learning/model/employees_learning_model.dart';

class EmployeesLearningBloc
    extends Bloc<EmployeesLearningEvent, EmployeesLearningState> {
  final EmployeesLearningRepo repo;
  final EmployeesFilterProvider? filterProvider;

  EmployeesLearningBloc({
    required this.repo,
    this.filterProvider,
  }) : super(const EmployeesInitial()) {
    on<LoadEmployees>(_getEmployees);
    on<RefreshEmployees>(_onRefresh);
    on<EmployeesSearchChanged>(_onSearchChanged);
    on<LoadMoreEmployees>(_onLoadMore);
  }

  SearchEngine _engine = SearchEngine();
  final List<EmployeeItemModel> _employees = [];
  String _searchKeyword = '';
  bool _isLoadingMore = false;

  Future<void> _onSearchChanged(
    EmployeesSearchChanged event,
    Emitter<EmployeesLearningState> emit,
  ) async {
    _searchKeyword = event.text.trim();
    _engine = SearchEngine(
      query: filterProvider?.getFilterParams() ?? {},
      currentPage: 0,
      maxPages: 1,
      totalCount: 0,
    );
    _employees.clear();
    add(LoadEmployees(searchEngine: _engine));
  }

  Future<void> _onLoadMore(
    LoadMoreEmployees event,
    Emitter<EmployeesLearningState> emit,
  ) async {
    if (_isLoadingMore || !_engine.hasMorePages) return;
    _isLoadingMore = true;
    _engine.updateCurrentPage(_engine.currentPage + 1);
    add(LoadEmployees(searchEngine: _engine));
  }

  Future<void> _getEmployees(
    LoadEmployees event,
    Emitter<EmployeesLearningState> emit,
  ) async {
    try {
      _engine = event.searchEngine;

      if (_engine.currentPage == 0) {
        _employees.clear();
        _isLoadingMore = false;
        emit(const EmployeesLoading());
      } else {
        _isLoadingMore = true;
        emit(
          EmployeesLoaded(
            employees: _employees,
            isLoadingMore: true,
            currentPage: _engine.currentPage,
            totalPages: _engine.maxPages,
            hasMore: _engine.hasMorePages,
          ),
        );
      }

      final filterParams = filterProvider?.getFilterParams() ?? {};
      int pageIndexToRequest = _engine.nextPageIndex;

      final query = <String, dynamic>{
        ...?(_engine.query as Map<String, dynamic>?)?.entries
            .where((e) => e.value != null)
            .fold<Map<String, dynamic>>({}, (acc, e) => {...acc, e.key: e.value}),
        ...filterParams,
        "pageIndex": pageIndexToRequest,
        "pageSize": _engine.limit,
      };

      if (_searchKeyword.isNotEmpty) {
        query["keyword"] = _searchKeyword;
      }

      _engine.query = query;

      EmployeesLearningModel res = await repo.getEmployees(_engine);

      _isLoadingMore = false;

      if (res.data?.items != null && res.data!.items!.isNotEmpty) {
        _employees.addAll(res.data!.items!);

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
          EmployeesLoaded(
            employees: _employees,
            isLoadingMore: false,
            currentPage: _engine.currentPage,
            totalPages: _engine.maxPages,
            hasMore: _engine.hasMorePages,
          ),
        );
      } else {
        if (_employees.isEmpty) {
          emit(const EmployeesEmpty());
        } else {
          emit(
            EmployeesLoaded(
              employees: _employees,
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
      if (_employees.isNotEmpty) {
        emit(
          EmployeesLoaded(
            employees: _employees,
            isLoadingMore: false,
            currentPage: _engine.currentPage,
            totalPages: _engine.maxPages,
            hasMore: _engine.hasMorePages,
          ),
        );
      } else {
        emit(EmployeesFailure(message: e.message));
      }
    } catch (e) {
      _isLoadingMore = false;
      if (_employees.isNotEmpty) {
        emit(
          EmployeesLoaded(
            employees: _employees,
            isLoadingMore: false,
            currentPage: _engine.currentPage,
            totalPages: _engine.maxPages,
            hasMore: _engine.hasMorePages,
          ),
        );
      } else {
        emit(EmployeesFailure(message: e.toString()));
      }
    }
  }

  Future<void> _onRefresh(
    RefreshEmployees event,
    Emitter<EmployeesLearningState> emit,
  ) async {
    final filterParams = filterProvider?.getFilterParams() ?? {};
    _searchKeyword = '';
    _engine = SearchEngine(
      query: {...filterParams},
      currentPage: 0,
      maxPages: 1,
      totalCount: 0,
    );
    _employees.clear();
    add(LoadEmployees(searchEngine: _engine));
  }
}
