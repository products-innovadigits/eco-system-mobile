import 'package:flutter_test/flutter_test.dart';
import 'package:project_management/features/workflow_process_details/model/document_comments_model.dart';
import '../../../helpers/json_fixtures.dart';

void main() {
  group('DocumentCommentsModel', () {
    test('fromJson parses minimal valid JSON without throwing', () {
      final json = JsonFixtures.wrapperResponse(data: {});
      expect(() => DocumentCommentsModel().fromJson(json), returnsNormally);
    });

    test('fromJson returns correct type', () {
      final json = JsonFixtures.wrapperResponse(data: {});
      final res = DocumentCommentsModel().fromJson(json);
      expect(res, isA<DocumentCommentsModel>());
    });

    test('toJson returns Map without throwing', () {
      final model = DocumentCommentsModel();
      final json = model.toJson();
      expect(json, isA<Map<String, dynamic>>());
    });

    test('round-trip does not throw', () {
      final json = JsonFixtures.wrapperResponse(data: {});
      final m = DocumentCommentsModel().fromJson(json) as DocumentCommentsModel;
      expect(() => m.toJson(), returnsNormally);
    });

    test('Contract: fromJson accepts wrapper with "succeeded" and "data" keys', () {
      final json = JsonFixtures.wrapperResponse(data: {});
      expect(json.containsKey('succeeded'), isTrue,
          reason: 'Contract expects input key "succeeded". Keys: ${json.keys.toList()}');
      expect(json.containsKey('data'), isTrue,
          reason: 'Contract expects input key "data". Keys: ${json.keys.toList()}');
      expect(() => DocumentCommentsModel().fromJson(json), returnsNormally);
    });
  });

  group('CommentsData', () {
    test('fromJson parses minimal valid JSON without throwing', () {
      final json = JsonFixtures.minimalMap();
      expect(() => CommentsData.fromJson(json), returnsNormally);
    });

    test('fromJson returns correct type', () {
      final json = JsonFixtures.minimalMap();
      final res = CommentsData.fromJson(json);
      expect(res, isA<CommentsData>());
    });

    test('toJson returns Map without throwing', () {
      final model = CommentsData();
      final json = model.toJson();
      expect(json, isA<Map<String, dynamic>>());
    });

    test('round-trip does not throw', () {
      final json = JsonFixtures.minimalMap();
      final m = CommentsData.fromJson(json);
      expect(() => m.toJson(), returnsNormally);
    });
  });

  group('DocumentComment', () {
    test('fromJson parses minimal valid JSON without throwing', () {
      final json = JsonFixtures.minimalMap();
      expect(() => DocumentComment().fromJson(json), returnsNormally);
    });

    test('fromJson returns correct type', () {
      final json = JsonFixtures.minimalMap();
      final res = DocumentComment().fromJson(json);
      expect(res, isA<DocumentComment>());
    });

    test('toJson returns Map without throwing', () {
      final model = DocumentComment();
      final json = model.toJson();
      expect(json, isA<Map<String, dynamic>>());
    });

    test('round-trip does not throw', () {
      final json = JsonFixtures.minimalMap();
      final m = DocumentComment().fromJson(json) as DocumentComment;
      expect(() => m.toJson(), returnsNormally);
    });
  });
}
