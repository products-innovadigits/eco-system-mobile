import 'package:flutter_test/flutter_test.dart';
import 'package:project_management/features/workflow_process_details/model/process_details_model.dart';

import '../../../helpers/contract_asserts.dart';
import '../../../helpers/fixture_reader.dart';
import '../../../helpers/json_fixtures.dart';

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

    test('fromJson correctly maps critical fields from fixture', () {
      expectWrapperContract(fixtureJson, dataShape: DataShape.list);
      final model = GroupStepsModel.fromJson(fixtureJson);

      expect(model.succeeded, isTrue);
      expect(model.data, isNotEmpty);
      expect(model.data!.first.groupName, 'Phase 1: Preparation');
      expect(model.data!.first.steps, isNotEmpty);
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
