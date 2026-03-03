abstract class CycleReviewEvent {
  const CycleReviewEvent();
}

class LoadCycleReview extends CycleReviewEvent {
  final int cycleId;

  const LoadCycleReview({required this.cycleId});
}
