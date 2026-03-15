import 'package:flutter_test/flutter_test.dart';
import 'package:pms_system/features/employees_learning/model/employees_filters_model.dart';

import '../../../helpers/contract_asserts.dart';
import '../../../helpers/fixture_reader.dart';
import '../../../helpers/json_fixtures.dart';
import '../../../helpers/model_field_asserts.dart';

void main() {
  group('EmployeesFiltersModel', () {
    final fixtureJson =
        readJsonFixture('employees_learning/employees_filters_response.json');

    test(
      'Contract: fromJson accepts wrapper with "succeeded" and "data" keys (Map)',
      () {
        expectWrapperContract(fixtureJson, dataShape: DataShape.map);
      },
    );

    test('fromJson correctly maps filter options', () {
      final model = EmployeesFiltersModel.fromJson(fixtureJson);

      expect(model.succeeded, isTrue);

      final data = model.data;
      expect(data, isNotNull);
      expect(data?.teams, isNotNull);
      expect(data?.teams, isNotEmpty,
          reason: 'Expected teams list to be non-empty');
      expect(data?.seniorityLevels, isNotNull);
      expect(data?.seniorityLevels, isNotEmpty,
          reason: 'Expected seniorityLevels list to be non-empty');

      expectModelFields([
        (
          key: 'teams[0].id',
          actual: data?.teams?.first.id,
          expected: 1
        ),
        (
          key: 'teams[0].name',
          actual: data?.teams?.first.name,
          expected: 'Designing'
        ),
        (
          key: 'seniorityLevels[0].id',
          actual: data?.seniorityLevels?.first.id,
          expected: 1
        ),
        (
          key: 'seniorityLevels[0].name',
          actual: data?.seniorityLevels?.first.name,
          expected: 'Junior'
        ),
      ]);
    });

    test('toJson returns Map with essential fields', () {
      final model = EmployeesFiltersModel.fromJson(fixtureJson);
      final json = model.toJson();

      expect(json, isA<Map<String, dynamic>>());
      expect(json['succeeded'], isTrue);
      expect(json['data'], isNotNull);
    });

    test('fromJson round-trip via Mapper interface', () {
      final model = EmployeesFiltersModel();
      final parsed = model.fromJson(fixtureJson);

      expect(parsed, isA<EmployeesFiltersModel>());
      expect((parsed as EmployeesFiltersModel).succeeded, isTrue);
    });
  });

  group('EmployeesFiltersData', () {
    test('fromJson parses minimal valid JSON without throwing', () {
      expect(
        () => EmployeesFiltersData.fromJson(JsonFixtures.minimalMap()),
        returnsNormally,
      );
    });
  });

  group('FilterOptionItem', () {
    test('fromJson/toJson round-trip', () {
      final json = {'id': 1, 'name': 'Engineering'};
      final model = FilterOptionItem.fromJson(json);
      final output = model.toJson();

      expectModelFields([
        (key: 'id', actual: output['id'], expected: 1),
        (key: 'name', actual: output['name'], expected: 'Engineering'),
      ]);
    });
  });
}
