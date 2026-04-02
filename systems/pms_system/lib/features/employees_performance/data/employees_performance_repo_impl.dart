import 'package:pms_system/core/utility/pms_exports.dart';
import 'package:pms_system/features/employees_performance/domain/employees_performance_repo.dart';
import 'package:pms_system/features/employees_performance/model/employees_performance_model.dart';

class EmployeesPerformanceRepoImpl implements EmployeesPerformanceRepo {
  final Network network;

  EmployeesPerformanceRepoImpl({required this.network});

  @override
  Future<EmployeesPerformanceModel> getPerformanceData({String? type}) async {
    final query = <String, dynamic>{};
    if (type != null) {
      query['type'] = type;
    }

    return await network.requestOrThrow(
      ApiNames.employeesTopTen,
      method: ServerMethods.GET,
      query: query.isNotEmpty ? query : null,
      systemTypeEnum: ActiveSystemEnum.pms,
      model: EmployeesPerformanceModel(),
    ) as EmployeesPerformanceModel;
  }

  @override
  Future<void> setEmployeeOfTheMonth({
    required int userId,
    required int reviewCycleId,
    required double score,
  }) async {
    await network.requestOrThrow(
      ApiNames.setEmployeeOfTheMonth,
      method: ServerMethods.POST,
      query: {
        'user_id': userId,
        'review_cycle_id': reviewCycleId,
        'score': score,
      },
      systemTypeEnum: ActiveSystemEnum.pms,
    );
  }
}
