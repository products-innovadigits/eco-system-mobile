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
      'Contract: fromJson accepts Laravel wrapper with "data" list and "meta"',
      () {
        expect(fixtureJson.containsKey('data'), isTrue);
        expect(fixtureJson['data'], isA<List>());
        expect(fixtureJson.containsKey('meta'), isTrue);
        expect(fixtureJson['status'], 200);
      },
    );

    test('fromJson correctly maps critical fields from Laravel fixture', () {
      final model = EmployeesLearningModel.fromJson(fixtureJson);

      expect(model.succeeded, isTrue,
          reason: 'Expected succeeded derived from status 200');

      final data = model.data;
      expect(data, isNotNull, reason: 'Expected "data" to be non-null');

      final items = data?.items;
      expect(items, isNotNull, reason: 'Expected "items" list');
      expect(items, isNotEmpty, reason: 'Expected non-empty items');

      final firstItem = items?.first;
      expectModelFields([
        (key: 'data[].id', actual: firstItem?.id, expected: 74),
        (
          key: 'data[].name',
          actual: firstItem?.name,
          expected: 'Nsry Alahmry'
        ),
        (
          key: 'data[].jobTitle',
          actual: firstItem?.jobTitle,
          expected: 'employee'
        ),
        (
          key: 'data[].team',
          actual: firstItem?.team,
          expected: 'Product'
        ),
        (
          key: 'data[].seniority',
          actual: firstItem?.seniority,
          expected: 'Mid-Level'
        ),
      ]);
    });

    group('Negative Contract Tests', () {
      test('fails legacy contract if "data" key is missing', () {
        final invalidJson = Map<String, dynamic>.from(fixtureJson)
          ..remove('data');
        expect(
          () => expectWrapperContract(invalidJson, dataShape: DataShape.map),
          throwsA(isA<TestFailure>()),
        );
      });

      test('fails legacy contract if "succeeded" key is missing for map data',
          () {
        final invalidJson = Map<String, dynamic>.from(fixtureJson)
          ..remove('status');
        expect(invalidJson.containsKey('succeeded'), isFalse);
        final model = EmployeesLearningModel.fromJson(invalidJson);
        expect(model.succeeded, isFalse);
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

    test('fromJson supports legacy succeeded + data.items shape', () {
      final legacy = {
        'succeeded': true,
        'data': {
          'items': [
            {
              'id': 1,
              'name': 'Legacy User',
              'jobTitle': 'Dev',
              'email': 'l@test.com',
              'phone': '+1',
              'seniority': 'Senior',
              'team': 'Engineering',
              'initials': 'LU',
            }
          ],
          'currentPage': 1,
          'pageSize': 10,
          'totalPages': 1,
          'isLastPage': true,
          'totalCount': 1,
        },
      };
      final m = EmployeesLearningModel.fromJson(legacy);
      expect(m.data?.items?.first.name, 'Legacy User');
      expect(m.data?.currentPage, 1);
    });
  });

  group('EmployeesDataModel', () {
    test('fromJson parses minimal valid JSON without throwing', () {
      expect(
        () => EmployeesDataModel.fromJson(JsonFixtures.minimalMap()),
        returnsNormally,
      );
    });

    test('fromJson parses pagination fields from legacy map', () {
      final fixtureJson =
          readJsonFixture('employees_learning/employees_learning_response.json');
      final model = EmployeesLearningModel.fromJson(fixtureJson);
      final data = model.data!;

      expectModelFields([
        (key: 'currentPage', actual: data.currentPage, expected: 1),
        (key: 'pageSize', actual: data.pageSize, expected: 9),
        (key: 'totalPages', actual: data.totalPages, expected: 8),
        (key: 'isLastPage', actual: data.isLastPage, expected: false),
        (key: 'totalCount', actual: data.totalCount, expected: 69),
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
