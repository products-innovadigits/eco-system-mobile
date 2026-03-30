import 'package:pms_system/core/utility/pms_exports.dart';
import 'package:pms_system/features/employee_learning_details/domain/employee_learning_details_repo.dart';
import 'package:pms_system/features/employee_learning_details/model/employee_learning_details_model.dart';

class EmployeeLearningDetailsRepoImpl implements EmployeeLearningDetailsRepo {
  final Network network;

  EmployeeLearningDetailsRepoImpl({required this.network});

  @override
  Future<ReviewCyclesModel> getReviewCycles({required int userId}) async {
    return await network.requestOrThrow(
      ApiNames.userReviewCycles(userId),
      query: {'id': userId},
      method: ServerMethods.GET,
      systemTypeEnum: ActiveSystemEnum.pms,
      model: ReviewCyclesModel(),
    );
  }

  @override
  Future<LastReviewCycleReportModel> getLastReviewCycleReport({
    required int userId,
  }) async {
    return await network.requestOrThrow(
      ApiNames.userLastReviewCycleReport(userId),
      query: {'id': userId},
      method: ServerMethods.GET,
      systemTypeEnum: ActiveSystemEnum.pms,
      model: LastReviewCycleReportModel(),
    );
  }
}
