import 'package:pms_system/core/utility/pms_exports.dart';
import 'package:pms_system/features/employees_learning/domain/employees_learning_repo.dart';
import 'package:pms_system/features/employees_learning/model/employees_filters_model.dart';
import 'package:pms_system/features/employees_learning/model/employees_learning_model.dart';

class EmployeesLearningRepoImpl implements EmployeesLearningRepo {
  final Network network;

  EmployeesLearningRepoImpl({required this.network});

  @override
  Future<EmployeesLearningModel> getEmployees(SearchEngine data) async {
    // TODO: Replace with real API call
    // return await network.requestOrThrow(
    //   ApiNames.employeesLearning,
    //   query: data.query,
    //   method: ServerMethods.POST,
    //   model: EmployeesLearningModel(),
    // ) as EmployeesLearningModel;

    await Future.delayed(const Duration(milliseconds: 800));
    return _simulatedEmployees(data);
  }

  @override
  Future<EmployeesFiltersModel> getFilterOptions() async {
    // TODO: Replace with real API call
    await Future.delayed(const Duration(milliseconds: 500));
    return _simulatedFilters();
  }

  static final _allEmployees = <EmployeeItemModel>[
    EmployeeItemModel(
      id: 1,
      name: 'Hassan Aziz',
      jobTitle: 'Product Designer',
      email: 'hassan@gmail.com',
      phone: '+201029840986',
      seniority: 'Team Leader',
      team: 'Designing',
      initials: 'HA',
    ),
    EmployeeItemModel(
      id: 2,
      name: 'Sara Ahmed',
      jobTitle: 'Software Engineer',
      email: 'sara.ahmed@gmail.com',
      phone: '+201112345678',
      seniority: 'Senior',
      team: 'Engineering',
      initials: 'SA',
    ),
    EmployeeItemModel(
      id: 3,
      name: 'Mohamed Khaled',
      jobTitle: 'Project Manager',
      email: 'mohamed.k@gmail.com',
      phone: '+201098765432',
      seniority: 'Manager',
      team: 'Management',
      initials: 'MK',
    ),
    EmployeeItemModel(
      id: 4,
      name: 'Nora Abdullah',
      jobTitle: 'QA Engineer',
      email: 'nora.a@gmail.com',
      phone: '+201234567890',
      seniority: 'Mid-Level',
      team: 'Engineering',
      initials: 'NA',
    ),
    EmployeeItemModel(
      id: 5,
      name: 'Khalid Saeed',
      jobTitle: 'UI Designer',
      email: 'khalid.s@gmail.com',
      phone: '+201187654321',
      seniority: 'Junior',
      team: 'Designing',
      initials: 'KS',
    ),
    EmployeeItemModel(
      id: 6,
      name: 'Fatima Omar',
      jobTitle: 'Business Analyst',
      email: 'fatima.o@gmail.com',
      phone: '+201056789012',
      seniority: 'Senior',
      team: 'Management',
      initials: 'FO',
    ),
    EmployeeItemModel(
      id: 7,
      name: 'Youssef Ibrahim',
      jobTitle: 'DevOps Engineer',
      email: 'youssef.i@gmail.com',
      phone: '+201145678901',
      seniority: 'Team Leader',
      team: 'Engineering',
      initials: 'YI',
    ),
    EmployeeItemModel(
      id: 8,
      name: 'Rawan Adel',
      jobTitle: 'UX Researcher',
      email: 'rawan.a@gmail.com',
      phone: '+201067890123',
      seniority: 'Mid-Level',
      team: 'Designing',
      initials: 'RA',
    ),
    EmployeeItemModel(
      id: 9,
      name: 'Ahmed Ali',
      jobTitle: 'Backend Developer',
      email: 'ahmed.ali@gmail.com',
      phone: '+201178901234',
      seniority: 'Senior',
      team: 'Engineering',
      initials: 'AA',
    ),
    EmployeeItemModel(
      id: 10,
      name: 'Layla Mansour',
      jobTitle: 'HR Specialist',
      email: 'layla.m@gmail.com',
      phone: '+201089012345',
      seniority: 'Manager',
      team: 'Human Resources',
      initials: 'LM',
    ),
    EmployeeItemModel(
      id: 11,
      name: 'Omar Faisal',
      jobTitle: 'Frontend Developer',
      email: 'omar.f@gmail.com',
      phone: '+201190123456',
      seniority: 'Junior',
      team: 'Engineering',
      initials: 'OF',
    ),
    EmployeeItemModel(
      id: 12,
      name: 'Amina Saleh',
      jobTitle: 'Marketing Lead',
      email: 'amina.s@gmail.com',
      phone: '+201001234567',
      seniority: 'Team Leader',
      team: 'Marketing',
      initials: 'AS',
    ),
  ];

