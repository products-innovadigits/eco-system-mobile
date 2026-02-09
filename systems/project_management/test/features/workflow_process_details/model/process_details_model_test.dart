import 'package:flutter_test/flutter_test.dart';
import 'package:project_management/features/workflow_process_details/model/process_details_model.dart';

import '../../../helpers/contract_asserts.dart';
import '../../../helpers/fixture_reader.dart';
import '../../../helpers/json_fixtures.dart';
import '../../../helpers/model_field_asserts.dart';

void main() {
  group('GroupStepsModel', () {
    final fixtureJson = readJsonFixture(
      'workflow/process_details_response.json',
    );

    test(
      'Contract: fromJson accepts wrapper with "succeeded" and "data" keys (List)',
      () {
        expectWrapperContract(fixtureJson, dataShape: DataShape.list);
      },
    );

    test('fromJson correctly maps critical fields from fixture (fails if model key changes)', () {
      expectWrapperContract(fixtureJson, dataShape: DataShape.list);
      final model = GroupStepsModel.fromJson(fixtureJson);

      expect(model.succeeded, isTrue, reason: 'Key "succeeded"');
      expect(model.data, isNotEmpty, reason: 'Key "data"');
      final first = model.data!.first;
      expect(first.steps, isNotEmpty, reason: 'Key "data[].steps"');
      expectModelFields([
        (key: 'data[].groupId', actual: first.groupId, expected: 1),
        (key: 'data[].groupName', actual: first.groupName, expected: 'Phase 1: Preparation'),
        (key: 'data[].progress', actual: first.progress, expected: 50),
        (key: 'data[].steps[].id', actual: first.steps!.first.id, expected: 10),
        (key: 'data[].steps[].stepName', actual: first.steps!.first.stepName, expected: 'Gather Requirements'),
        (key: 'data[].steps[].status', actual: first.steps!.first.status, expected: 1),
      ]);
    });

    group('Negative Contract Tests', () {
      test('fails if "succeeded" key is missing', () {
        final invalidJson = Map<String, dynamic>.from(fixtureJson)
          ..remove('succeeded');
        expect(
          () => expectWrapperContract(invalidJson, dataShape: DataShape.list),
          throwsA(isA<TestFailure>()),
        );
      });

      test('fails if "data" key is missing', () {
        final invalidJson = Map<String, dynamic>.from(fixtureJson)
          ..remove('data');
        expect(
          () => expectWrapperContract(invalidJson, dataShape: DataShape.list),
          throwsA(isA<TestFailure>()),
        );
      });

      test('fails if "data" is not a List', () {
        final invalidJson = Map<String, dynamic>.from(fixtureJson)
          ..['data'] = {};
        expect(
          () => expectWrapperContract(invalidJson, dataShape: DataShape.list),
          throwsA(isA<TestFailure>()),
        );
      });
    });

    test('toJson returns Map with essential fields', () {
      final model = GroupStepsModel.fromJson(fixtureJson);
      final json = model.toJson();

      expect(json['succeeded'], isTrue);
      expect(json['data'], isA<List>());
    });
  });

  group('GroupStepsData', () {
    test('fromJson parses minimal valid JSON without throwing', () {
      final json = JsonFixtures.minimalMap();
      expect(() => GroupStepsData().fromJson(json), returnsNormally);
    });
    // ...
  });
}
