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

/// Prototype performance list for the **pms** employees-performance UI (flat `data` list).
///
/// [type] `yearly` nudges scores slightly upward; monthly is the default.
EmployeesPerformanceModel buildPrototypeEmployeesPerformanceModel({String? type}) {
  final isYearly = type == 'yearly';
  final bump = isYearly ? 0.5 : 0.0;

  final rows = <(int id, String name, String email, String job, double base)>[
    (
      PmsPrototypeEmployees.linaId,
      PmsPrototypeEmployees.linaFullName,
      PmsPrototypeEmployees.linaEmail,
      PmsPrototypeEmployees.linaJobTitle,
      97.5,
    ),
    (
      PmsPrototypeEmployees.faisalId,
      PmsPrototypeEmployees.faisalFullName,
      'faisal.alotaibi@prototype.eco',
      PmsPrototypeEmployees.faisalJobTitle,
      96.0,
    ),
    (
      PmsPrototypeEmployees.mahaId,
      PmsPrototypeEmployees.mahaFullName,
      'maha.alqahtani@prototype.eco',
      PmsPrototypeEmployees.mahaJobTitle,
      94.0,
    ),
    (4, 'Omar Khalil', 'omar.khalil@prototype.eco', 'Engineering Manager', 92.5),
    (5, 'Dina Mansour', 'dina.mansour@prototype.eco', 'Scrum Master', 91.5),
    (6, 'Khalid Al-Saeed', 'khalid.alsaeed@prototype.eco', 'Software Engineer', 90.5),
    (7, 'Nora Abdullah', 'nora.abdullah@prototype.eco', 'QA Engineer', 89.5),
    (8, 'Tariq Al-Mutairi', 'tariq.almutairi@prototype.eco', 'Mobile Engineer', 88.5),
    (9, 'Huda Saleh', 'huda.saleh@prototype.eco', 'QA Lead', 87.5),
    (10, 'Bandar Al-Rashid', 'bandar.alrashid@prototype.eco', 'DevOps Engineer', 86.5),
  ];

  final data = <PerformanceEmployeeModel>[];
  for (var i = 0; i < rows.length; i++) {
    final r = rows[i];
    final pct = (r.$5 + bump).clamp(0.0, 100.0);
    data.add(
      PerformanceEmployeeModel(
        id: r.$1,
        name: r.$2,
        email: r.$3,
        jobTitle: r.$4,
        score: pct,
        percentage: pct,
        reviewCycleId: 1,
        reviewCycleName: isYearly ? 'FY 2026 Annual' : 'March 2026 Review',
        closedDate: isYearly ? '2026-03-31' : '2026-03-28',
      ),
    );
  }

  return EmployeesPerformanceModel(data: data);
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