  EmployeesLearningModel _simulatedEmployees(SearchEngine data) {
    final query = data.query as Map<String, dynamic>? ?? {};
    final keyword = query['searchKeyword'] as String?;
    final teamId = query['teamId'] as int?;
    final seniorityId = query['seniorityLevelId'] as int?;

    var filtered = List<EmployeeItemModel>.from(_allEmployees);

    if (keyword != null && keyword.isNotEmpty) {
      filtered = filtered
          .where(
            (e) => e.name!.toLowerCase().contains(keyword.toLowerCase()),
          )
          .toList();
    }

    if (teamId != null) {
      final teamName = _teamNameById(teamId);
      if (teamName != null) {
        filtered = filtered.where((e) => e.team == teamName).toList();
      }
    }

    if (seniorityId != null) {
      final seniorityName = _seniorityNameById(seniorityId);
      if (seniorityName != null) {
        filtered = filtered.where((e) => e.seniority == seniorityName).toList();
      }
    }

    final pageIndex = (query['pageIndex'] as int?) ?? 1;
    final pageSize = data.limit;
    final start = (pageIndex - 1) * pageSize;
    final end =
        start + pageSize > filtered.length ? filtered.length : start + pageSize;
    final pageItems =
        start < filtered.length ? filtered.sublist(start, end) : <EmployeeItemModel>[];
    final totalPages = (filtered.length / pageSize).ceil();

    return EmployeesLearningModel(
      succeeded: true,
      data: EmployeesDataModel(
        items: pageItems,
        currentPage: pageIndex,
        pageSize: pageSize,
        totalPages: totalPages > 0 ? totalPages : 1,
        totalCount: filtered.length,
        isLastPage: pageIndex >= totalPages,
      ),
    );
  }

  String? _teamNameById(int id) {
    const map = {
      1: 'Designing',
      2: 'Engineering',
      3: 'Management',
      4: 'Human Resources',
      5: 'Marketing',
    };
    return map[id];
  }

  String? _seniorityNameById(int id) {
    const map = {
      1: 'Junior',
      2: 'Mid-Level',
      3: 'Senior',
      4: 'Team Leader',
      5: 'Manager',
    };
    return map[id];
  }

  EmployeesFiltersModel _simulatedFilters() {
    return EmployeesFiltersModel(
      succeeded: true,
      data: EmployeesFiltersData(
        teams: [
          FilterOptionItem(id: 1, name: 'Designing'),
          FilterOptionItem(id: 2, name: 'Engineering'),
          FilterOptionItem(id: 3, name: 'Management'),
          FilterOptionItem(id: 4, name: 'Human Resources'),
          FilterOptionItem(id: 5, name: 'Marketing'),
        ],
        seniorityLevels: [
          FilterOptionItem(id: 1, name: 'Junior'),
          FilterOptionItem(id: 2, name: 'Mid-Level'),
          FilterOptionItem(id: 3, name: 'Senior'),
          FilterOptionItem(id: 4, name: 'Team Leader'),
          FilterOptionItem(id: 5, name: 'Manager'),
        ],
      ),
    );
  }
}
