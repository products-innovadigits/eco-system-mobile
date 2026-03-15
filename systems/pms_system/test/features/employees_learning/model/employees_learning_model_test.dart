import 'package:flutter_test/flutter_test.dart';
import 'package:pms_system/features/employees_learning/model/employees_learning_model.dart';

import '../../../helpers/contract_asserts.dart';
import '../../../helpers/fixture_reader.dart';
import '../../../helpers/json_fixtures.dart';
import '../../../helpers/model_field_asserts.dart';

void main() {
  group('EmployeesLearningModel', () {
    final fixtureJson =
        readJsonFixture('employees_learning/employees_learning_response.json');

    test(
      'Contract: fromJson accepts wrapper with "succeeded" and "data" keys (Map)',
      () {
        expectWrapperContract(fixtureJson, dataShape: DataShape.map);
      },
    );

    test('fromJson correctly maps critical fields from fixture', () {
      expectWrapperContract(fixtureJson, dataShape: DataShape.map);

      final model = EmployeesLearningModel.fromJson(fixtureJson);

      expect(model.succeeded, isTrue,
          reason: 'Expected "succeeded" to be true from fixture');

      final data = model.data;
      expect(data, isNotNull,
          reason: 'Expected "data" to be non-null');

      final items = data?.items;
      expect(items, isNotNull, reason: 'Expected "items" list');
      expect(items, isNotEmpty, reason: 'Expected non-empty items');

      final firstItem = items?.first;
      expectModelFields([
        (key: 'data.items[].id', actual: firstItem?.id, expected: 1),
        (
          key: 'data.items[].name',
          actual: firstItem?.name,
          expected: 'Hassan Aziz'
        ),
        (
          key: 'data.items[].jobTitle',
          actual: firstItem?.jobTitle,
          expected: 'Product Designer'
        ),
        (
          key: 'data.items[].team',
          actual: firstItem?.team,
          expected: 'Designing'
        ),
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
      final model = EmployeesLearningModel.fromJson(fixtureJson);
      final json = model.toJson();

      expect(json, isA<Map<String, dynamic>>());
      expect(json['succeeded'], isTrue);
      expect(json['data'], isNotNull);
    });

    test('fromJson round-trip via Mapper interface', () {
      final model = EmployeesLearningModel();
      final parsed = model.fromJson(fixtureJson);

      expect(parsed, isA<EmployeesLearningModel>());
      expect((parsed as EmployeesLearningModel).succeeded, isTrue);
    });
  });

  group('EmployeesDataModel', () {
    test('fromJson parses minimal valid JSON without throwing', () {
      expect(
        () => EmployeesDataModel.fromJson(JsonFixtures.minimalMap()),
        returnsNormally,
      );
    });

    test('fromJson parses pagination fields', () {
      final fixtureJson =
          readJsonFixture('employees_learning/employees_learning_response.json');
      final dataJson = fixtureJson['data'] as Map<String, dynamic>;
      final data = EmployeesDataModel.fromJson(dataJson);

      expectModelFields([
        (key: 'currentPage', actual: data.currentPage, expected: 1),
        (key: 'pageSize', actual: data.pageSize, expected: 10),
        (key: 'totalPages', actual: data.totalPages, expected: 1),
        (key: 'isLastPage', actual: data.isLastPage, expected: true),
        (key: 'totalCount', actual: data.totalCount, expected: 1),
      ]);
    });
  });

  group('EmployeeItemModel', () {
    test('fromJson parses minimal valid JSON without throwing', () {
      expect(
        () => EmployeeItemModel.fromJson(JsonFixtures.minimalMap()),
        returnsNormally,
      );
    });

    test('fromJson/toJson round-trip preserves data', () {
      final json = {
        'id': 1,
        'name': 'Test',
        'jobTitle': 'Dev',
        'email': 'test@test.com',
        'phone': '+123',
        'seniority': 'Senior',
        'team': 'Engineering',
        'imageUrl': null,
        'initials': 'T',
      };
      final model = EmployeeItemModel.fromJson(json);
      final output = model.toJson();

      expectModelFields([
        (key: 'id', actual: output['id'], expected: 1),
        (key: 'name', actual: output['name'], expected: 'Test'),
        (key: 'team', actual: output['team'], expected: 'Engineering'),
        (key: 'initials', actual: output['initials'], expected: 'T'),
      ]);
    });
  });
}
