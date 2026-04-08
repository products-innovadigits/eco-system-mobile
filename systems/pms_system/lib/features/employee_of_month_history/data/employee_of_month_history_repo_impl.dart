import 'package:pms_system/core/pms_prototype_employees.dart';
import 'package:pms_system/core/utility/pms_exports.dart';
import 'package:pms_system/features/employee_of_month_history/domain/employee_of_month_history_repo.dart';
import 'package:pms_system/features/employee_of_month_history/model/employee_of_month_history_model.dart';
import 'package:pms_system/features/employees_learning/model/employees_filters_model.dart';
import 'package:pms_system/features/employees_learning/model/seniority_levels_model.dart';
import 'package:pms_system/features/employees_learning/model/teams_model.dart';

/// Prototype: in-memory history + same filter shape as [EmployeesLearningRepoImpl] — no API.
class EmployeeOfMonthHistoryRepoImpl implements EmployeeOfMonthHistoryRepo {
  final Network network;

  EmployeeOfMonthHistoryRepoImpl({required this.network});

  static List<Map<String, dynamic>> _rawHistoryRows() {
    // _teamId / _seniorityId align with [EmployeesLearningRepoImpl] prototype teams & seniority IDs.
    return [
      _row(
        PmsPrototypeEmployees.linaFullName,
        PmsPrototypeEmployees.linaEmail,
        PmsPrototypeEmployees.linaJobTitle,
        'March',
        '2026',
        98.0,
        teamId: 4,
        seniorityId: 4,
      ),
      _row(
        PmsPrototypeEmployees.faisalFullName,
        'faisal.alotaibi@prototype.eco',
        PmsPrototypeEmployees.faisalJobTitle,
        'February',
        '2026',
        96.5,
        teamId: 1,
        seniorityId: 3,
      ),
      _row(
        PmsPrototypeEmployees.mahaFullName,
        'maha.alqahtani@prototype.eco',
        PmsPrototypeEmployees.mahaJobTitle,
        'January',
        '2026',
        95.0,
        teamId: 2,
        seniorityId: 4,
      ),
      _row(
        'Omar Khalil',
        'omar.khalil@prototype.eco',
        'Engineering Manager',
        'December',
        '2025',
        94.2,
        teamId: 1,
        seniorityId: 3,
      ),
      _row(
        'Dina Mansour',
        'dina.mansour@prototype.eco',
        'Scrum Master',
        'November',
        '2025',
        93.1,
        teamId: 4,
        seniorityId: 3,
      ),
      _row(
        'Hala Ibrahim',
        'hala.ibrahim@prototype.eco',
        'People Operations',
        'October',
        '2025',
        92.4,
        teamId: 3,
        seniorityId: 3,
      ),
      _row(
        PmsPrototypeEmployees.linaFullName,
        PmsPrototypeEmployees.linaEmail,
        PmsPrototypeEmployees.linaJobTitle,
        'September',
        '2025',
        97.2,
        teamId: 4,
        seniorityId: 4,
      ),
      _row(
        PmsPrototypeEmployees.faisalFullName,
        'faisal.alotaibi@prototype.eco',
        PmsPrototypeEmployees.faisalJobTitle,
        'August',
        '2025',
        95.8,
        teamId: 1,
        seniorityId: 3,
      ),
      _row(
        'Khalid Al-Saeed',
        'khalid.alsaeed@prototype.eco',
        'Software Engineer',
        'July',
        '2025',
        90.0,
        teamId: 1,
        seniorityId: 2,
      ),
      _row(
        'Nora Abdullah',
        'nora.abdullah@prototype.eco',
        'QA Engineer',
        'June',
        '2025',
        89.2,
        teamId: 1,
        seniorityId: 2,
      ),
    ];
  }

  static Map<String, dynamic> _row(
    String name,
    String email,
    String jobTitle,
    String month,
    String year,
    double percentage, {
    required int teamId,
    required int seniorityId,
  }) {
    return {
      'name': name,
      'email': email,
      'job_title': jobTitle,
      'month': month,
      'year': year,
      'score': percentage.toStringAsFixed(1),
      'percentage': percentage,
      '_teamId': teamId,
      '_seniorityId': seniorityId,
    };
  }

