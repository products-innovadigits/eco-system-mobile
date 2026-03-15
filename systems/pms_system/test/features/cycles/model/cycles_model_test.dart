import 'package:flutter_test/flutter_test.dart';
import 'package:pms_system/features/cycles/model/cycles_model.dart';

import '../../../helpers/contract_asserts.dart';
import '../../../helpers/fixture_reader.dart';
import '../../../helpers/json_fixtures.dart';
import '../../../helpers/model_field_asserts.dart';

void main() {
  group('CyclesModel', () {
    final fixtureJson = readJsonFixture('cycles/cycles_response.json');

    test(
      'Contract: fromJson accepts wrapper with "succeeded" and "data" keys (Map)',
      () {
        expectWrapperContract(fixtureJson, dataShape: DataShape.map);
      },
    );

    test('fromJson correctly maps critical fields from fixture', () {
      expect(
        fixtureJson,
        isNotNull,
        reason: 'Test setup: Cycles fixture JSON is null',
      );
      expectWrapperContract(fixtureJson, dataShape: DataShape.map);

      final model = CyclesModel.fromJson(fixtureJson);

      expect(
        model.succeeded,
        isTrue,
        reason:
            'Expected "succeeded" to be true from fixture. Fix mapping or fixture.',
      );

      final data = model.data;
      expect(
        data,
        isNotNull,
        reason:
            'Expected "data" model to be non-null after parsing valid fixture',
      );

      final items = data?.items;
      expect(
        items,
        isNotNull,
        reason: 'Expected "items" list to be present in data',
      );
      expect(
        items,
        isNotEmpty,
        reason: 'Expected "items" list to contain cycles from fixture',
      );

      final firstItem = items?.first;
      expectModelFields([
        (key: 'data.items[].id', actual: firstItem?.id, expected: 1),
        (
          key: 'data.items[].title',
          actual: firstItem?.title,
          expected: 'Bi-Annual Review'
        ),
        (
          key: 'data.items[].status',
          actual: firstItem?.status,
          expected: 'Active'
        ),
      ]);
    });

    test('fromJson parses nested assignees and reviews', () {
      final model = CyclesModel.fromJson(fixtureJson);
      final firstItem = model.data?.items?.first;

      expect(firstItem?.assignees, isNotNull,
          reason: 'Expected assignees list on first cycle item');
      expect(firstItem?.assignees, isNotEmpty,
          reason: 'Expected non-empty assignees');
      expectModelFields([
        (
          key: 'assignees[0].name',
          actual: firstItem?.assignees?.first.name,
          expected: 'Ahmed Ali'
        ),
      ]);

      expect(firstItem?.reviews, isNotNull,
          reason: 'Expected reviews list on first cycle item');
      expect(firstItem?.reviews, isNotEmpty,
          reason: 'Expected non-empty reviews');
      expectModelFields([
        (
          key: 'reviews[0].name',
          actual: firstItem?.reviews?.first.name,
          expected: 'Manager Review'
        ),
        (
          key: 'reviews[0].percentage',
          actual: firstItem?.reviews?.first.percentage,
          expected: 50.0
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
          reason:
              'Contract helper should throw TestFailure when "succeeded" key is missing',
        );
      });

      test('fails if "data" key is missing', () {
        final invalidJson = Map<String, dynamic>.from(fixtureJson)
          ..remove('data');
        expect(
          () => expectWrapperContract(invalidJson, dataShape: DataShape.map),
          throwsA(isA<TestFailure>()),
          reason:
              'Contract helper should throw TestFailure when "data" key is missing',
        );
      });

      test('fails if "data" is not a Map', () {
        final invalidJson = Map<String, dynamic>.from(fixtureJson)
          ..['data'] = [];
        expect(
          () => expectWrapperContract(invalidJson, dataShape: DataShape.map),
          throwsA(isA<TestFailure>()),
          reason:
              'Contract helper should throw TestFailure when "data" is not a Map',
        );
      });
    });

    test('toJson returns Map with essential fields', () {
      final model = CyclesModel.fromJson(fixtureJson);
      final json = model.toJson();

      expect(
        json,
        isA<Map<String, dynamic>>(),
        reason: 'toJson must return a Map',
      );
      expect(
        json['succeeded'],
        isTrue,
        reason: 'toJson missing or incorrect "succeeded" value',
      );
      expect(
        json['data'],
        isNotNull,
        reason: 'toJson missing or null "data" value',
      );
    });

    test('fromJson round-trip via Mapper interface', () {
      final model = CyclesModel();
      final parsed = model.fromJson(fixtureJson);

      expect(parsed, isA<CyclesModel>(),
          reason: 'Mapper.fromJson should return CyclesModel');
      expect((parsed as CyclesModel).succeeded, isTrue);
    });
  });

  group('CyclesDataModel', () {
    test('fromJson parses minimal valid JSON without throwing', () {
      final json = JsonFixtures.minimalMap();
      expect(
        () => CyclesDataModel.fromJson(json),
        returnsNormally,
        reason: 'CyclesDataModel.fromJson failed on minimal map',
      );
    });

    test('fromJson parses pagination fields', () {
      final fixtureJson = readJsonFixture('cycles/cycles_response.json');
      final dataJson = fixtureJson['data'] as Map<String, dynamic>;
      final data = CyclesDataModel.fromJson(dataJson);

      expectModelFields([
        (key: 'currentPage', actual: data.currentPage, expected: 1),
        (key: 'pageSize', actual: data.pageSize, expected: 10),
        (key: 'totalPages', actual: data.totalPages, expected: 1),
        (key: 'isLastPage', actual: data.isLastPage, expected: true),
        (key: 'totalCount', actual: data.totalCount, expected: 1),
      ]);
    });
  });

  group('CycleItemModel', () {
    test('fromJson parses minimal valid JSON without throwing', () {
      expect(
        () => CycleItemModel.fromJson(JsonFixtures.minimalMap()),
        returnsNormally,
      );
    });
  });

  group('CycleAssigneeModel', () {
    test('fromJson/toJson round-trip', () {
      final json = {'id': 1, 'name': 'Ahmed', 'imageUrl': 'http://img.png'};
      final model = CycleAssigneeModel.fromJson(json);
      final output = model.toJson();

      expectModelFields([
        (key: 'id', actual: output['id'], expected: 1),
        (key: 'name', actual: output['name'], expected: 'Ahmed'),
        (key: 'imageUrl', actual: output['imageUrl'], expected: 'http://img.png'),
      ]);
    });
  });

  group('CycleReviewModel', () {
    test('fromJson/toJson round-trip', () {
      final json = {'name': 'Manager Review', 'percentage': 75.0};
      final model = CycleReviewModel.fromJson(json);
      final output = model.toJson();

      expectModelFields([
        (key: 'name', actual: output['name'], expected: 'Manager Review'),
        (key: 'percentage', actual: output['percentage'], expected: 75.0),
      ]);
    });
  });
}
