import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pms_system/core/utility/pms_exports.dart';
import 'package:pms_system/features/employees_learning/data/employees_learning_repo_impl.dart';
import 'package:pms_system/features/employees_learning/model/employees_filters_model.dart';
import 'package:pms_system/features/employees_learning/model/employees_learning_model.dart';

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

    group('getFilterOptions', () {
      test('returns EmployeesFiltersModel with succeeded=true', () async {
        final result = await repo.getFilterOptions();

        expect(result, isNotNull,
            reason: 'repo.getFilterOptions returned null');
        expect(result, isA<EmployeesFiltersModel>(),
            reason: 'Expected EmployeesFiltersModel');
        expect(result.succeeded, isTrue,
            reason: 'Expected succeeded to be true');
      });

      test('returns teams and seniority levels', () async {
        final result = await repo.getFilterOptions();

        expect(result.data, isNotNull);
        expect(result.data?.teams, isNotNull);
        expect(result.data!.teams!, isNotEmpty,
            reason: 'Expected non-empty teams');
        expect(result.data?.seniorityLevels, isNotNull);
        expect(result.data!.seniorityLevels!, isNotEmpty,
            reason: 'Expected non-empty seniority levels');
      });
    });
  });
}
