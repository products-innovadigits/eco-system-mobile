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
    return _simulatedData();
  }

  EmployeesPerformanceModel _simulatedData() {
    final topMonthly = <PerformanceEmployeeModel>[
      PerformanceEmployeeModel(
        id: 1,
        name: 'Lina Al-Harbi',
        jobTitle: 'Product Manager',
        score: 96,
        rank: 1,
      ),
      PerformanceEmployeeModel(
        id: 2,
        name: 'Faisal Al-Otaibi',
        jobTitle: 'Senior Backend Engineer',
        score: 94,
        rank: 2,
      ),
      PerformanceEmployeeModel(
        id: 3,
        name: 'Maha Al-Qahtani',
        jobTitle: 'UX Lead',
        score: 91,
        rank: 3,
      ),
    ];

    final topYearly = <PerformanceEmployeeModel>[
      PerformanceEmployeeModel(
        id: 4,
        name: 'Sara Ahmed',
        jobTitle: 'Product Designer',
        score: 97,
        rank: 1,
      ),
      PerformanceEmployeeModel(
        id: 5,
        name: 'Khalid Saeed',
        jobTitle: 'Software Engineer',
        score: 96,
        rank: 2,
      ),
      PerformanceEmployeeModel(
        id: 6,
        name: 'Nora Abdullah',
        jobTitle: 'QA Engineer',
        score: 95,
        rank: 3,
      ),
    ];

    final top10 = <PerformanceEmployeeModel>[
      PerformanceEmployeeModel(
        id: 7,
        name: 'Omar Khalil',
        jobTitle: 'Engineering Manager',
        score: 92,
        rank: 1,
        reportUrl: '#',
      ),
      PerformanceEmployeeModel(
        id: 8,
        name: 'Dina Mansour',
        jobTitle: 'Scrum Master',
        score: 91,
        rank: 2,
        reportUrl: '#',
      ),
      PerformanceEmployeeModel(
        id: 9,
        name: 'Tariq Al-Mutairi',
        jobTitle: 'Mobile Engineer',
        score: 89,
        rank: 3,
        reportUrl: '#',
      ),
      PerformanceEmployeeModel(
        id: 10,
        name: 'Huda Saleh',
        jobTitle: 'QA Lead',
        score: 88,
        rank: 4,
        reportUrl: '#',
      ),
      PerformanceEmployeeModel(
        id: 11,
        name: 'Bandar Al-Rashid',
        jobTitle: 'DevOps Engineer',
        score: 87,
        rank: 5,
        reportUrl: '#',
      ),
      PerformanceEmployeeModel(
        id: 12,
        name: 'Sara Ahmed',
        jobTitle: 'Product Designer',
        score: 87,
        rank: 6,
        reportUrl: '#',
      ),
      PerformanceEmployeeModel(
        id: 13,
        name: 'Hassan Aziz',
        jobTitle: 'UI Designer',
        score: 86,
        rank: 7,
        reportUrl: '#',
      ),
      PerformanceEmployeeModel(
        id: 14,
        name: 'Rawan Adel',
        jobTitle: 'UX Researcher',
        score: 85,
        rank: 8,
        reportUrl: '#',
      ),
      PerformanceEmployeeModel(
        id: 15,
        name: 'Youssef Ibrahim',
        jobTitle: 'DevOps Engineer',
        score: 84,
        rank: 9,
        reportUrl: '#',
      ),
      PerformanceEmployeeModel(
        id: 16,
        name: 'Ahmed Ali',
        jobTitle: 'Backend Developer',
        score: 83,
        rank: 10,
        reportUrl: '#',
      ),
    ];

    return EmployeesPerformanceModel(
      succeeded: true,
      data: EmployeesPerformanceDataModel(
        topMonthly: topMonthly,
        topYearly: topYearly,
        top10: top10,
      ),
    );
  }
}
