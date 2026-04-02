import 'package:pms_system/core/pms_prototype_data.dart';
import 'package:pms_system/core/utility/pms_exports.dart';
import 'package:pms_system/features/cycle_review/domain/cycle_review_repo.dart';
import 'package:pms_system/features/cycle_review/model/cycle_review_model.dart';

/// Prototype: simulated cycle review — no API.
class CycleReviewRepoImpl implements CycleReviewRepo {
  final Network network;

  CycleReviewRepoImpl({required this.network});

  @override
  Future<CycleDetailModel> getCycleDetail(int cycleId) async {
    await Future.delayed(const Duration(milliseconds: 220));
    return buildPrototypeCycleDetail(cycleId);
  }

  @override
  Future<CycleSummaryResponseModel> getReviewCycleSummary({
    required int cycleId,
  }) async {
    await Future.delayed(const Duration(milliseconds: 200));
    return buildPrototypeCycleSummary(cycleId);
  }

  @override
  Future<RevieweeStatusResponseModel> getRevieweeStatus({
    required int cycleId,
  }) async {
    await Future.delayed(const Duration(milliseconds: 200));
    return buildPrototypeRevieweeStatus();
  }

  @override
  Future<RevieweeStatusResponseModel> getRevieweeStatusPaginated({
    required int cycleId,
    required SearchEngine engine,
  }) async {
    await Future.delayed(const Duration(milliseconds: 200));
    return buildPrototypeRevieweeStatus();
  }
}
