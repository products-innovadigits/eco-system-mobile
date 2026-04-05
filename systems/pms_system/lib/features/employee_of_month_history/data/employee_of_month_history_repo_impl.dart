import 'package:pms_system/core/utility/pms_exports.dart';
import 'package:pms_system/features/employee_of_month_history/domain/employee_of_month_history_repo.dart';
import 'package:pms_system/features/employee_of_month_history/model/employee_of_month_history_model.dart';
import 'package:pms_system/features/employees_learning/model/employees_filters_model.dart';
import 'package:pms_system/features/employees_learning/model/seniority_levels_model.dart';
import 'package:pms_system/features/employees_learning/model/teams_model.dart';

class EmployeeOfMonthHistoryRepoImpl implements EmployeeOfMonthHistoryRepo {
  final Network network;

  EmployeeOfMonthHistoryRepoImpl({required this.network});

  @override
  Future<EmployeeOfMonthHistoryModel> getHistory(SearchEngine data) async {
    final query = data.query as Map<String, dynamic>? ?? <String, dynamic>{};
    final page = (query['pageIndex'] as int?) ?? data.nextPageIndex;
    final perPage = (query['pageSize'] as int?) ?? data.limit;

    final apiQuery = <String, dynamic>{
      'page': page,
      'per_page': perPage,
    };

    final keyword = query['keyword'] as String?;
    if (keyword != null && keyword.isNotEmpty) {
      apiQuery['keyword'] = keyword;
    }

    final teamId = query['teamId'];
    if (teamId != null) {
      apiQuery['team_id'] = teamId;
    }

    final seniorityLevelId = query['seniorityLevelId'];
    if (seniorityLevelId != null) {
      apiQuery['seniority_level_id'] = seniorityLevelId;
    }

    return await network.requestOrThrow(
      ApiNames.employeeOfTheMonthHistory,
      query: apiQuery,
      method: ServerMethods.GET,
      systemTypeEnum: ActiveSystemEnum.pms,
      model: EmployeeOfMonthHistoryModel(),
    ) as EmployeeOfMonthHistoryModel;
  }

  @override
  Future<EmployeesFiltersModel> getFilterOptions() async {
    final seniorityModel = await network.requestOrThrow(
      ApiNames.seniorityLevels,
      method: ServerMethods.GET,
      systemTypeEnum: ActiveSystemEnum.pms,
      model: SeniorityLevelsModel(),
    ) as SeniorityLevelsModel;

    final teamsModel = await network.requestOrThrow(
      ApiNames.allTeams,
      method: ServerMethods.GET,
      systemTypeEnum: ActiveSystemEnum.pms,
      model: TeamsModel(),
    ) as TeamsModel;

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
