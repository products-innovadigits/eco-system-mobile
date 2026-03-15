import 'package:flutter_test/flutter_test.dart';
import 'package:pms_system/core/utility/pms_exports.dart';
import 'package:pms_system/features/employees_learning/data/employees_learning_repo_impl.dart';
import 'package:pms_system/features/employees_learning/model/employees_filters_model.dart';
import 'package:pms_system/features/employees_learning/model/employees_learning_model.dart';

import '../../../core/mocks/fallbacks.dart';
import '../../../core/mocks/mock_network.dart';

void main() {
  setUpAll(() {
    initMocktailFallbacks();
  });

  late MockNetwork mockNetwork;
  late EmployeesLearningRepoImpl repo;

  setUp(() {
    mockNetwork = MockNetwork();
    repo = EmployeesLearningRepoImpl(network: mockNetwork);
  });

  group('EmployeesLearningRepoImpl', () {
    group('getEmployees', () {
      test('returns EmployeesLearningModel with succeeded=true', () async {
        final searchEngine = SearchEngine();

        final result = await repo.getEmployees(searchEngine);

        expect(result, isNotNull,
            reason: 'repo.getEmployees returned null');
        expect(result, isA<EmployeesLearningModel>(),
            reason: 'Expected EmployeesLearningModel');
        expect(result.succeeded, isTrue,
            reason: 'Expected succeeded to be true');
      });

      test('returns data with items and pagination', () async {
        final searchEngine = SearchEngine();

        final result = await repo.getEmployees(searchEngine);

        expect(result.data, isNotNull);
        expect(result.data?.items, isNotNull);
        expect(result.data!.items!, isNotEmpty,
            reason: 'Expected non-empty employees');
        expect(result.data?.currentPage, isNotNull);
        expect(result.data?.totalPages, isNotNull);
      });

      test('filters by search keyword', () async {
        final searchEngine = SearchEngine(
          query: <String, dynamic>{'searchKeyword': 'Hassan'},
        );

        final result = await repo.getEmployees(searchEngine);

        expect(result.data?.items, isNotNull);
        for (final item in result.data!.items!) {
          expect(
            item.name!.toLowerCase().contains('hassan'),
            isTrue,
            reason: 'Item "${item.name}" should contain "hassan"',
          );
        }
      });

      test('returns empty items for non-matching search', () async {
        final searchEngine = SearchEngine(
          query: <String, dynamic>{
            'searchKeyword': 'zzz_nonexistent_zzz',
          },
        );

        final result = await repo.getEmployees(searchEngine);

        expect(result.data?.items, isNotNull);
        expect(result.data!.items!, isEmpty);
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
