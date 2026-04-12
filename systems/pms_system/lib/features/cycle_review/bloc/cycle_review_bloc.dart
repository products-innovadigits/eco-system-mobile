import 'package:core_system/core/network/error/network_exception.dart';
import 'package:pms_system/core/utility/pms_exports.dart';
import 'package:pms_system/features/cycle_review/bloc/cycle_review_events.dart';
import 'package:pms_system/features/cycle_review/bloc/cycle_review_states.dart';
import 'package:pms_system/features/cycle_review/domain/cycle_review_repo.dart';
import 'package:pms_system/features/cycle_review/model/cycle_review_model.dart';

class CycleReviewBloc extends Bloc<CycleReviewEvent, CycleReviewState> {
  final CycleReviewRepo repo;
  int? _cycleId;

  SearchEngine _engine = SearchEngine();
  final List<CycleRevieweeModel> _reviewees = [];
  bool _isLoadingMore = false;

  CycleReviewBloc({required this.repo}) : super(const CycleReviewInitial()) {
    on<LoadCycleReview>(_onLoad);
    on<LoadReviewCycleSummary>(_onLoadSummary);
    on<LoadReviewees>(_onLoadReviewees);
    on<LoadMoreReviewees>(_onLoadMoreReviewees);
    on<CloseReviewCycle>(_onCloseReviewCycle);
  }

  Future<void> _onLoad(
    LoadCycleReview event,
    Emitter<CycleReviewState> emit,
  ) async {
    try {
      emit(const CycleReviewLoading());

      CycleDetailModel model = await repo.getCycleDetail(event.cycleId);

      if (model.data != null) {
        emit(CycleReviewLoaded(detail: model.data!));
      } else {
        emit(const CycleReviewFailure(message: 'No data found'));
      }
    } on NetworkException catch (e) {
      emit(CycleReviewFailure(message: e.message));
    } catch (e) {
      AppCore.errorMessage(allTranslations.text('something_went_wrong'));
      emit(const CycleReviewFailure(message: 'Failed to load cycle review'));
    }
  }

  Future<void> _onLoadSummary(
    LoadReviewCycleSummary event,
    Emitter<CycleReviewState> emit,
  ) async {
    try {
      emit(const ReviewCycleSummaryLoading());

      final results = await Future.wait<dynamic>([
        repo.getReviewCycleSummary(cycleId: event.cycleId),
        repo.getRevieweeStatus(cycleId: event.cycleId),
      ]);

      final summaryModel = results[0] as CycleSummaryResponseModel;
      final revieweeStatusModel = results[1] as RevieweeStatusResponseModel;

      final summaryData = summaryModel.data;
      final revieweeStatusItems = revieweeStatusModel.data ?? [];

      if (summaryData == null) {
        emit(const ReviewCycleSummaryFailure(message: 'No data found'));
        return;
      }

      emit(
        ReviewCycleSummaryLoaded(
          summary: summaryData,
          revieweeStatusItems: revieweeStatusItems,
          totalReviewees: revieweeStatusModel.total,
        ),
      );
    } on NetworkException catch (e) {
      emit(ReviewCycleSummaryFailure(message: e.message));
    } catch (e) {
      AppCore.errorMessage(allTranslations.text('something_went_wrong'));
      emit(
        const ReviewCycleSummaryFailure(
          message: 'Failed to load review cycle summary',
        ),
      );
    }
  }

  Future<void> _onLoadMoreReviewees(
    LoadMoreReviewees event,
    Emitter<CycleReviewState> emit,
  ) async {
    if (_isLoadingMore || !_engine.hasMorePages || _cycleId == null) return;
    _isLoadingMore = true;
    _engine.updateCurrentPage(_engine.currentPage + 1);
    add(LoadReviewees(cycleId: _cycleId!, searchEngine: _engine));
  }

