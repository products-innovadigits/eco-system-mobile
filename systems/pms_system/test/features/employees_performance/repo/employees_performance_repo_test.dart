import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pms_system/core/utility/pms_exports.dart';
import 'package:pms_system/features/employees_performance/data/employees_performance_repo_impl.dart';
import 'package:pms_system/features/employees_performance/model/employees_performance_model.dart';

import '../../../core/mocks/fallbacks.dart';
import '../../../core/mocks/mock_network.dart';
import '../../../helpers/fixture_reader.dart';

void main() {
  setUpAll(() {
    initMocktailFallbacks();
  });

  late MockNetwork mockNetwork;
  late EmployeesPerformanceRepoImpl repo;

  setUp(() {
    mockNetwork = MockNetwork();
    repo = EmployeesPerformanceRepoImpl(network: mockNetwork);
  });

  group('EmployeesPerformanceRepoImpl', () {
    group('getPerformanceData', () {
      test('calls network and returns EmployeesPerformanceModel with data list',
          () async {
        final fixtureJson = readJsonFixture(
          'employees_performance/employees_performance_response.json',
        );
        when(
          () => mockNetwork.requestOrThrow(
            any(),
            method: any(named: 'method'),
            query: any(named: 'query'),
            systemTypeEnum: any(named: 'systemTypeEnum'),
            model: any(named: 'model'),
          ),
        ).thenAnswer(
          (_) async => EmployeesPerformanceModel.fromJson(fixtureJson),
        );

        final result = await repo.getPerformanceData();

        expect(result, isA<EmployeesPerformanceModel>());
        expect(result.data, isNotNull);
        expect(result.data!.length, equals(4));
        expect(result.data!.first.name, equals('Lbna Alsaml'));

        verify(
          () => mockNetwork.requestOrThrow(
            ApiNames.employeesTopTen,
            method: ServerMethods.GET,
            query: any(named: 'query'),
            systemTypeEnum: ActiveSystemEnum.pms,
            model: any(named: 'model'),
          ),
        ).called(1);
      });

      test('passes type query when provided', () async {
        final fixtureJson = readJsonFixture(
          'employees_performance/employees_performance_response.json',
        );
        when(
          () => mockNetwork.requestOrThrow(
            any(),
            method: any(named: 'method'),
            query: any(named: 'query'),
            systemTypeEnum: any(named: 'systemTypeEnum'),
            model: any(named: 'model'),
          ),
        ).thenAnswer(
          (_) async => EmployeesPerformanceModel.fromJson(fixtureJson),
        );

        await repo.getPerformanceData(type: 'yearly');

        final captured = verify(
          () => mockNetwork.requestOrThrow(
            ApiNames.employeesTopTen,
            method: ServerMethods.GET,
            query: captureAny(named: 'query'),
            systemTypeEnum: ActiveSystemEnum.pms,
            model: any(named: 'model'),
          ),
        ).captured;

        final query = captured.first as Map<String, dynamic>;
        expect(query['type'], equals('yearly'));
      });

      test('employees have required fields from fixture', () async {
        final fixtureJson = readJsonFixture(
          'employees_performance/employees_performance_response.json',
        );
        when(
          () => mockNetwork.requestOrThrow(
            any(),
            method: any(named: 'method'),
            query: any(named: 'query'),
            systemTypeEnum: any(named: 'systemTypeEnum'),
            model: any(named: 'model'),
          ),
        ).thenAnswer(
          (_) async => EmployeesPerformanceModel.fromJson(fixtureJson),
        );

        final result = await repo.getPerformanceData();
        final employees = result.data!;

        for (final employee in employees) {
          expect(employee.id, isNotNull,
              reason: 'Each employee should have an id');
          expect(employee.name, isNotNull,
              reason: 'Each employee should have a name');
          expect(employee.score, isNotNull,
              reason: 'Each employee should have a score');
          expect(employee.percentage, isNotNull,
              reason: 'Each employee should have a percentage');
        }
      });
    });
  });
}
