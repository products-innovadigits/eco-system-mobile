import 'package:pms_system/features/cycle_review/model/cycle_review_model.dart';

abstract class CycleReviewState {
  const CycleReviewState();
}

class CycleReviewInitial extends CycleReviewState {
  const CycleReviewInitial();
}

class CycleReviewLoading extends CycleReviewState {
  const CycleReviewLoading();
}

class CycleReviewLoaded extends CycleReviewState {
  final CycleDetailDataModel detail;

  const CycleReviewLoaded({required this.detail});
}

class CycleReviewFailure extends CycleReviewState {
  final String message;

  const CycleReviewFailure({required this.message});
}

class ReviewCycleSummaryLoading extends CycleReviewState {
  const ReviewCycleSummaryLoading();
}

class ReviewCycleSummaryLoaded extends CycleReviewState {
  final CycleSummaryDataModel summary;
  final List<RevieweeStatusItemModel> revieweeStatusItems;
  final int? totalReviewees;

  const ReviewCycleSummaryLoaded({
    required this.summary,
    required this.revieweeStatusItems,
    this.totalReviewees,
  });
}

class ReviewCycleSummaryFailure extends CycleReviewState {
  final String message;

  const ReviewCycleSummaryFailure({required this.message});
}

class RevieweesLoading extends CycleReviewState {
  const RevieweesLoading();
}

class RevieweesLoaded extends CycleReviewState {
  final List<CycleRevieweeModel> reviewees;
  final bool isLoadingMore;
  final int currentPage;
  final int totalPages;
  final bool hasMore;

  const RevieweesLoaded({
    required this.reviewees,
    this.isLoadingMore = false,
    this.currentPage = 0,
    this.totalPages = 1,
    this.hasMore = false,
  });
}

class RevieweesEmpty extends CycleReviewState {
  const RevieweesEmpty();
}

class RevieweesFailure extends CycleReviewState {
  final String message;

  const RevieweesFailure({required this.message});
}
