import 'package:flutter_test/flutter_test.dart';
import 'package:project_management/features/workflow_process_details/model/current_step_document_model.dart';
import '../../../helpers/json_fixtures.dart';

void main() {
  group('CurrentStepDocumentModel', () {
    test('fromJson parses minimal valid JSON without throwing', () {
      final json = JsonFixtures.wrapperResponse(data: {});
      expect(() => CurrentStepDocumentModel().fromJson(json), returnsNormally);
    });

    test('fromJson returns correct type', () {
      final json = JsonFixtures.wrapperResponse(data: {});
      final res = CurrentStepDocumentModel().fromJson(json);
      expect(res, isA<CurrentStepDocumentModel>());
    });

    test('toJson returns Map without throwing', () {
      final model = CurrentStepDocumentModel();
      final json = model.toJson();
      expect(json, isA<Map<String, dynamic>>());
    });

    test('round-trip does not throw', () {
      final json = JsonFixtures.wrapperResponse(data: {});
      final m = CurrentStepDocumentModel().fromJson(json) as CurrentStepDocumentModel;
      expect(() => m.toJson(), returnsNormally);
    });

    test('Contract: fromJson accepts wrapper with "succeeded" and "data" keys', () {
      final json = JsonFixtures.wrapperResponse(data: {});
      expect(json.containsKey('succeeded'), isTrue,
          reason: 'Contract expects input key "succeeded". Keys: ${json.keys.toList()}');
      expect(json.containsKey('data'), isTrue,
          reason: 'Contract expects input key "data". Keys: ${json.keys.toList()}');
      expect(() => CurrentStepDocumentModel().fromJson(json), returnsNormally);
    });
  });

  group('CurrentStepDocumentData', () {
    test('fromJson parses minimal valid JSON without throwing', () {
      final json = JsonFixtures.minimalMap();
      expect(() => CurrentStepDocumentData().fromJson(json), returnsNormally);
    });

    test('fromJson returns correct type', () {
      final json = JsonFixtures.minimalMap();
      final res = CurrentStepDocumentData().fromJson(json);
      expect(res, isA<CurrentStepDocumentData>());
    });

    test('toJson returns Map without throwing', () {
      final model = CurrentStepDocumentData();
      final json = model.toJson();
      expect(json, isA<Map<String, dynamic>>());
    });

    test('round-trip does not throw', () {
      final json = JsonFixtures.minimalMap();
      final m = CurrentStepDocumentData().fromJson(json) as CurrentStepDocumentData;
      expect(() => m.toJson(), returnsNormally);
    });
  });

  group('CurrentStepDocumentItem', () {
    test('fromJson parses minimal valid JSON without throwing', () {
      final json = JsonFixtures.minimalMap();
      expect(() => CurrentStepDocumentItem().fromJson(json), returnsNormally);
    });

    test('fromJson returns correct type', () {
      final json = JsonFixtures.minimalMap();
      final res = CurrentStepDocumentItem().fromJson(json);
      expect(res, isA<CurrentStepDocumentItem>());
    });

    test('toJson returns Map without throwing', () {
      final model = CurrentStepDocumentItem();
      final json = model.toJson();
      expect(json, isA<Map<String, dynamic>>());
    });

    test('round-trip does not throw', () {
      final json = JsonFixtures.minimalMap();
      final m = CurrentStepDocumentItem().fromJson(json) as CurrentStepDocumentItem;
      expect(() => m.toJson(), returnsNormally);
    });
  });

  group('StepDocumentItem', () {
    test('fromJson parses minimal valid JSON without throwing', () {
      final json = JsonFixtures.minimalMap();
      expect(() => StepDocumentItem().fromJson(json), returnsNormally);
    });

    test('fromJson returns correct type', () {
      final json = JsonFixtures.minimalMap();
      final res = StepDocumentItem().fromJson(json);
      expect(res, isA<StepDocumentItem>());
    });

    test('toJson returns Map without throwing', () {
      final model = StepDocumentItem();
      final json = model.toJson();
      expect(json, isA<Map<String, dynamic>>());
    });

    test('round-trip does not throw', () {
      final json = JsonFixtures.minimalMap();
      final m = StepDocumentItem().fromJson(json) as StepDocumentItem;
      expect(() => m.toJson(), returnsNormally);
    });
  });

  group('StepDocument', () {
    test('fromJson parses minimal valid JSON without throwing', () {
      final json = JsonFixtures.minimalMap();
      expect(() => StepDocument().fromJson(json), returnsNormally);
    });

    test('fromJson returns correct type', () {
      final json = JsonFixtures.minimalMap();
      final res = StepDocument().fromJson(json);
      expect(res, isA<StepDocument>());
    });

    test('toJson returns Map without throwing', () {
      final model = StepDocument();
      final json = model.toJson();
      expect(json, isA<Map<String, dynamic>>());
    });

    test('round-trip does not throw', () {
      final json = JsonFixtures.minimalMap();
      final m = StepDocument().fromJson(json) as StepDocument;
      expect(() => m.toJson(), returnsNormally);
    });
  });
}
