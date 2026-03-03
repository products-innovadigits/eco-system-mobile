import 'package:core_system/core/network/error/network_exception.dart';
import 'package:pms_system/core/utility/pms_exports.dart';
import 'package:pms_system/features/cycles/bloc/cycles_events.dart';
import 'package:pms_system/features/cycles/bloc/cycles_states.dart';
import 'package:pms_system/features/cycles/domain/cycles_repo.dart';
import 'package:pms_system/features/cycles/model/cycles_model.dart';

class CyclesBloc extends Bloc<CyclesEvent, CyclesState> {
  final CyclesRepo repo;

  CyclesBloc({required this.repo}) : super(const CyclesInitial()) {
    on<LoadCycles>(_getCycles);
    on<RefreshCycles>(_onRefresh);
    on<SearchChanged>(_onSearchChanged);
    on<LoadMoreCycles>(_onLoadMore);
  }

  SearchEngine _engine = SearchEngine();
  final List<CycleItemModel> _cycles = [];
  String _searchKeyword = '';
  bool _isLoadingMore = false;

  Future<void> _onSearchChanged(
    SearchChanged event,
    Emitter<CyclesState> emit,
  ) async {
    _searchKeyword = event.text.trim();
    _engine = SearchEngine(
      query: <String, dynamic>{},
      currentPage: 0,
      maxPages: 1,
      totalCount: 0,
    );
    _cycles.clear();
    add(LoadCycles(searchEngine: _engine));
  }

  Future<void> _onLoadMore(
    LoadMoreCycles event,
    Emitter<CyclesState> emit,
  ) async {
    if (_isLoadingMore || !_engine.hasMorePages) return;
    _engine.updateCurrentPage(_engine.currentPage + 1);
    add(LoadCycles(searchEngine: _engine));
  }

  Future<void> _getCycles(
    LoadCycles event,
    Emitter<CyclesState> emit,
  ) async {
    try {
      _engine = event.searchEngine;

      if (_engine.currentPage == 0) {
        _cycles.clear();
        _isLoadingMore = false;
        emit(const CyclesLoading());
      } else {
        _isLoadingMore = true;
        emit(
          CyclesLoaded(
            cycles: _cycles,
            isLoadingMore: true,
            currentPage: _engine.currentPage,
            totalPages: _engine.maxPages,
            hasMore: _engine.hasMorePages,
          ),
        );
      }

      int pageIndexToRequest = _engine.nextPageIndex;

      final query = <String, dynamic>{
        "pageIndex": pageIndexToRequest,
        "pageSize": _engine.limit,
      };

      if (_searchKeyword.isNotEmpty) {
        query["searchKeyword"] = _searchKeyword;
      }

      _engine.query = query;

      CyclesModel res = await repo.getCycles(_engine);

      _isLoadingMore = false;

      if (res.data?.items != null && res.data!.items!.isNotEmpty) {
        _cycles.addAll(res.data!.items!);

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
          CyclesLoaded(
            cycles: _cycles,
            isLoadingMore: false,
            currentPage: _engine.currentPage,
            totalPages: _engine.maxPages,
            hasMore: _engine.hasMorePages,
          ),
        );
      } else {
        if (_cycles.isEmpty) {
          emit(const CyclesEmpty());
        } else {
          emit(
            CyclesLoaded(
              cycles: _cycles,
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
      emit(CyclesFailure(message: e.message));
    } catch (e) {
      _isLoadingMore = false;
      emit(CyclesFailure(message: e.toString()));
    }
  }

  Future<void> _onRefresh(
    RefreshCycles event,
    Emitter<CyclesState> emit,
  ) async {
    _searchKeyword = '';
    _engine = SearchEngine(
      query: <String, dynamic>{},
      currentPage: 0,
      maxPages: 1,
      totalCount: 0,
    );
    _cycles.clear();
    add(LoadCycles(searchEngine: _engine));
  }
}
