import 'package:pms_system/core/utility/pms_exports.dart';

abstract class CycleReviewEvent {
  const CycleReviewEvent();
}

class LoadCycleReview extends CycleReviewEvent {
  final int cycleId;

  const LoadCycleReview({required this.cycleId});
}

class LoadReviewCycleSummary extends CycleReviewEvent {
  final int cycleId;

  const LoadReviewCycleSummary({required this.cycleId});
}

class LoadReviewees extends CycleReviewEvent {
  final int cycleId;
  final SearchEngine searchEngine;

  const LoadReviewees({required this.cycleId, required this.searchEngine});
}

class LoadMoreReviewees extends CycleReviewEvent {
  const LoadMoreReviewees();
}

class CloseReviewCycle extends CycleReviewEvent {
  final int cycleId;

  const CloseReviewCycle({required this.cycleId});
}