  @override
  Future<EmployeeOfMonthHistoryModel> getHistory(SearchEngine data) async {
    await Future.delayed(const Duration(milliseconds: 400));

    final query = data.query as Map<String, dynamic>? ?? {};
    final pageIndex = (query['pageIndex'] as int?) ?? data.nextPageIndex;
    final perPage = (query['pageSize'] as int?) ?? data.limit;
    final keyword = (query['keyword'] as String?)?.toLowerCase().trim() ?? '';
    final teamId = query['teamId'];
    final seniorityLevelId = query['seniorityLevelId'];

    var raw = _rawHistoryRows();

    if (keyword.isNotEmpty) {
      raw = raw.where((row) {
        final n = (row['name'] as String).toLowerCase();
        final e = (row['email'] as String).toLowerCase();
        return n.contains(keyword) || e.contains(keyword);
      }).toList();
    }
    if (teamId != null) {
      raw = raw.where((row) => row['_teamId'] == teamId).toList();
    }
    if (seniorityLevelId != null) {
      raw = raw.where((row) => row['_seniorityId'] == seniorityLevelId).toList();
    }

    final totalCount = raw.length;
    final totalPages = totalCount == 0 ? 1 : ((totalCount + perPage - 1) ~/ perPage);
    final safePage = pageIndex.clamp(1, totalPages);
    final start = (safePage - 1) * perPage;
    final pageRaw = raw.skip(start).take(perPage).toList();

    final items = pageRaw.map((row) {
      final copy = Map<String, dynamic>.from(row)
        ..remove('_teamId')
        ..remove('_seniorityId');
      return EmployeeOfMonthHistoryItemModel.fromJson(copy);
    }).toList();

    return EmployeeOfMonthHistoryModel(
      succeeded: true,
      status: 200,
      data: EmployeeOfMonthHistoryDataModel(
        items: items,
        currentPage: safePage,
        pageSize: perPage,
        totalPages: totalPages,
        nextPage: safePage < totalPages ? safePage + 1 : null,
        previousPage: safePage > 1 ? safePage - 1 : null,
        isLastPage: safePage >= totalPages,
        totalCount: totalCount,
      ),
    );
  }

  @override
  Future<EmployeesFiltersModel> getFilterOptions() async {
    await Future.delayed(const Duration(milliseconds: 120));

    final seniorityModel = SeniorityLevelsModel.fromJson({
      'succeeded': true,
      'status': 200,
      'data': [
        {'id': 1, 'name': 'Junior', 'sort_order': 1},
        {'id': 2, 'name': 'Mid', 'sort_order': 2},
        {'id': 3, 'name': 'Senior', 'sort_order': 3},
        {'id': 4, 'name': 'Lead', 'sort_order': 4},
      ],
    });

    final teamsModel = TeamsModel.fromJson({
      'succeeded': true,
      'status': 200,
      'data': [
        {'id': 1, 'name': 'Platform', 'color': '#1565C0'},
        {'id': 2, 'name': 'Design', 'color': '#00897B'},
        {'id': 3, 'name': 'People', 'color': '#F9A825'},
        {'id': 4, 'name': 'Product', 'color': '#6A1B9A'},
      ],
    });

    final seniorityItems = seniorityModel.data
        ?.map((item) => FilterOptionItem(id: item.id, name: item.name))
        .toList();

    final teamItems = teamsModel.data
        ?.map((item) => FilterOptionItem(id: item.id, name: item.name))
        .toList();

    final allSucceeded =
        (seniorityModel.succeeded ?? false) && (teamsModel.succeeded ?? false);

    return EmployeesFiltersModel(
      succeeded: allSucceeded,
      data: EmployeesFiltersData(
        seniorityLevels: seniorityItems,
        teams: teamItems,
      ),
    );
  }
}
