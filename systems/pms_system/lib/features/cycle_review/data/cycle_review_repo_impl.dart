import 'package:pms_system/core/utility/pms_exports.dart';
import 'package:pms_system/features/cycle_review/domain/cycle_review_repo.dart';
import 'package:pms_system/features/cycle_review/model/cycle_review_model.dart';

class CycleReviewRepoImpl implements CycleReviewRepo {
  final Network network;

  CycleReviewRepoImpl({required this.network});

  @override
  Future<CycleDetailModel> getCycleDetail(int cycleId) async {
    return await network.requestOrThrow(
      ApiNames.reviewCycleSummary(cycleId),
      method: ServerMethods.GET,
      systemTypeEnum: ActiveSystemEnum.pms,
      model: CycleDetailModel(),
    );
  }

  @override
  Future<CycleSummaryResponseModel> getReviewCycleSummary({
    required int cycleId,
  }) async {
    return await network.requestOrThrow(
      ApiNames.reviewCycleSummary(cycleId),
      method: ServerMethods.GET,
      systemTypeEnum: ActiveSystemEnum.pms,
      model: CycleSummaryResponseModel(),
    );
  }

  @override
  Future<RevieweeStatusResponseModel> getRevieweeStatus({
    required int cycleId,
  }) async {
    return await network.requestOrThrow(
      ApiNames.reviewCycleRevieweeStatus(cycleId),
      method: ServerMethods.GET,
      systemTypeEnum: ActiveSystemEnum.pms,
      model: RevieweeStatusResponseModel(),
    );
  }

  @override
  Future<RevieweeStatusResponseModel> getRevieweeStatusPaginated({
    required int cycleId,
    required SearchEngine engine,
  }) async {
    return await network.requestOrThrow(
      ApiNames.reviewCycleRevieweeStatus(cycleId),
      method: ServerMethods.GET,
      query: engine.query,
      systemTypeEnum: ActiveSystemEnum.pms,
      model: RevieweeStatusResponseModel(),
    );
  }
}
