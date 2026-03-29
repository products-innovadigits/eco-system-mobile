import 'package:pms_system/core/utility/pms_exports.dart';
import 'package:pms_system/features/employees_learning/domain/employees_learning_repo.dart';
import 'package:pms_system/features/employees_learning/model/employees_filters_model.dart';
import 'package:pms_system/features/employees_learning/model/employees_learning_model.dart';

class EmployeesLearningRepoImpl implements EmployeesLearningRepo {
  final Network network;

  EmployeesLearningRepoImpl({required this.network});

  @override
  Future<EmployeesLearningModel> getEmployees(SearchEngine data) async {
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

    return await network.requestOrThrow(
      ApiNames.users,
      query: apiQuery,
      method: ServerMethods.GET,
      systemTypeEnum: ActiveSystemEnum.pms,
      model: EmployeesLearningModel(),
    ) as EmployeesLearningModel;
  }

  @override
  Future<EmployeesFiltersModel> getFilterOptions() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return _simulatedFilters();
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
