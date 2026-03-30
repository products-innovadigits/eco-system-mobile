import 'package:pms_system/features/employee_learning_details/model/employee_learning_details_model.dart';

abstract class EmployeeLearningDetailsRepo {
  Future<ReviewCyclesModel> getReviewCycles({required int userId});

  Future<LastReviewCycleReportModel> getLastReviewCycleReport({
    required int userId,
  });
}
