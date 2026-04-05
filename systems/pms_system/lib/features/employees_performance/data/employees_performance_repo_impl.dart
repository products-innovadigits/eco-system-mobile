import 'package:pms_system/core/pms_prototype_employees.dart';
import 'package:pms_system/core/utility/pms_exports.dart';
import 'package:pms_system/features/employees_performance/domain/employees_performance_repo.dart';
import 'package:pms_system/features/employees_performance/model/employees_performance_model.dart';

class EmployeesPerformanceRepoImpl implements EmployeesPerformanceRepo {
  final Network network;

  EmployeesPerformanceRepoImpl({required this.network});

  @override
  Future<EmployeesPerformanceModel> getPerformanceData() async {
    // TODO: Replace with real API call when endpoint is available
    // return await network.requestOrThrow(
    //   ApiNames.employeesPerformance,
    //   method: ServerMethods.GET,
    //   model: EmployeesPerformanceModel(),
    // ) as EmployeesPerformanceModel;

    await Future.delayed(const Duration(milliseconds: 800));
    return buildPrototypeEmployeesPerformanceModel();
  }
}
