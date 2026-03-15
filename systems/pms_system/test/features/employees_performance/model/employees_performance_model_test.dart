import 'package:flutter_test/flutter_test.dart';
import 'package:pms_system/features/employees_performance/model/employees_performance_model.dart';

import '../../../helpers/contract_asserts.dart';
import '../../../helpers/fixture_reader.dart';
import '../../../helpers/json_fixtures.dart';
import '../../../helpers/model_field_asserts.dart';

void main() {
  group('EmployeesPerformanceModel', () {
    final fixtureJson = readJsonFixture(
        'employees_performance/employees_performance_response.json');

    test(
      'Contract: fromJson accepts wrapper with "succeeded" and "data" keys (Map)',
      () {
        expectWrapperContract(fixtureJson, dataShape: DataShape.map);
      },
    );

    test('fromJson correctly maps critical fields from fixture', () {
      expectWrapperContract(fixtureJson, dataShape: DataShape.map);

      final model = EmployeesPerformanceModel.fromJson(fixtureJson);

      expect(model.succeeded, isTrue,
          reason: 'Expected "succeeded" to be true');

      final data = model.data;
      expect(data, isNotNull,
          reason: 'Expected "data" to be non-null');

      expect(data?.topMonthly, isNotNull,
          reason: 'Expected topMonthly list');
      expect(data?.topMonthly, isNotEmpty,
          reason: 'Expected non-empty topMonthly');
      expect(data?.topYearly, isNotNull,
          reason: 'Expected topYearly list');
      expect(data?.topYearly, isNotEmpty,
          reason: 'Expected non-empty topYearly');
      expect(data?.top10, isNotNull, reason: 'Expected top10 list');
      expect(data?.top10, isNotEmpty, reason: 'Expected non-empty top10');
    });

    test('fromJson parses first topMonthly employee', () {
      final model = EmployeesPerformanceModel.fromJson(fixtureJson);
      final first = model.data?.topMonthly?.first;

      expectModelFields([
        (key: 'topMonthly[0].id', actual: first?.id, expected: 1),
        (
          key: 'topMonthly[0].name',
          actual: first?.name,
          expected: 'Mohamed Ismail'
        ),
        (key: 'topMonthly[0].score', actual: first?.score, expected: 99.0),
        (key: 'topMonthly[0].rank', actual: first?.rank, expected: 1),
      ]);
    });

    group('Negative Contract Tests', () {
      test('fails if "succeeded" key is missing', () {
        final invalidJson = Map<String, dynamic>.from(fixtureJson)
          ..remove('succeeded');
        expect(
          () => expectWrapperContract(invalidJson, dataShape: DataShape.map),
          throwsA(isA<TestFailure>()),
        );
      });

      test('fails if "data" key is missing', () {
        final invalidJson = Map<String, dynamic>.from(fixtureJson)
          ..remove('data');
        expect(
          () => expectWrapperContract(invalidJson, dataShape: DataShape.map),
          throwsA(isA<TestFailure>()),
        );
      });
    });

    test('toJson returns Map with essential fields', () {
      final model = EmployeesPerformanceModel.fromJson(fixtureJson);
      final json = model.toJson();

      expect(json, isA<Map<String, dynamic>>());
      expect(json['succeeded'], isTrue);
      expect(json['data'], isNotNull);
    });

    test('fromJson round-trip via Mapper interface', () {
      final model = EmployeesPerformanceModel();
      final parsed = model.fromJson(fixtureJson);

      expect(parsed, isA<EmployeesPerformanceModel>());
      expect((parsed as EmployeesPerformanceModel).succeeded, isTrue);
    });
  });

  group('EmployeesPerformanceDataModel', () {
    test('fromJson parses minimal valid JSON without throwing', () {
      expect(
        () => EmployeesPerformanceDataModel.fromJson(JsonFixtures.minimalMap()),
        returnsNormally,
      );
    });
  });

  group('PerformanceEmployeeModel', () {
    test('fromJson/toJson round-trip', () {
      final json = {
        'id': 1,
        'name': 'Test',
        'jobTitle': 'Dev',
        'imageUrl': null,
        'score': 95.5,
        'rank': 1,
        'reportUrl': '#',
      };
      final model = PerformanceEmployeeModel.fromJson(json);
      final output = model.toJson();

      expectModelFields([
        (key: 'id', actual: output['id'], expected: 1),
        (key: 'name', actual: output['name'], expected: 'Test'),
        (key: 'score', actual: output['score'], expected: 95.5),
        (key: 'rank', actual: output['rank'], expected: 1),
        (key: 'reportUrl', actual: output['reportUrl'], expected: '#'),
      ]);
    });

    test('fromJson parses minimal valid JSON without throwing', () {
      expect(
        () => PerformanceEmployeeModel.fromJson(JsonFixtures.minimalMap()),
        returnsNormally,
      );
    });
  });
}
