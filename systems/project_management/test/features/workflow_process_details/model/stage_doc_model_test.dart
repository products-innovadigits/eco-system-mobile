import 'package:flutter_test/flutter_test.dart';
import 'package:project_management/features/workflow_process_details/model/stage_doc_model.dart';

import '../../../helpers/json_fixtures.dart';

void main() {
  group('StageDocResponseModel', () {
    test('fromJson parses minimal valid JSON without throwing', () {
      final json = JsonFixtures.wrapperResponse(data: {});
      expect(() => StageDocResponseModel().fromJson(json), returnsNormally);
    });

    test('fromJson returns correct type', () {
      final json = JsonFixtures.wrapperResponse(data: {});
      final res = StageDocResponseModel().fromJson(json);
      expect(res, isA<StageDocResponseModel>());
    });

    test('toJson returns Map without throwing', () {
      final model = StageDocResponseModel();
      final json = model.toJson();
      expect(json, isA<Map<String, dynamic>>());
    });

    test('round-trip does not throw', () {
      final json = JsonFixtures.wrapperResponse(data: {});
      final m = StageDocResponseModel().fromJson(json) as StageDocResponseModel;
      expect(() => m.toJson(), returnsNormally);
    });

    test(
      'Contract: fromJson accepts wrapper with "succeeded" and "data" keys',
      () {
        final json = JsonFixtures.wrapperResponse(data: {});
        expect(
          json.containsKey('succeeded'),
          isTrue,
          reason:
              'Contract expects input key "succeeded". Keys: ${json.keys.toList()}',
        );
        expect(
          json.containsKey('data'),
          isTrue,
          reason:
              'Contract expects input key "data". Keys: ${json.keys.toList()}',
        );
        expect(() => StageDocResponseModel().fromJson(json), returnsNormally);
      },
    );
  });

  group('StageDocData', () {
    test('fromJson parses minimal valid JSON without throwing', () {
      final json = JsonFixtures.minimalMap();
      expect(() => StageDocData.fromJson(json), returnsNormally);
    });

    test('fromJson returns correct type', () {
      final json = JsonFixtures.minimalMap();
      final res = StageDocData.fromJson(json);
      expect(res, isA<StageDocData>());
    });

    test('toJson returns Map without throwing', () {
      final model = StageDocData();
      final json = model.toJson();
      expect(json, isA<Map<String, dynamic>>());
    });

    test('round-trip does not throw', () {
      final json = JsonFixtures.minimalMap();
      final m = StageDocData.fromJson(json);
      expect(() => m.toJson(), returnsNormally);
    });
  });

  group('WorkflowStep', () {
    test('fromJson parses minimal valid JSON without throwing', () {
      final json = JsonFixtures.minimalMap();
      expect(() => WorkflowStep().fromJson(json), returnsNormally);
    });

    test('fromJson returns correct type', () {
      final json = JsonFixtures.minimalMap();
      final res = WorkflowStep().fromJson(json);
      expect(res, isA<WorkflowStep>());
    });

    test('toJson returns Map without throwing', () {
      final model = WorkflowStep();
      final json = model.toJson();
      expect(json, isA<Map<String, dynamic>>());
    });

    test('round-trip does not throw', () {
      final json = JsonFixtures.minimalMap();
      final m = WorkflowStep().fromJson(json) as WorkflowStep;
      expect(() => m.toJson(), returnsNormally);
    });
  });
}