  Future<void> _onLoadReviewees(
    LoadReviewees event,
    Emitter<CycleReviewState> emit,
  ) async {
    try {
      _cycleId = event.cycleId;
      _engine = event.searchEngine;

      if (_engine.currentPage == 0) {
        _reviewees.clear();
        _isLoadingMore = false;
        emit(const RevieweesLoading());
      } else {
        _isLoadingMore = true;
        emit(
          RevieweesLoaded(
            reviewees: _reviewees,
            isLoadingMore: true,
            currentPage: _engine.currentPage,
            totalPages: _engine.maxPages,
            hasMore: _engine.hasMorePages,
          ),
        );
      }

      final pageIndex = _engine.nextPageIndex;
      _engine.query = <String, dynamic>{
        'page': pageIndex,
        'per_page': _engine.limit,
      };

      final res = await repo.getRevieweeStatusPaginated(
        cycleId: event.cycleId,
        engine: _engine,
      );

      _isLoadingMore = false;

      if (res.data != null && res.data!.isNotEmpty) {
        _reviewees.addAll(
          res.data!.map((e) => e.toCycleRevieweeModel()).toList(),
        );

        if (res.currentPage != null &&
            res.lastPage != null &&
            res.total != null) {
          _engine.syncPaginationFromApi(
            apiCurrentPage: res.currentPage!,
            totalPages: res.lastPage!,
            totalCount: res.total!,
            pageSize: res.perPage,
          );
        }

        emit(
          RevieweesLoaded(
            reviewees: _reviewees,
            isLoadingMore: false,
            currentPage: _engine.currentPage,
            totalPages: _engine.maxPages,
            hasMore: _engine.hasMorePages,
          ),
        );
      } else {
        if (_reviewees.isEmpty) {
          emit(const RevieweesEmpty());
        } else {
          emit(
            RevieweesLoaded(
              reviewees: _reviewees,
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
      if (_reviewees.isNotEmpty) {
        emit(
          RevieweesLoaded(
            reviewees: _reviewees,
            isLoadingMore: false,
            currentPage: _engine.currentPage,
            totalPages: _engine.maxPages,
            hasMore: _engine.hasMorePages,
          ),
        );
      } else {
        emit(RevieweesFailure(message: e.message));
      }
    } catch (e) {
      _isLoadingMore = false;
      if (_reviewees.isNotEmpty) {
        emit(
          RevieweesLoaded(
            reviewees: _reviewees,
            isLoadingMore: false,
            currentPage: _engine.currentPage,
            totalPages: _engine.maxPages,
            hasMore: _engine.hasMorePages,
          ),
        );
      } else {
        emit(RevieweesFailure(message: e.toString()));
      }
    }
  }

  Future<void> _onCloseReviewCycle(
    CloseReviewCycle event,
    Emitter<CycleReviewState> emit,
  ) async {
    final loaded = state;
    if (loaded is! ReviewCycleSummaryLoaded && loaded is! CycleReviewLoaded) {
      return;
    }
    if (loaded is ReviewCycleSummaryLoaded && loaded.isClosingReviewCycle) {
      return;
    }
    if (loaded is CycleReviewLoaded && loaded.isClosingReviewCycle) {
      return;
    }

    void emitClosing(bool closing) {
      if (loaded is ReviewCycleSummaryLoaded) {
        emit(loaded.copyWith(isClosingReviewCycle: closing));
      } else if (loaded is CycleReviewLoaded) {
        emit(loaded.copyWith(isClosingReviewCycle: closing));
      }
    }

    emitClosing(true);

    try {
      await repo.closeReviewCycle(cycleId: event.cycleId);
      AppCore.successMessage(
        allTranslations.text(LocaleKeys.review_cycle_closed_successfully),
      );
      add(LoadReviewCycleSummary(cycleId: event.cycleId));
    } on NetworkException catch (e) {
      AppCore.errorMessage(e.message);
      emitClosing(false);
    } catch (e) {
      AppCore.errorMessage(allTranslations.text('something_went_wrong'));
      emitClosing(false);
    }
  }
}
