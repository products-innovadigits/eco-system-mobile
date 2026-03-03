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
