import 'package:pms_system/core/pms_prototype_employees.dart';
import 'package:pms_system/core/utility/pms_exports.dart';
import 'package:pms_system/features/employees_learning/domain/employees_learning_repo.dart';
import 'package:pms_system/features/employees_learning/model/employees_filters_model.dart';
import 'package:pms_system/features/employees_learning/model/employees_learning_model.dart';
import 'package:pms_system/features/employees_learning/model/seniority_levels_model.dart';
import 'package:pms_system/features/employees_learning/model/teams_model.dart';

/// Prototype: simulated employee directory & filters — no API.
class EmployeesLearningRepoImpl implements EmployeesLearningRepo {
  final Network network;

  EmployeesLearningRepoImpl({required this.network});

  @override
  Future<EmployeesLearningModel> getEmployees(SearchEngine data) async {
    await Future.delayed(const Duration(milliseconds: 220));
    final items = prototypeEmployeesLearningItems();
    return EmployeesLearningModel.fromJson({
      'succeeded': true,
      'status': 200,
      'data': {
        'items': items,
        'currentPage': 1,
        'pageSize': 20,
        'totalPages': 1,
        'nextPage': null,
        'previousPage': null,
        'isLastPage': true,
        'totalCount': items.length,
      },
    });
  }

  @override
  Future<SeniorityLevelsModel> getSeniorityLevels() async {
    await Future.delayed(const Duration(milliseconds: 120));
    return SeniorityLevelsModel.fromJson({
      'succeeded': true,
      'status': 200,
      'data': [
        {'id': 1, 'name': 'Junior', 'sort_order': 1},
        {'id': 2, 'name': 'Mid', 'sort_order': 2},
        {'id': 3, 'name': 'Senior', 'sort_order': 3},
        {'id': 4, 'name': 'Lead', 'sort_order': 4},
      ],
    });
  }

  @override
  Future<TeamsModel> getTeams() async {
    await Future.delayed(const Duration(milliseconds: 120));
    return TeamsModel.fromJson({
      'succeeded': true,
      'status': 200,
      'data': [
        {'id': 1, 'name': 'Platform', 'color': '#1565C0'},
        {'id': 2, 'name': 'Design', 'color': '#00897B'},
        {'id': 3, 'name': 'People', 'color': '#F9A825'},
        {'id': 4, 'name': 'Product', 'color': '#6A1B9A'},
      ],
    });
  }

  @override
  Future<EmployeesFiltersModel> getFilterOptions() async {
    final results = await Future.wait([
      getSeniorityLevels(),
      getTeams(),
    ]);

    final seniorityModel = results[0] as SeniorityLevelsModel;
    final teamsModel = results[1] as TeamsModel;

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
