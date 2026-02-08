import 'package:flutter_test/flutter_test.dart';
import 'package:project_management/features/workflow_process_details/model/history_model.dart';

import '../../../helpers/json_fixtures.dart';

void main() {
  group('HistoryResponseModel', () {
    test('fromJson parses minimal valid JSON without throwing', () {
      final json = JsonFixtures.wrapperResponse(data: []);
      expect(() => HistoryResponseModel().fromJson(json), returnsNormally);
    });

    test('fromJson returns correct type', () {
      final json = JsonFixtures.wrapperResponse(data: []);
      final res = HistoryResponseModel().fromJson(json);
      expect(res, isA<HistoryResponseModel>());
    });

    test('toJson returns Map without throwing', () {
      final model = HistoryResponseModel();
      final json = model.toJson();
      expect(json, isA<Map<String, dynamic>>());
    });

    test('round-trip does not throw', () {
      final json = JsonFixtures.wrapperResponse(data: []);
      final m = HistoryResponseModel().fromJson(json) as HistoryResponseModel;
      expect(() => m.toJson(), returnsNormally);
    });

    test(
      'Contract: fromJson accepts wrapper with "succeeded" and "data" keys',
      () {
        final json = JsonFixtures.wrapperResponse(data: []);
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
        expect(() => HistoryResponseModel().fromJson(json), returnsNormally);
      },
    );
  });

  group('HistoryItemModel', () {
    test('fromJson parses minimal valid JSON without throwing', () {
      final json = JsonFixtures.minimalMap();
      expect(() => HistoryItemModel().fromJson(json), returnsNormally);
    });

    test('fromJson returns correct type', () {
      final json = JsonFixtures.minimalMap();
      final res = HistoryItemModel().fromJson(json);
      expect(res, isA<HistoryItemModel>());
    });

    test('toJson returns Map without throwing', () {
      final model = HistoryItemModel();
      final json = model.toJson();
      expect(json, isA<Map<String, dynamic>>());
    });

    test('round-trip does not throw', () {
      final json = JsonFixtures.minimalMap();
      final m = HistoryItemModel().fromJson(json) as HistoryItemModel;
      expect(() => m.toJson(), returnsNormally);
    });
  });

  group('ResponsaiblUserModel', () {
    test('fromJson parses minimal valid JSON without throwing', () {
      final json = JsonFixtures.minimalMap();
      expect(() => ResponsaiblUserModel().fromJson(json), returnsNormally);
    });

    test('fromJson returns correct type', () {
      final json = JsonFixtures.minimalMap();
      final res = ResponsaiblUserModel().fromJson(json);
      expect(res, isA<ResponsaiblUserModel>());
    });

    test('toJson returns Map without throwing', () {
      final model = ResponsaiblUserModel();
      final json = model.toJson();
      expect(json, isA<Map<String, dynamic>>());
    });

    test('round-trip does not throw', () {
      final json = JsonFixtures.minimalMap();
      final m = ResponsaiblUserModel().fromJson(json) as ResponsaiblUserModel;
      expect(() => m.toJson(), returnsNormally);
    });
  });

  group('StepGroupModel', () {
    test('fromJson parses minimal valid JSON without throwing', () {
      final json = JsonFixtures.minimalMap();
      expect(() => StepGroupModel().fromJson(json), returnsNormally);
    });

    test('fromJson returns correct type', () {
      final json = JsonFixtures.minimalMap();
      final res = StepGroupModel().fromJson(json);
      expect(res, isA<StepGroupModel>());
    });

    test('toJson returns Map without throwing', () {
      final model = StepGroupModel();
      final json = model.toJson();
      expect(json, isA<Map<String, dynamic>>());
    });

    test('round-trip does not throw', () {
      final json = JsonFixtures.minimalMap();
      final m = StepGroupModel().fromJson(json) as StepGroupModel;
      expect(() => m.toJson(), returnsNormally);
    });
  });

  group('StepCommentModel', () {
    test('fromJson parses minimal valid JSON without throwing', () {
      final json = JsonFixtures.minimalMap();
      expect(() => StepCommentModel().fromJson(json), returnsNormally);
    });

    test('fromJson returns correct type', () {
      final json = JsonFixtures.minimalMap();
      final res = StepCommentModel().fromJson(json);
      expect(res, isA<StepCommentModel>());
    });

    test('toJson returns Map without throwing', () {
      final model = StepCommentModel();
      final json = model.toJson();
      expect(json, isA<Map<String, dynamic>>());
    });

    test('round-trip does not throw', () {
      final json = JsonFixtures.minimalMap();
      final m = StepCommentModel().fromJson(json) as StepCommentModel;
      expect(() => m.toJson(), returnsNormally);
    });
  });

  group('CommenterModel', () {
    test('fromJson parses minimal valid JSON without throwing', () {
      final json = JsonFixtures.minimalMap();
      expect(() => CommenterModel().fromJson(json), returnsNormally);
    });

    test('fromJson returns correct type', () {
      final json = JsonFixtures.minimalMap();
      final res = CommenterModel().fromJson(json);
      expect(res, isA<CommenterModel>());
    });

    test('toJson returns Map without throwing', () {
      final model = CommenterModel();
      final json = model.toJson();
      expect(json, isA<Map<String, dynamic>>());
    });

    test('round-trip does not throw', () {
      final json = JsonFixtures.minimalMap();
      final m = CommenterModel().fromJson(json) as CommenterModel;
      expect(() => m.toJson(), returnsNormally);
    });
  });

  group('AttachmentModel', () {
    test('fromJson parses minimal valid JSON without throwing', () {
      final json = JsonFixtures.minimalMap();
      expect(() => AttachmentModel().fromJson(json), returnsNormally);
    });

    test('fromJson returns correct type', () {
      final json = JsonFixtures.minimalMap();
      final res = AttachmentModel().fromJson(json);
      expect(res, isA<AttachmentModel>());
    });

    test('toJson returns Map without throwing', () {
      final model = AttachmentModel();
      final json = model.toJson();
      expect(json, isA<Map<String, dynamic>>());
    });

    test('round-trip does not throw', () {
      final json = JsonFixtures.minimalMap();
      final m = AttachmentModel().fromJson(json) as AttachmentModel;
      expect(() => m.toJson(), returnsNormally);
    });
  });

  group('SliceModel', () {
    test('fromJson parses minimal valid JSON without throwing', () {
      final json = JsonFixtures.minimalMap();
      expect(() => SliceModel().fromJson(json), returnsNormally);
    });

    test('fromJson returns correct type', () {
      final json = JsonFixtures.minimalMap();
      final res = SliceModel().fromJson(json);
      expect(res, isA<SliceModel>());
    });

    test('toJson returns Map without throwing', () {
      final model = SliceModel();
      final json = model.toJson();
      expect(json, isA<Map<String, dynamic>>());
    });

    test('round-trip does not throw', () {
      final json = JsonFixtures.minimalMap();
      final m = SliceModel().fromJson(json) as SliceModel;
      expect(() => m.toJson(), returnsNormally);
    });
  });
}
