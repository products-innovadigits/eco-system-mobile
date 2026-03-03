import 'package:pms_system/features/cycle_review/model/cycle_review_model.dart';

abstract class CycleReviewRepo {
  Future<CycleDetailModel> getCycleDetail(int cycleId);
}
