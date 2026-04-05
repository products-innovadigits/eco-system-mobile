import 'package:pms_system/features/cycle_reports/model/cycle_reports_model.dart';
import 'package:pms_system/features/employees_performance/model/employees_performance_model.dart';

/// Canonical PMS prototype people: one **#1 performer** ([linaId]) everywhere we show
/// rankings (Home podium, Performance monthly/yearly/top 10, cycle reports order).
///
/// Names follow Saudi-style naming; emails use `@prototype.eco` for the directory.
abstract final class PmsPrototypeEmployees {
  static const int linaId = 1;
  static const String linaFullName = 'Lina Al-Harbi';
  static const String linaJobTitle = 'Product Manager';
  static const String linaEmail = 'lina.alharbi@prototype.eco';

  static const int faisalId = 2;
  static const String faisalFullName = 'Faisal Al-Otaibi';
  static const String faisalJobTitle = 'Senior Backend Engineer';

  static const int mahaId = 3;
  static const String mahaFullName = 'Maha Al-Qahtani';
  static const String mahaJobTitle = 'UX Lead';
}

/// Home podium row order is `[2nd, 1st, 3rd]` (left, center, right).
abstract final class PmsPrototypePodiumDisplay {
  static const String rank2FirstName = 'Faisal';
  static const String rank1FirstName = 'Lina';
  static const String rank3FirstName = 'Maha';

  /// Aligned with performance scores (slightly rounded for UI).
  static const String rank2ScoreLabel = '96.0%';
  static const String rank1ScoreLabel = '97.8%';
  static const String rank3ScoreLabel = '94.2%';
}

PerformanceEmployeeModel _perf({
  required int id,
  required String name,
  required String jobTitle,
  required double score,
  required int rank,
  String? reportUrl,
}) =>
    PerformanceEmployeeModel(
      id: id,
      name: name,
      jobTitle: jobTitle,
      score: score,
      rank: rank,
      reportUrl: reportUrl,
    );

