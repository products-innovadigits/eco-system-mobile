import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pms_system/core/utility/pms_exports.dart';
import 'package:pms_system/features/employees_learning/data/employees_learning_repo_impl.dart';
import 'package:pms_system/features/employees_learning/model/employees_filters_model.dart';
import 'package:pms_system/features/employees_learning/model/employees_learning_model.dart';
import 'package:pms_system/features/employees_learning/model/seniority_levels_model.dart';
import 'package:pms_system/features/employees_learning/model/teams_model.dart';

import '../../../core/mocks/fallbacks.dart';
import '../../../core/mocks/mock_network.dart';
import '../../../helpers/fixture_reader.dart';

void main() {
  setUpAll(() {
    initMocktailFallbacks();
  });

  late MockNetwork mockNetwork;
  late EmployeesLearningRepoImpl repo;

  final usersListFixture =
      readJsonFixture('employees_learning/employees_learning_response.json');

  setUp(() {
    mockNetwork = MockNetwork();
    repo = EmployeesLearningRepoImpl(network: mockNetwork);
  });

  group('EmployeesLearningRepoImpl', () {
    group('getEmployees', () {
      test('calls users endpoint and returns EmployeesLearningModel', () async {
        when(
          () => mockNetwork.requestOrThrow(
            ApiNames.users,
            query: any(named: 'query'),
            method: ServerMethods.GET,
            systemTypeEnum: ActiveSystemEnum.pms,
            model: any(named: 'model'),
          ),
        ).thenAnswer((_) async {
          return EmployeesLearningModel.fromJson(usersListFixture);
        });

        final searchEngine = SearchEngine();

        final result = await repo.getEmployees(searchEngine);

        expect(result, isNotNull);
        expect(result, isA<EmployeesLearningModel>());
        expect(result.succeeded, isTrue);
        expect(result.data?.items, isNotEmpty);

        verify(
          () => mockNetwork.requestOrThrow(
            ApiNames.users,
            query: <String, dynamic>{
              'page': 1,
              'per_page': 10,
            },
            method: ServerMethods.GET,
            systemTypeEnum: ActiveSystemEnum.pms,
            model: any(named: 'model'),
          ),
        ).called(1);
      });

      test('passes keyword in query when present', () async {
        when(
          () => mockNetwork.requestOrThrow(
            any(),
            query: any(named: 'query'),
            method: any(named: 'method'),
            systemTypeEnum: any(named: 'systemTypeEnum'),
            model: any(named: 'model'),
          ),
        ).thenAnswer((_) async {
          return EmployeesLearningModel.fromJson(usersListFixture);
        });

        final searchEngine = SearchEngine(
          query: <String, dynamic>{'keyword': 'Nsry'},
        );

        await repo.getEmployees(searchEngine);

        verify(
          () => mockNetwork.requestOrThrow(
            ApiNames.users,
            query: <String, dynamic>{
              'page': 1,
              'per_page': 10,
              'keyword': 'Nsry',
            },
            method: ServerMethods.GET,
            systemTypeEnum: ActiveSystemEnum.pms,
            model: any(named: 'model'),
          ),
        ).called(1);
      });
    });

    group('getSeniorityLevels', () {
      test('calls seniority-levels endpoint and returns SeniorityLevelsModel',
          () async {
        when(
          () => mockNetwork.requestOrThrow(
            ApiNames.seniorityLevels,
            method: ServerMethods.GET,
            systemTypeEnum: ActiveSystemEnum.pms,
            model: any(named: 'model'),
          ),
        ).thenAnswer((_) async {
          return SeniorityLevelsModel.fromJson({
            'data': [
              {'id': 1, 'name': 'Senior-Level', 'sort_order': 1},
              {'id': 2, 'name': 'Mid-Level', 'sort_order': 2},
            ],
            'status': 200,
          });
        });

        final result = await repo.getSeniorityLevels();

        expect(result, isA<SeniorityLevelsModel>());
        expect(result.succeeded, isTrue);
        expect(result.data, isNotNull);
        expect(result.data!.length, 2);

        verify(
          () => mockNetwork.requestOrThrow(
            ApiNames.seniorityLevels,
            method: ServerMethods.GET,
            systemTypeEnum: ActiveSystemEnum.pms,
            model: any(named: 'model'),
          ),
        ).called(1);
      });
    });

    group('getTeams', () {
      test('calls all-teams endpoint and returns TeamsModel', () async {
        when(
          () => mockNetwork.requestOrThrow(
            ApiNames.allTeams,
            method: ServerMethods.GET,
            systemTypeEnum: ActiveSystemEnum.pms,
            model: any(named: 'model'),
          ),
        ).thenAnswer((_) async {
          return TeamsModel.fromJson({
            'data': [
              {'id': 1, 'name': 'Development', 'color': null},
              {'id': 3, 'name': 'Mobile', 'color': '20, 35, 49'},
            ],
            'status': 200,
            'message': 'Fetched Successfully',
          });
        });

        final result = await repo.getTeams();

        expect(result, isA<TeamsModel>());
        expect(result.succeeded, isTrue);
        expect(result.data, isNotNull);
        expect(result.data!.length, 2);
        expect(result.data!.first.name, 'Development');

        verify(
          () => mockNetwork.requestOrThrow(
            ApiNames.allTeams,
            method: ServerMethods.GET,
            systemTypeEnum: ActiveSystemEnum.pms,
            model: any(named: 'model'),
          ),
        ).called(1);
      });
    });

    group('getFilterOptions', () {
      void mockBothFilterApis() {
        when(
          () => mockNetwork.requestOrThrow(
            ApiNames.seniorityLevels,
            method: ServerMethods.GET,
            systemTypeEnum: ActiveSystemEnum.pms,
            model: any(named: 'model'),
          ),
        ).thenAnswer((_) async {
          return SeniorityLevelsModel.fromJson({
            'data': [
              {'id': 1, 'name': 'Senior-Level', 'sort_order': 1},
              {'id': 18, 'name': 'Junior-Level', 'sort_order': 5},
            ],
            'status': 200,
          });
        });

        when(
          () => mockNetwork.requestOrThrow(
            ApiNames.allTeams,
            method: ServerMethods.GET,
            systemTypeEnum: ActiveSystemEnum.pms,
            model: any(named: 'model'),
          ),
        ).thenAnswer((_) async {
          return TeamsModel.fromJson({
            'data': [
              {'id': 1, 'name': 'Development', 'color': null},
              {'id': 3, 'name': 'Mobile', 'color': '20, 35, 49'},
            ],
            'status': 200,
            'message': 'Fetched Successfully',
          });
        });
      }

      test('returns EmployeesFiltersModel with both teams and seniority levels',
          () async {
        mockBothFilterApis();

        final result = await repo.getFilterOptions();

        expect(result, isNotNull);
        expect(result, isA<EmployeesFiltersModel>());
        expect(result.succeeded, isTrue);
        expect(result.data, isNotNull);

        expect(result.data?.seniorityLevels, isNotNull);
        expect(result.data!.seniorityLevels!.length, 2);
        expect(result.data!.seniorityLevels!.first.id, 1);
        expect(result.data!.seniorityLevels!.first.name, 'Senior-Level');

        expect(result.data?.teams, isNotNull);
        expect(result.data!.teams!.length, 2);
        expect(result.data!.teams!.first.id, 1);
        expect(result.data!.teams!.first.name, 'Development');
      });
    });
  });
}
