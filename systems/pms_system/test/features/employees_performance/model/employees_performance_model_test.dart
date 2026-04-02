import 'package:flutter_test/flutter_test.dart';
import 'package:pms_system/features/employees_performance/model/employees_performance_model.dart';

import '../../../helpers/fixture_reader.dart';
import '../../../helpers/json_fixtures.dart';
import '../../../helpers/model_field_asserts.dart';

void main() {
  group('EmployeesPerformanceModel', () {
    final fixtureJson = readJsonFixture(
        'employees_performance/employees_performance_response.json');

    test('Contract: JSON has "data" as a non-empty List', () {
      expect(fixtureJson.containsKey('data'), isTrue);
      expect(fixtureJson['data'], isA<List>());
      expect((fixtureJson['data'] as List).isNotEmpty, isTrue);
    });

    test('fromJson correctly maps critical fields from fixture', () {
      final model = EmployeesPerformanceModel.fromJson(fixtureJson);

      final data = model.data;
      expect(data, isNotNull, reason: 'Expected "data" to be non-null');
      expect(data, isNotEmpty, reason: 'Expected non-empty employee list');
    });

    test('fromJson parses first employee', () {
      final model = EmployeesPerformanceModel.fromJson(fixtureJson);
      final first = model.data?.first;

      expectModelFields([
        (key: 'data[0].id', actual: first?.id, expected: 39),
        (
          key: 'data[0].name',
          actual: first?.name,
          expected: 'Lbna Alsaml'
        ),
        (key: 'data[0].score', actual: first?.score, expected: 4.145),
        (key: 'data[0].percentage', actual: first?.percentage, expected: 82.9),
        (
          key: 'data[0].job_title',
          actual: first?.jobTitle,
          expected: 'Full stack developer'
        ),
      ]);
    });

    test('fromJson leaves data null when "data" key is missing', () {
      final json = <String, dynamic>{};
      final model = EmployeesPerformanceModel.fromJson(json);
      expect(model.data, isNull);
    });

    test('toJson returns Map with data list', () {
      final model = EmployeesPerformanceModel.fromJson(fixtureJson);
      final json = model.toJson();

      expect(json, isA<Map<String, dynamic>>());
      expect(json['data'], isA<List>());
      expect((json['data'] as List).length, equals(4));
    });

    test('fromJson round-trip via Mapper interface', () {
      final model = EmployeesPerformanceModel();
      final parsed = model.fromJson(fixtureJson);

      expect(parsed, isA<EmployeesPerformanceModel>());
      expect((parsed as EmployeesPerformanceModel).data, isNotNull);
      expect(parsed.data!.length, equals(4));
    });
  });

  group('PerformanceEmployeeModel', () {
    test('fromJson/toJson round-trip for API-shaped payload', () {
      final json = {
        'id': 1,
        'name': 'Test',
        'email': 't@test.com',
        'job_title': 'Dev',
        'score': 4.1,
        'percentage': 82.5,
        'review_cycle_id': 1,
        'review_cycle_name': 'Cycle A',
        'closed_date': null,
      };
      final model = PerformanceEmployeeModel.fromJson(json);
      final output = model.toJson();

      expectModelFields([
        (key: 'id', actual: output['id'], expected: 1),
        (key: 'name', actual: output['name'], expected: 'Test'),
        (key: 'email', actual: output['email'], expected: 't@test.com'),
        (key: 'job_title', actual: output['job_title'], expected: 'Dev'),
        (key: 'score', actual: output['score'], expected: 4.1),
        (key: 'percentage', actual: output['percentage'], expected: 82.5),
        (key: 'review_cycle_id', actual: output['review_cycle_id'], expected: 1),
        (
          key: 'review_cycle_name',
          actual: output['review_cycle_name'],
          expected: 'Cycle A'
        ),
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