/// Same person is **rank 1** on monthly, yearly, and overall top 10 (scores differ by context).
EmployeesPerformanceModel buildPrototypeEmployeesPerformanceModel() {
  final topMonthly = <PerformanceEmployeeModel>[
    _perf(
      id: PmsPrototypeEmployees.linaId,
      name: PmsPrototypeEmployees.linaFullName,
      jobTitle: PmsPrototypeEmployees.linaJobTitle,
      score: 97.0,
      rank: 1,
    ),
    _perf(
      id: PmsPrototypeEmployees.faisalId,
      name: PmsPrototypeEmployees.faisalFullName,
      jobTitle: PmsPrototypeEmployees.faisalJobTitle,
      score: 95.5,
      rank: 2,
    ),
    _perf(
      id: PmsPrototypeEmployees.mahaId,
      name: PmsPrototypeEmployees.mahaFullName,
      jobTitle: PmsPrototypeEmployees.mahaJobTitle,
      score: 93.0,
      rank: 3,
    ),
  ];

  final topYearly = <PerformanceEmployeeModel>[
    _perf(
      id: PmsPrototypeEmployees.linaId,
      name: PmsPrototypeEmployees.linaFullName,
      jobTitle: PmsPrototypeEmployees.linaJobTitle,
      score: 98.0,
      rank: 1,
    ),
    _perf(
      id: PmsPrototypeEmployees.faisalId,
      name: PmsPrototypeEmployees.faisalFullName,
      jobTitle: PmsPrototypeEmployees.faisalJobTitle,
      score: 96.0,
      rank: 2,
    ),
    _perf(
      id: PmsPrototypeEmployees.mahaId,
      name: PmsPrototypeEmployees.mahaFullName,
      jobTitle: PmsPrototypeEmployees.mahaJobTitle,
      score: 94.5,
      rank: 3,
    ),
  ];

  final top10 = <PerformanceEmployeeModel>[
    _perf(
      id: 1,
      name: 'Lina Al-Harbi',
      jobTitle: 'Product Manager',
      score: 97.5,
      rank: 1,
      reportUrl: '#',
    ),
    _perf(
      id: 2,
      name: 'Faisal Al-Otaibi',
      jobTitle: 'Senior Backend Engineer',
      score: 96.0,
      rank: 2,
      reportUrl: '#',
    ),
    _perf(
      id: 3,
      name: 'Maha Al-Qahtani',
      jobTitle: 'UX Lead',
      score: 94.0,
      rank: 3,
      reportUrl: '#',
    ),
    _perf(
      id: 4,
      name: 'Omar Khalil',
      jobTitle: 'Engineering Manager',
      score: 92.5,
      rank: 4,
      reportUrl: '#',
    ),
    _perf(
      id: 5,
      name: 'Dina Mansour',
      jobTitle: 'Scrum Master',
      score: 91.5,
      rank: 5,
      reportUrl: '#',
    ),
    _perf(
      id: 6,
      name: 'Khalid Al-Saeed',
      jobTitle: 'Software Engineer',
      score: 90.5,
      rank: 6,
      reportUrl: '#',
    ),
    _perf(
      id: 7,
      name: 'Nora Abdullah',
      jobTitle: 'QA Engineer',
      score: 89.5,
      rank: 7,
      reportUrl: '#',
    ),
    _perf(
      id: 8,
      name: 'Tariq Al-Mutairi',
      jobTitle: 'Mobile Engineer',
      score: 88.5,
      rank: 8,
      reportUrl: '#',
    ),
    _perf(
      id: 9,
      name: 'Huda Saleh',
      jobTitle: 'QA Lead',
      score: 87.5,
      rank: 9,
      reportUrl: '#',
    ),
    _perf(
      id: 10,
      name: 'Bandar Al-Rashid',
      jobTitle: 'DevOps Engineer',
      score: 86.5,
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

/// Directory rows for [EmployeesLearningRepoImpl] — IDs match performance where applicable.
/// Cycle reports list (submission order): top performer first.
List<CycleReportItemModel> buildPrototypeCycleReportItems() => [
      CycleReportItemModel(
        id: PmsPrototypeEmployees.linaId,
        name: PmsPrototypeEmployees.linaFullName,
        jobTitle: PmsPrototypeEmployees.linaJobTitle,
        imageUrl: null,
      ),
      CycleReportItemModel(
        id: PmsPrototypeEmployees.faisalId,
        name: PmsPrototypeEmployees.faisalFullName,
        jobTitle: PmsPrototypeEmployees.faisalJobTitle,
        imageUrl: null,
      ),
      CycleReportItemModel(
        id: PmsPrototypeEmployees.mahaId,
        name: PmsPrototypeEmployees.mahaFullName,
        jobTitle: PmsPrototypeEmployees.mahaJobTitle,
        imageUrl: null,
      ),
      CycleReportItemModel(
        id: 4,
        name: 'Omar Khalil',
        jobTitle: 'Engineering Manager',
        imageUrl: null,
      ),
      CycleReportItemModel(
        id: 5,
        name: 'Dina Mansour',
        jobTitle: 'Scrum Master',
        imageUrl: null,
      ),
      CycleReportItemModel(
        id: 6,
        name: 'Khalid Al-Saeed',
        jobTitle: 'Software Engineer',
        imageUrl: null,
      ),
    ];

List<Map<String, dynamic>> prototypeEmployeesLearningItems() => [
      {
        'id': PmsPrototypeEmployees.linaId,
        'name': PmsPrototypeEmployees.linaFullName,
        'jobTitle': PmsPrototypeEmployees.linaJobTitle,
        'email': PmsPrototypeEmployees.linaEmail,
        'phone': '+966501000001',
        'seniority': 'Lead',
        'team': 'Product',
      },
      {
        'id': PmsPrototypeEmployees.faisalId,
        'name': PmsPrototypeEmployees.faisalFullName,
        'jobTitle': PmsPrototypeEmployees.faisalJobTitle,
        'email': 'faisal.alotaibi@prototype.eco',
        'phone': '+966501000002',
        'seniority': 'Senior',
        'team': 'Platform',
      },
      {
        'id': PmsPrototypeEmployees.mahaId,
        'name': PmsPrototypeEmployees.mahaFullName,
        'jobTitle': PmsPrototypeEmployees.mahaJobTitle,
        'email': 'maha.alqahtani@prototype.eco',
        'phone': '+966501000003',
        'seniority': 'Lead',
        'team': 'Design',
      },
      {
        'id': 4,
        'name': 'Omar Khalil',
        'jobTitle': 'Engineering Manager',
        'email': 'omar.khalil@prototype.eco',
        'phone': '+966501000004',
        'seniority': 'Senior',
        'team': 'Platform',
      },
      {
        'id': 5,
        'name': 'Dina Mansour',
        'jobTitle': 'Scrum Master',
        'email': 'dina.mansour@prototype.eco',
        'phone': '+966501000005',
        'seniority': 'Senior',
        'team': 'Product',
      },
      {
        'id': 6,
        'name': 'Hala Ibrahim',
        'jobTitle': 'People Operations',
        'email': 'hala.ibrahim@prototype.eco',
        'phone': '+966501111111',
        'seniority': 'Senior',
        'team': 'People',
      },
    ];
