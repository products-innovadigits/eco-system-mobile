import 'package:pms_system/core/utility/pms_exports.dart';
import 'package:pms_system/features/cycle_review/model/cycle_review_model.dart';

abstract class CycleReviewRepo {
  Future<CycleDetailModel> getCycleDetail(int cycleId);

  Future<CycleSummaryResponseModel> getReviewCycleSummary({
    required int cycleId,
  });

  Future<RevieweeStatusResponseModel> getRevieweeStatus({
    required int cycleId,
  });

  Future<RevieweeStatusResponseModel> getRevieweeStatusPaginated({
    required int cycleId,
    required SearchEngine engine,
  });

  /// POST `appraisal/review-cycles/{cycleId}/close-review-cycle`
  Future<void> closeReviewCycle({required int cycleId});
}
